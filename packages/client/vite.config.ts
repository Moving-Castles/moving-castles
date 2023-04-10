import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [svelte()],
  publicDir: "./src/public",
  server: {
    port: 3000,
    fs: {
      strict: false,
    },
  },
  optimizeDeps: {
    esbuildOptions: {
      target: "es2022",
    },
    // exclude: ["@latticexyz/network", "@latticexyz/noise"],
    // include: [
    //   "proxy-deep",
    //   "ethers/lib/utils",
    //   "bn.js",
    //   "js-sha3",
    //   "hash.js",
    //   "bech32",
    //   "long",
    //   "protobufjs/minimal",
    //   "debug",
    //   "is-observable",
    //   "nice-grpc-web",
    //   "@improbable-eng/grpc-web",
    //   "threads"
    // ],
  },
  build: {
    rollupOptions: {
      // TODO: revisit this config after splitting out mud config dependencies
      // from the cli package so we don't need to bundle the cli package
      external: ["chalk", "locate-path", "path-exists", "find-up"],
    },
    target: "es2022",
  },
  define: {
    "process.env": {},
  },
});
