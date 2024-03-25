import redisDriver from "unstorage/drivers/redis"

export default defineNitroPlugin(() => {
    const storage = useStorage()
  
    if (process.env.NODE_ENV === "production") {
      const driver = redisDriver({
        base: "redis",
        host: useRuntimeConfig().redis_host || "localhost",
        port: useRuntimeConfig().redis_port ? parseInt(useRuntimeConfig().redis_port) : 6379,
        password: useRuntimeConfig().redis_password,
      })
  
      storage.mount("redis", driver)
    }
})