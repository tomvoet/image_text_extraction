<script setup lang="ts">
const colorMode = useColorMode()

// Computed property to determine if the current color mode is dark
const isDark = computed({
    get() {
        return colorMode.value === 'dark'
    },
    set() {
        colorMode.preference = colorMode.value === 'dark' ? 'light' : 'dark'
    }
})
</script>

<template>
    <ClientOnly>
        <UButton :icon="isDark ? 'i-heroicons-moon-20-solid' : 'i-heroicons-sun-20-solid'" color="gray" variant="ghost"
            class="fixed top-4 right-4" aria-label="Theme" @click="isDark = !isDark" />
        <template #fallback>
            <div class="w-8 h-8" />
        </template>
    </ClientOnly>
</template>
