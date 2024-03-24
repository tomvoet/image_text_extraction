<script setup lang="ts">
import type { ExtractTextRequest } from "~/utils/types";

const file = ref<File | null>(null)
const text = ref<string>("")
const loading = ref(false)

const toast = useToast()

const extractText = async () => {
  if (file.value) {
    loading.value = true
    text.value = ""

    const mimeType = file.value.type
    const base64 = await toBase64(file.value)

    const data = base64.replace(/^data:image\/(png|jpeg|jpg);base64,/, '')

    const stream = await $fetch<ReadableStream>("/api/extract", {
      method: "POST",
      responseType: "stream",
      body: {
        data,
        mimeType,
      } as ExtractTextRequest
    })

    const reader = stream.getReader()

    while (true) {
      const { done, value } = await reader.read()

      if (done) {
        toast.add({
          color: 'green',
          title: 'Text extracted successfully',
        });

        loading.value = false

        break
      }

      text.value += new TextDecoder().decode(value)
    }

  } else {
    toast.add({
      color: 'red',
      title: 'No file selected',
    });
  }
}
</script>

<template>
  <div>
    <section>
      <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 lg:px-12">
        <a href="#"
          class="inline-flex justify-between items-center py-1 px-1 pr-4 mb-7 text-sm text-gray-700 bg-gray-100 rounded-full dark:bg-gray-800 dark:text-white hover:bg-gray-200 dark:hover:bg-gray-700"
          role="alert">
          <span class="text-xs bg-primary-600 rounded-full text-white px-4 py-1.5 mr-3">New</span> <span
            class="text-sm font-medium">Now supports streaming text extraction</span>
          <svg class="ml-2 w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
            <path fill-rule="evenodd"
              d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
              clip-rule="evenodd"></path>
          </svg>
        </a>
        <h1
          class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
          Image Text Extraction</h1>
        <p class="mb-8 text-lg font-normal text-gray-500 lg:text-xl sm:px-16 xl:px-48 dark:text-gray-400">
          An image text extraction tool that allows you to extract text from images and convert it to a text file. This
          tool is useful for extracting text from images that contain text, such as scanned documents, or images with
          text.
        </p>
      </div>
    </section>
    <UContainer>
      <FileUpload v-model="file" />
      <UDivider class="my-8">
        <UButton @click="extractText" size="xl" variant="soft" icon="i-heroicons-document-text">
          Extract Text
        </UButton>
      </UDivider>
      <OutputDisplay v-model="text" :loading="loading" />
    </UContainer>
  </div>
</template>
