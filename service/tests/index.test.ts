import { describe, expect, it,  } from "vitest"
import { setup, $fetch, isDev } from '@nuxt/test-utils'
import { fileURLToPath } from "url"

describe("Main Page", async () => {
    await setup({
        rootDir: fileURLToPath(new URL('..', import.meta.url)),
    })

    it('Renders Title', async () => {
      expect(await $fetch('/')).toMatch('Image Text Extraction')
    })

    it('Renders Image Upload', async () => {
        expect(await $fetch('/')).toMatch('Click to upload')
    })

    it('Renders Extract Button', async () => {
        expect(await $fetch('/')).toMatch('Extract Text')
    })
})