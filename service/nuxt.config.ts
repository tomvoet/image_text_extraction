// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  modules: ["@nuxt/ui", "@vueuse/nuxt"],
  runtimeConfig: {
    "project_id": "",
    "private_key_id": "",
    "private_key": "",
    "client_email": "",
    "client_id": "",
    "universe_domain": "",
    "redis_host": "",
    "redis_port": "",
    "redis_password": "",
  },
  nitro: {
    storage: {
      redis: {
        driver: "redis",
        port: process.env.NUXT_REDIS_PORT,
        host: process.env.NUXT_REDIS_HOST,
        password: process.env.NUXT_REDIS_PASSWORD,
      }
    },
  },
  devServer: {
    host: process.env.NODE_ENV === "production" ? "0.0.0.0" : undefined,
  }
})