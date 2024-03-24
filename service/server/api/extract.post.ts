import { VertexAI, HarmCategory, HarmBlockThreshold } from "@google-cloud/vertexai"
import { ExtractTextRequest } from "~/utils/types"
import { hash } from "ohash"


const location = "us-central1"
const visionModel = 'gemini-1.0-pro-vision-001'
// nitro storage layer + paas redis as cache

export default defineEventHandler(async (event) => {
    const redis = useStorage("redis")
    const body = await readBody<ExtractTextRequest>(event)
    const { mimeType: mime_type, data } = body

    const key = hash(data)

    const cachedText = await redis.getItem(key)

    if (cachedText) {
        const stream = new ReadableStream({
            start(controller) {
                controller.enqueue(cachedText)
                controller.close()
            }
        })

        return sendStream(event, stream)
    }

    const config = useRuntimeConfig()

    const { project_id, private_key_id, private_key, client_email, client_id, universe_domain } = config

    // Replace escaped newlines with actual newlines (weird .env behavior)
    const clean_private_key = private_key.replace(/\\n/g, "\n")

    const vertexAi = new VertexAI({project: project_id, location, googleAuthOptions: {
        credentials: {
            project_id,
            private_key_id,
            private_key: clean_private_key,
            client_email,
            client_id,
            universe_domain
        }
    }})

    const model = vertexAi.preview.getGenerativeModel({
        model: visionModel,
        generation_config: {
            max_output_tokens: 1024,
            temperature: 0.4,
            top_p: 1,
            top_k: 32
        },
        safety_settings: [
            {
                category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
                threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE
            },
            {
                category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
                threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE
            },
            {
                category: HarmCategory.HARM_CATEGORY_HARASSMENT,
                threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE
            },
        ]
    })

    const reqBody = {
        contents: [
            {
                role: "user",
                parts: [
                    {
                        text: "Read the text in this image."
                    },
                    {
                        inline_data: {
                            mime_type,
                            data
                        }
                    }
                ]
            }
        ]
    }

    const res = await model.generateContentStream(reqBody)

    

    const stream = new ReadableStream({
        async start(controller) {
            for await (const chunk of res.stream) {
                const text = chunk.candidates.reduce((acc, candidate) => {
                    return acc + candidate.content.parts.reduce((acc, part) => {
                        return acc + part.text
                    }, "")
                }, "")

                const isFinish = chunk.candidates.some(candidate => candidate.finishReason || candidate.finishMessage)
                controller.enqueue(text)

                if (isFinish) {
                    controller.close()
                }
            }
        },
    })

    res.response.then((response) => {
        const text = response.candidates.reduce((acc, candidate) => {
            return acc + candidate.content.parts.reduce((acc, part) => {
                return acc + part.text
            }, "")
        }, "")

        redis.setItem(key, text)
    })

    return sendStream(event, stream)
})
