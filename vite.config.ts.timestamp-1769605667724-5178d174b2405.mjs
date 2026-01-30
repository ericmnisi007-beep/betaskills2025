// vite.config.ts
import { defineConfig } from "file:///C:/Users/Patrick/Downloads/Skillslaunch-main%20(1)/Skillslaunch-main/node_modules/vite/dist/node/index.js";
import react from "file:///C:/Users/Patrick/Downloads/Skillslaunch-main%20(1)/Skillslaunch-main/node_modules/@vitejs/plugin-react-swc/index.js";
import path from "path";
import { componentTagger } from "file:///C:/Users/Patrick/Downloads/Skillslaunch-main%20(1)/Skillslaunch-main/node_modules/lovable-tagger/dist/index.js";

// package.json
var package_default = {
  name: "vite_react_shadcn_ts",
  private: true,
  version: "0.0.0",
  type: "module",
  engines: {
    node: ">=18.0.0"
  },
  scripts: {
    dev: "vite",
    build: "tsc && vite build --mode production",
    "build:dev": "vite build --mode development",
    "build:analyze": "npm run build && npm run analyze:bundle",
    "analyze:bundle": "npx vite-bundle-analyzer dist/assets/*.js",
    "analyze:size": "npm run build && node scripts/bundle-analyzer.js",
    lint: "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    preview: "vite preview",
    test: "vitest",
    "test:run": "vitest run",
    "test:ui": "vitest --ui",
    "test:production-flows": "vitest run --config vitest.config.production-flows.ts",
    "test:production-flows:ui": "vitest --ui --config vitest.config.production-flows.ts",
    "test:production-flows:coverage": "vitest run --config vitest.config.production-flows.ts --coverage",
    "test:production-flows:runner": "tsx src/test/production-flows-test-runner.ts",
    "test:migration": "vitest run --config vitest.config.migration.ts",
    "test:migration:ui": "vitest --ui --config vitest.config.migration.ts",
    "test:migration:coverage": "vitest run --config vitest.config.migration.ts --coverage",
    "populate-db": "node scripts/populate-database.js",
    "validate:production": "VITE_RUN_VALIDATION=true vite build --mode production --config vite.config.validation.ts",
    "config:check": `node -e "console.log('Environment:', process.env.NODE_ENV || 'development'); console.log('Ikhokha API URL:', process.env.VITE_IKHOKHA_API_URL); console.log('Test Mode:', process.env.VITE_IKHOKHA_TEST_MODE);"`,
    "webhook:setup": "tsx src/scripts/setupProductionWebhooks.ts setup",
    "webhook:validate": "tsx src/scripts/setupProductionWebhooks.ts validate",
    "webhook:test": "tsx src/scripts/setupProductionWebhooks.ts test",
    "webhook:list": "tsx src/scripts/setupProductionWebhooks.ts list",
    "webhook:validate-setup": "tsx src/scripts/validateWebhookSetup.ts",
    "test:card-payment": "node scripts/run-card-payment-tests.js",
    "test:card-payment:comprehensive": "vitest run src/test/card-payment-comprehensive.test.ts --config vitest.config.card-payment.ts",
    "test:card-payment:e2e": "vitest run src/test/e2e/card-payment-flow.e2e.test.ts --config vitest.config.card-payment.ts",
    "test:card-payment:webhook": "vitest run src/test/webhook/webhook-simulation.test.ts --config vitest.config.card-payment.ts",
    "test:card-payment:realtime": "vitest run src/test/realtime/multi-tab-sync.test.ts --config vitest.config.card-payment.ts",
    "test:card-payment:performance": "vitest run src/test/performance/high-volume-processing.test.ts --config vitest.config.card-payment.ts",
    "test:card-payment:coverage": "vitest run --config vitest.config.card-payment.ts --coverage",
    "verify:deployment": "node scripts/verify-deployment.js",
    "test:deployment": "vitest run src/test/deployment/card-payment-deployment-verification.test.ts",
    push: 'git add . && git commit -m "Updated enrollment system with email confirmation and instructor approval flow" && git push origin main'
  },
  dependencies: {
    "@hookform/resolvers": "^3.9.0",
    "@radix-ui/react-accordion": "^1.2.0",
    "@radix-ui/react-alert-dialog": "^1.1.1",
    "@radix-ui/react-aspect-ratio": "^1.1.0",
    "@radix-ui/react-avatar": "^1.1.0",
    "@radix-ui/react-checkbox": "^1.1.1",
    "@radix-ui/react-collapsible": "^1.1.0",
    "@radix-ui/react-context-menu": "^2.2.1",
    "@radix-ui/react-dialog": "^1.1.2",
    "@radix-ui/react-dropdown-menu": "^2.1.1",
    "@radix-ui/react-hover-card": "^1.1.1",
    "@radix-ui/react-label": "^2.1.0",
    "@radix-ui/react-menubar": "^1.1.1",
    "@radix-ui/react-navigation-menu": "^1.2.0",
    "@radix-ui/react-popover": "^1.1.1",
    "@radix-ui/react-progress": "^1.1.0",
    "@radix-ui/react-radio-group": "^1.2.0",
    "@radix-ui/react-scroll-area": "^1.1.0",
    "@radix-ui/react-select": "^2.1.1",
    "@radix-ui/react-separator": "^1.1.0",
    "@radix-ui/react-slider": "^1.2.0",
    "@radix-ui/react-slot": "^1.1.0",
    "@radix-ui/react-switch": "^1.1.0",
    "@radix-ui/react-tabs": "^1.1.0",
    "@radix-ui/react-toast": "^1.2.1",
    "@radix-ui/react-toggle": "^1.1.0",
    "@radix-ui/react-toggle-group": "^1.1.0",
    "@radix-ui/react-tooltip": "^1.1.4",
    "@supabase/supabase-js": "^2.49.8",
    "@tanstack/react-query": "^5.56.2",
    "@types/react-window": "^1.8.8",
    "@types/uuid": "^10.0.0",
    "class-variance-authority": "^0.7.1",
    clsx: "^2.1.1",
    cmdk: "^1.0.0",
    "date-fns": "^3.6.0",
    dotenv: "^17.2.1",
    "embla-carousel-react": "^8.3.0",
    esbuild: "^0.25.8",
    "framer-motion": "^11.18.2",
    "input-otp": "^1.2.4",
    "lucide-react": "^0.462.0",
    "next-themes": "^0.3.0",
    react: "^18.3.1",
    "react-day-picker": "^8.10.1",
    "react-dom": "^18.3.1",
    "react-hook-form": "^7.53.0",
    "react-markdown": "^10.1.0",
    "react-resizable-panels": "^2.1.3",
    "react-router-dom": "^6.26.2",
    "react-window": "^2.1.0",
    recharts: "^2.12.7",
    "rehype-raw": "^7.0.0",
    "remark-gfm": "^4.0.1",
    sonner: "^1.5.0",
    "tailwind-merge": "^2.5.2",
    "tailwindcss-animate": "^1.0.7",
    uuid: "^11.1.0",
    vaul: "^0.9.3",
    zod: "^3.23.8"
  },
  devDependencies: {
    "@eslint/js": "^9.9.0",
    "@tailwindcss/typography": "^0.5.15",
    "@testing-library/jest-dom": "^6.8.0",
    "@testing-library/react": "^16.3.0",
    "@testing-library/user-event": "^14.6.1",
    "@types/node": "^22.5.5",
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react-swc": "^3.11.0",
    "@vitest/ui": "^3.2.4",
    autoprefixer: "^10.4.20",
    eslint: "^9.9.0",
    "eslint-plugin-react-hooks": "^5.1.0-rc.0",
    "eslint-plugin-react-refresh": "^0.4.9",
    "fast-check": "^4.3.0",
    globals: "^15.9.0",
    jsdom: "^27.0.0",
    "lovable-tagger": "^1.1.7",
    postcss: "^8.4.47",
    tailwindcss: "^3.4.11",
    typescript: "^5.9.3",
    "typescript-eslint": "^8.0.1",
    vite: "^5.4.21",
    "vite-bundle-analyzer": "^0.7.0",
    vitest: "^3.2.4"
  }
};

// vite.config.ts
var __vite_injected_original_dirname = "C:\\Users\\Patrick\\Downloads\\Skillslaunch-main (1)\\Skillslaunch-main";
var vite_config_default = defineConfig(({ mode }) => ({
  server: {
    host: "localhost",
    port: 3e3,
    strictPort: false,
    open: true
  },
  plugins: [
    react(),
    mode === "development" && componentTagger()
  ].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__vite_injected_original_dirname, "./src")
    }
  },
  define: {
    global: "globalThis"
  },
  build: {
    rollupOptions: {
      output: {
        // Minimal chunking to prevent React issues
        manualChunks: {
          // Keep React and all related dependencies in one chunk
          "vendor-react": ["react", "react-dom", "react-router-dom", "react/jsx-runtime"],
          "vendor-supabase": ["@supabase/supabase-js"],
          "vendor-ui": Object.keys(package_default.dependencies).filter((dep) => dep.startsWith("@radix-ui"))
        },
        chunkFileNames: "assets/[name]-[hash].js",
        entryFileNames: "assets/[name]-[hash].js",
        assetFileNames: "assets/[name]-[hash].[ext]"
      }
    },
    sourcemap: mode === "development",
    chunkSizeWarningLimit: 2e3,
    minify: mode === "production" ? "esbuild" : false,
    target: "es2020",
    // More modern target for better compatibility
    // Enable tree shaking
    treeshake: true
  },
  optimizeDeps: {
    include: [
      "react",
      "react-dom",
      "react/jsx-runtime",
      "react/jsx-dev-runtime",
      "react-router-dom",
      "@supabase/supabase-js"
    ],
    force: true
    // Force re-optimization
  },
  esbuild: {
    // Remove console statements and debugger in production
    ...mode === "production" && {
      drop: ["console", "debugger"]
    }
  }
}));
export {
  vite_config_default as default
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidml0ZS5jb25maWcudHMiLCAicGFja2FnZS5qc29uIl0sCiAgInNvdXJjZXNDb250ZW50IjogWyJjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfZGlybmFtZSA9IFwiQzpcXFxcVXNlcnNcXFxcUGF0cmlja1xcXFxEb3dubG9hZHNcXFxcU2tpbGxzbGF1bmNoLW1haW4gKDEpXFxcXFNraWxsc2xhdW5jaC1tYWluXCI7Y29uc3QgX192aXRlX2luamVjdGVkX29yaWdpbmFsX2ZpbGVuYW1lID0gXCJDOlxcXFxVc2Vyc1xcXFxQYXRyaWNrXFxcXERvd25sb2Fkc1xcXFxTa2lsbHNsYXVuY2gtbWFpbiAoMSlcXFxcU2tpbGxzbGF1bmNoLW1haW5cXFxcdml0ZS5jb25maWcudHNcIjtjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfaW1wb3J0X21ldGFfdXJsID0gXCJmaWxlOi8vL0M6L1VzZXJzL1BhdHJpY2svRG93bmxvYWRzL1NraWxsc2xhdW5jaC1tYWluJTIwKDEpL1NraWxsc2xhdW5jaC1tYWluL3ZpdGUuY29uZmlnLnRzXCI7aW1wb3J0IHsgZGVmaW5lQ29uZmlnIH0gZnJvbSBcInZpdGVcIjtcbmltcG9ydCByZWFjdCBmcm9tIFwiQHZpdGVqcy9wbHVnaW4tcmVhY3Qtc3djXCI7XG5pbXBvcnQgcGF0aCBmcm9tIFwicGF0aFwiO1xuaW1wb3J0IHsgY29tcG9uZW50VGFnZ2VyIH0gZnJvbSBcImxvdmFibGUtdGFnZ2VyXCI7XG5pbXBvcnQgcGFja2FnZUpzb24gZnJvbSBcIi4vcGFja2FnZS5qc29uXCI7XG5cbi8vIGh0dHBzOi8vdml0ZWpzLmRldi9jb25maWcvXG5leHBvcnQgZGVmYXVsdCBkZWZpbmVDb25maWcoKHsgbW9kZSB9KSA9PiAoe1xuICBzZXJ2ZXI6IHtcbiAgICBob3N0OiBcImxvY2FsaG9zdFwiLFxuICAgIHBvcnQ6IDMwMDAsXG4gICAgc3RyaWN0UG9ydDogZmFsc2UsXG4gICAgb3BlbjogdHJ1ZSxcbiAgfSxcbiAgcGx1Z2luczogW1xuICAgIHJlYWN0KCksXG4gICAgbW9kZSA9PT0gJ2RldmVsb3BtZW50JyAmJiBjb21wb25lbnRUYWdnZXIoKSxcbiAgXS5maWx0ZXIoQm9vbGVhbiksXG4gIHJlc29sdmU6IHtcbiAgICBhbGlhczoge1xuICAgICAgXCJAXCI6IHBhdGgucmVzb2x2ZShfX2Rpcm5hbWUsIFwiLi9zcmNcIiksXG4gICAgfSxcbiAgfSxcbiAgZGVmaW5lOiB7XG4gICAgZ2xvYmFsOiAnZ2xvYmFsVGhpcycsXG4gIH0sXG4gIGJ1aWxkOiB7XG4gICAgcm9sbHVwT3B0aW9uczoge1xuICAgICAgb3V0cHV0OiB7XG4gICAgICAgIC8vIE1pbmltYWwgY2h1bmtpbmcgdG8gcHJldmVudCBSZWFjdCBpc3N1ZXNcbiAgICAgICAgbWFudWFsQ2h1bmtzOiB7XG4gICAgICAgICAgLy8gS2VlcCBSZWFjdCBhbmQgYWxsIHJlbGF0ZWQgZGVwZW5kZW5jaWVzIGluIG9uZSBjaHVua1xuICAgICAgICAgICd2ZW5kb3ItcmVhY3QnOiBbJ3JlYWN0JywgJ3JlYWN0LWRvbScsICdyZWFjdC1yb3V0ZXItZG9tJywgJ3JlYWN0L2pzeC1ydW50aW1lJ10sXG4gICAgICAgICAgJ3ZlbmRvci1zdXBhYmFzZSc6IFsnQHN1cGFiYXNlL3N1cGFiYXNlLWpzJ10sXG4gICAgICAgICAgJ3ZlbmRvci11aSc6IE9iamVjdC5rZXlzKHBhY2thZ2VKc29uLmRlcGVuZGVuY2llcykuZmlsdGVyKGRlcCA9PiBkZXAuc3RhcnRzV2l0aCgnQHJhZGl4LXVpJykpLFxuICAgICAgICB9LFxuICAgICAgICBjaHVua0ZpbGVOYW1lczogJ2Fzc2V0cy9bbmFtZV0tW2hhc2hdLmpzJyxcbiAgICAgICAgZW50cnlGaWxlTmFtZXM6ICdhc3NldHMvW25hbWVdLVtoYXNoXS5qcycsXG4gICAgICAgIGFzc2V0RmlsZU5hbWVzOiAnYXNzZXRzL1tuYW1lXS1baGFzaF0uW2V4dF0nXG4gICAgICB9LFxuICAgIH0sXG4gICAgc291cmNlbWFwOiBtb2RlID09PSAnZGV2ZWxvcG1lbnQnLFxuICAgIGNodW5rU2l6ZVdhcm5pbmdMaW1pdDogMjAwMCxcbiAgICBtaW5pZnk6IG1vZGUgPT09ICdwcm9kdWN0aW9uJyA/ICdlc2J1aWxkJyA6IGZhbHNlLFxuICAgIHRhcmdldDogJ2VzMjAyMCcsIC8vIE1vcmUgbW9kZXJuIHRhcmdldCBmb3IgYmV0dGVyIGNvbXBhdGliaWxpdHlcbiAgICAvLyBFbmFibGUgdHJlZSBzaGFraW5nXG4gICAgdHJlZXNoYWtlOiB0cnVlLFxuICB9LFxuICBvcHRpbWl6ZURlcHM6IHtcbiAgICBpbmNsdWRlOiBbXG4gICAgICAncmVhY3QnLCBcbiAgICAgICdyZWFjdC1kb20nLCBcbiAgICAgICdyZWFjdC9qc3gtcnVudGltZScsXG4gICAgICAncmVhY3QvanN4LWRldi1ydW50aW1lJyxcbiAgICAgICdyZWFjdC1yb3V0ZXItZG9tJyxcbiAgICAgICdAc3VwYWJhc2Uvc3VwYWJhc2UtanMnXG4gICAgXSxcbiAgICBmb3JjZTogdHJ1ZSwgLy8gRm9yY2UgcmUtb3B0aW1pemF0aW9uXG4gIH0sXG4gIGVzYnVpbGQ6IHtcbiAgICAvLyBSZW1vdmUgY29uc29sZSBzdGF0ZW1lbnRzIGFuZCBkZWJ1Z2dlciBpbiBwcm9kdWN0aW9uXG4gICAgLi4uKG1vZGUgPT09ICdwcm9kdWN0aW9uJyAmJiB7XG4gICAgICBkcm9wOiBbJ2NvbnNvbGUnLCAnZGVidWdnZXInXSxcbiAgICB9KSxcbiAgfSxcbn0pKTtcbiIsICJ7XG4gIFwibmFtZVwiOiBcInZpdGVfcmVhY3Rfc2hhZGNuX3RzXCIsXG4gIFwicHJpdmF0ZVwiOiB0cnVlLFxuICBcInZlcnNpb25cIjogXCIwLjAuMFwiLFxuICBcInR5cGVcIjogXCJtb2R1bGVcIixcbiAgXCJlbmdpbmVzXCI6IHtcbiAgICBcIm5vZGVcIjogXCI+PTE4LjAuMFwiXG4gIH0sXG4gIFwic2NyaXB0c1wiOiB7XG4gICAgXCJkZXZcIjogXCJ2aXRlXCIsXG4gICAgXCJidWlsZFwiOiBcInRzYyAmJiB2aXRlIGJ1aWxkIC0tbW9kZSBwcm9kdWN0aW9uXCIsXG4gICAgXCJidWlsZDpkZXZcIjogXCJ2aXRlIGJ1aWxkIC0tbW9kZSBkZXZlbG9wbWVudFwiLFxuICAgIFwiYnVpbGQ6YW5hbHl6ZVwiOiBcIm5wbSBydW4gYnVpbGQgJiYgbnBtIHJ1biBhbmFseXplOmJ1bmRsZVwiLFxuICAgIFwiYW5hbHl6ZTpidW5kbGVcIjogXCJucHggdml0ZS1idW5kbGUtYW5hbHl6ZXIgZGlzdC9hc3NldHMvKi5qc1wiLFxuICAgIFwiYW5hbHl6ZTpzaXplXCI6IFwibnBtIHJ1biBidWlsZCAmJiBub2RlIHNjcmlwdHMvYnVuZGxlLWFuYWx5emVyLmpzXCIsXG4gICAgXCJsaW50XCI6IFwiZXNsaW50IC4gLS1leHQgdHMsdHN4IC0tcmVwb3J0LXVudXNlZC1kaXNhYmxlLWRpcmVjdGl2ZXMgLS1tYXgtd2FybmluZ3MgMFwiLFxuICAgIFwicHJldmlld1wiOiBcInZpdGUgcHJldmlld1wiLFxuICAgIFwidGVzdFwiOiBcInZpdGVzdFwiLFxuICAgIFwidGVzdDpydW5cIjogXCJ2aXRlc3QgcnVuXCIsXG4gICAgXCJ0ZXN0OnVpXCI6IFwidml0ZXN0IC0tdWlcIixcbiAgICBcInRlc3Q6cHJvZHVjdGlvbi1mbG93c1wiOiBcInZpdGVzdCBydW4gLS1jb25maWcgdml0ZXN0LmNvbmZpZy5wcm9kdWN0aW9uLWZsb3dzLnRzXCIsXG4gICAgXCJ0ZXN0OnByb2R1Y3Rpb24tZmxvd3M6dWlcIjogXCJ2aXRlc3QgLS11aSAtLWNvbmZpZyB2aXRlc3QuY29uZmlnLnByb2R1Y3Rpb24tZmxvd3MudHNcIixcbiAgICBcInRlc3Q6cHJvZHVjdGlvbi1mbG93czpjb3ZlcmFnZVwiOiBcInZpdGVzdCBydW4gLS1jb25maWcgdml0ZXN0LmNvbmZpZy5wcm9kdWN0aW9uLWZsb3dzLnRzIC0tY292ZXJhZ2VcIixcbiAgICBcInRlc3Q6cHJvZHVjdGlvbi1mbG93czpydW5uZXJcIjogXCJ0c3ggc3JjL3Rlc3QvcHJvZHVjdGlvbi1mbG93cy10ZXN0LXJ1bm5lci50c1wiLFxuICAgIFwidGVzdDptaWdyYXRpb25cIjogXCJ2aXRlc3QgcnVuIC0tY29uZmlnIHZpdGVzdC5jb25maWcubWlncmF0aW9uLnRzXCIsXG4gICAgXCJ0ZXN0Om1pZ3JhdGlvbjp1aVwiOiBcInZpdGVzdCAtLXVpIC0tY29uZmlnIHZpdGVzdC5jb25maWcubWlncmF0aW9uLnRzXCIsXG4gICAgXCJ0ZXN0Om1pZ3JhdGlvbjpjb3ZlcmFnZVwiOiBcInZpdGVzdCBydW4gLS1jb25maWcgdml0ZXN0LmNvbmZpZy5taWdyYXRpb24udHMgLS1jb3ZlcmFnZVwiLFxuICAgIFwicG9wdWxhdGUtZGJcIjogXCJub2RlIHNjcmlwdHMvcG9wdWxhdGUtZGF0YWJhc2UuanNcIixcbiAgICBcInZhbGlkYXRlOnByb2R1Y3Rpb25cIjogXCJWSVRFX1JVTl9WQUxJREFUSU9OPXRydWUgdml0ZSBidWlsZCAtLW1vZGUgcHJvZHVjdGlvbiAtLWNvbmZpZyB2aXRlLmNvbmZpZy52YWxpZGF0aW9uLnRzXCIsXG4gICAgXCJjb25maWc6Y2hlY2tcIjogXCJub2RlIC1lIFxcXCJjb25zb2xlLmxvZygnRW52aXJvbm1lbnQ6JywgcHJvY2Vzcy5lbnYuTk9ERV9FTlYgfHwgJ2RldmVsb3BtZW50Jyk7IGNvbnNvbGUubG9nKCdJa2hva2hhIEFQSSBVUkw6JywgcHJvY2Vzcy5lbnYuVklURV9JS0hPS0hBX0FQSV9VUkwpOyBjb25zb2xlLmxvZygnVGVzdCBNb2RlOicsIHByb2Nlc3MuZW52LlZJVEVfSUtIT0tIQV9URVNUX01PREUpO1xcXCJcIixcbiAgICBcIndlYmhvb2s6c2V0dXBcIjogXCJ0c3ggc3JjL3NjcmlwdHMvc2V0dXBQcm9kdWN0aW9uV2ViaG9va3MudHMgc2V0dXBcIixcbiAgICBcIndlYmhvb2s6dmFsaWRhdGVcIjogXCJ0c3ggc3JjL3NjcmlwdHMvc2V0dXBQcm9kdWN0aW9uV2ViaG9va3MudHMgdmFsaWRhdGVcIixcbiAgICBcIndlYmhvb2s6dGVzdFwiOiBcInRzeCBzcmMvc2NyaXB0cy9zZXR1cFByb2R1Y3Rpb25XZWJob29rcy50cyB0ZXN0XCIsXG4gICAgXCJ3ZWJob29rOmxpc3RcIjogXCJ0c3ggc3JjL3NjcmlwdHMvc2V0dXBQcm9kdWN0aW9uV2ViaG9va3MudHMgbGlzdFwiLFxuICAgIFwid2ViaG9vazp2YWxpZGF0ZS1zZXR1cFwiOiBcInRzeCBzcmMvc2NyaXB0cy92YWxpZGF0ZVdlYmhvb2tTZXR1cC50c1wiLFxuICAgIFwidGVzdDpjYXJkLXBheW1lbnRcIjogXCJub2RlIHNjcmlwdHMvcnVuLWNhcmQtcGF5bWVudC10ZXN0cy5qc1wiLFxuICAgIFwidGVzdDpjYXJkLXBheW1lbnQ6Y29tcHJlaGVuc2l2ZVwiOiBcInZpdGVzdCBydW4gc3JjL3Rlc3QvY2FyZC1wYXltZW50LWNvbXByZWhlbnNpdmUudGVzdC50cyAtLWNvbmZpZyB2aXRlc3QuY29uZmlnLmNhcmQtcGF5bWVudC50c1wiLFxuICAgIFwidGVzdDpjYXJkLXBheW1lbnQ6ZTJlXCI6IFwidml0ZXN0IHJ1biBzcmMvdGVzdC9lMmUvY2FyZC1wYXltZW50LWZsb3cuZTJlLnRlc3QudHMgLS1jb25maWcgdml0ZXN0LmNvbmZpZy5jYXJkLXBheW1lbnQudHNcIixcbiAgICBcInRlc3Q6Y2FyZC1wYXltZW50OndlYmhvb2tcIjogXCJ2aXRlc3QgcnVuIHNyYy90ZXN0L3dlYmhvb2svd2ViaG9vay1zaW11bGF0aW9uLnRlc3QudHMgLS1jb25maWcgdml0ZXN0LmNvbmZpZy5jYXJkLXBheW1lbnQudHNcIixcbiAgICBcInRlc3Q6Y2FyZC1wYXltZW50OnJlYWx0aW1lXCI6IFwidml0ZXN0IHJ1biBzcmMvdGVzdC9yZWFsdGltZS9tdWx0aS10YWItc3luYy50ZXN0LnRzIC0tY29uZmlnIHZpdGVzdC5jb25maWcuY2FyZC1wYXltZW50LnRzXCIsXG4gICAgXCJ0ZXN0OmNhcmQtcGF5bWVudDpwZXJmb3JtYW5jZVwiOiBcInZpdGVzdCBydW4gc3JjL3Rlc3QvcGVyZm9ybWFuY2UvaGlnaC12b2x1bWUtcHJvY2Vzc2luZy50ZXN0LnRzIC0tY29uZmlnIHZpdGVzdC5jb25maWcuY2FyZC1wYXltZW50LnRzXCIsXG4gICAgXCJ0ZXN0OmNhcmQtcGF5bWVudDpjb3ZlcmFnZVwiOiBcInZpdGVzdCBydW4gLS1jb25maWcgdml0ZXN0LmNvbmZpZy5jYXJkLXBheW1lbnQudHMgLS1jb3ZlcmFnZVwiLFxuICAgIFwidmVyaWZ5OmRlcGxveW1lbnRcIjogXCJub2RlIHNjcmlwdHMvdmVyaWZ5LWRlcGxveW1lbnQuanNcIixcbiAgICBcInRlc3Q6ZGVwbG95bWVudFwiOiBcInZpdGVzdCBydW4gc3JjL3Rlc3QvZGVwbG95bWVudC9jYXJkLXBheW1lbnQtZGVwbG95bWVudC12ZXJpZmljYXRpb24udGVzdC50c1wiLFxuICAgIFwicHVzaFwiOiBcImdpdCBhZGQgLiAmJiBnaXQgY29tbWl0IC1tIFxcXCJVcGRhdGVkIGVucm9sbG1lbnQgc3lzdGVtIHdpdGggZW1haWwgY29uZmlybWF0aW9uIGFuZCBpbnN0cnVjdG9yIGFwcHJvdmFsIGZsb3dcXFwiICYmIGdpdCBwdXNoIG9yaWdpbiBtYWluXCJcbiAgfSxcbiAgXCJkZXBlbmRlbmNpZXNcIjoge1xuICAgIFwiQGhvb2tmb3JtL3Jlc29sdmVyc1wiOiBcIl4zLjkuMFwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LWFjY29yZGlvblwiOiBcIl4xLjIuMFwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LWFsZXJ0LWRpYWxvZ1wiOiBcIl4xLjEuMVwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LWFzcGVjdC1yYXRpb1wiOiBcIl4xLjEuMFwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LWF2YXRhclwiOiBcIl4xLjEuMFwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LWNoZWNrYm94XCI6IFwiXjEuMS4xXCIsXG4gICAgXCJAcmFkaXgtdWkvcmVhY3QtY29sbGFwc2libGVcIjogXCJeMS4xLjBcIixcbiAgICBcIkByYWRpeC11aS9yZWFjdC1jb250ZXh0LW1lbnVcIjogXCJeMi4yLjFcIixcbiAgICBcIkByYWRpeC11aS9yZWFjdC1kaWFsb2dcIjogXCJeMS4xLjJcIixcbiAgICBcIkByYWRpeC11aS9yZWFjdC1kcm9wZG93bi1tZW51XCI6IFwiXjIuMS4xXCIsXG4gICAgXCJAcmFkaXgtdWkvcmVhY3QtaG92ZXItY2FyZFwiOiBcIl4xLjEuMVwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LWxhYmVsXCI6IFwiXjIuMS4wXCIsXG4gICAgXCJAcmFkaXgtdWkvcmVhY3QtbWVudWJhclwiOiBcIl4xLjEuMVwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LW5hdmlnYXRpb24tbWVudVwiOiBcIl4xLjIuMFwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LXBvcG92ZXJcIjogXCJeMS4xLjFcIixcbiAgICBcIkByYWRpeC11aS9yZWFjdC1wcm9ncmVzc1wiOiBcIl4xLjEuMFwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LXJhZGlvLWdyb3VwXCI6IFwiXjEuMi4wXCIsXG4gICAgXCJAcmFkaXgtdWkvcmVhY3Qtc2Nyb2xsLWFyZWFcIjogXCJeMS4xLjBcIixcbiAgICBcIkByYWRpeC11aS9yZWFjdC1zZWxlY3RcIjogXCJeMi4xLjFcIixcbiAgICBcIkByYWRpeC11aS9yZWFjdC1zZXBhcmF0b3JcIjogXCJeMS4xLjBcIixcbiAgICBcIkByYWRpeC11aS9yZWFjdC1zbGlkZXJcIjogXCJeMS4yLjBcIixcbiAgICBcIkByYWRpeC11aS9yZWFjdC1zbG90XCI6IFwiXjEuMS4wXCIsXG4gICAgXCJAcmFkaXgtdWkvcmVhY3Qtc3dpdGNoXCI6IFwiXjEuMS4wXCIsXG4gICAgXCJAcmFkaXgtdWkvcmVhY3QtdGFic1wiOiBcIl4xLjEuMFwiLFxuICAgIFwiQHJhZGl4LXVpL3JlYWN0LXRvYXN0XCI6IFwiXjEuMi4xXCIsXG4gICAgXCJAcmFkaXgtdWkvcmVhY3QtdG9nZ2xlXCI6IFwiXjEuMS4wXCIsXG4gICAgXCJAcmFkaXgtdWkvcmVhY3QtdG9nZ2xlLWdyb3VwXCI6IFwiXjEuMS4wXCIsXG4gICAgXCJAcmFkaXgtdWkvcmVhY3QtdG9vbHRpcFwiOiBcIl4xLjEuNFwiLFxuICAgIFwiQHN1cGFiYXNlL3N1cGFiYXNlLWpzXCI6IFwiXjIuNDkuOFwiLFxuICAgIFwiQHRhbnN0YWNrL3JlYWN0LXF1ZXJ5XCI6IFwiXjUuNTYuMlwiLFxuICAgIFwiQHR5cGVzL3JlYWN0LXdpbmRvd1wiOiBcIl4xLjguOFwiLFxuICAgIFwiQHR5cGVzL3V1aWRcIjogXCJeMTAuMC4wXCIsXG4gICAgXCJjbGFzcy12YXJpYW5jZS1hdXRob3JpdHlcIjogXCJeMC43LjFcIixcbiAgICBcImNsc3hcIjogXCJeMi4xLjFcIixcbiAgICBcImNtZGtcIjogXCJeMS4wLjBcIixcbiAgICBcImRhdGUtZm5zXCI6IFwiXjMuNi4wXCIsXG4gICAgXCJkb3RlbnZcIjogXCJeMTcuMi4xXCIsXG4gICAgXCJlbWJsYS1jYXJvdXNlbC1yZWFjdFwiOiBcIl44LjMuMFwiLFxuICAgIFwiZXNidWlsZFwiOiBcIl4wLjI1LjhcIixcbiAgICBcImZyYW1lci1tb3Rpb25cIjogXCJeMTEuMTguMlwiLFxuICAgIFwiaW5wdXQtb3RwXCI6IFwiXjEuMi40XCIsXG4gICAgXCJsdWNpZGUtcmVhY3RcIjogXCJeMC40NjIuMFwiLFxuICAgIFwibmV4dC10aGVtZXNcIjogXCJeMC4zLjBcIixcbiAgICBcInJlYWN0XCI6IFwiXjE4LjMuMVwiLFxuICAgIFwicmVhY3QtZGF5LXBpY2tlclwiOiBcIl44LjEwLjFcIixcbiAgICBcInJlYWN0LWRvbVwiOiBcIl4xOC4zLjFcIixcbiAgICBcInJlYWN0LWhvb2stZm9ybVwiOiBcIl43LjUzLjBcIixcbiAgICBcInJlYWN0LW1hcmtkb3duXCI6IFwiXjEwLjEuMFwiLFxuICAgIFwicmVhY3QtcmVzaXphYmxlLXBhbmVsc1wiOiBcIl4yLjEuM1wiLFxuICAgIFwicmVhY3Qtcm91dGVyLWRvbVwiOiBcIl42LjI2LjJcIixcbiAgICBcInJlYWN0LXdpbmRvd1wiOiBcIl4yLjEuMFwiLFxuICAgIFwicmVjaGFydHNcIjogXCJeMi4xMi43XCIsXG4gICAgXCJyZWh5cGUtcmF3XCI6IFwiXjcuMC4wXCIsXG4gICAgXCJyZW1hcmstZ2ZtXCI6IFwiXjQuMC4xXCIsXG4gICAgXCJzb25uZXJcIjogXCJeMS41LjBcIixcbiAgICBcInRhaWx3aW5kLW1lcmdlXCI6IFwiXjIuNS4yXCIsXG4gICAgXCJ0YWlsd2luZGNzcy1hbmltYXRlXCI6IFwiXjEuMC43XCIsXG4gICAgXCJ1dWlkXCI6IFwiXjExLjEuMFwiLFxuICAgIFwidmF1bFwiOiBcIl4wLjkuM1wiLFxuICAgIFwiem9kXCI6IFwiXjMuMjMuOFwiXG4gIH0sXG4gIFwiZGV2RGVwZW5kZW5jaWVzXCI6IHtcbiAgICBcIkBlc2xpbnQvanNcIjogXCJeOS45LjBcIixcbiAgICBcIkB0YWlsd2luZGNzcy90eXBvZ3JhcGh5XCI6IFwiXjAuNS4xNVwiLFxuICAgIFwiQHRlc3RpbmctbGlicmFyeS9qZXN0LWRvbVwiOiBcIl42LjguMFwiLFxuICAgIFwiQHRlc3RpbmctbGlicmFyeS9yZWFjdFwiOiBcIl4xNi4zLjBcIixcbiAgICBcIkB0ZXN0aW5nLWxpYnJhcnkvdXNlci1ldmVudFwiOiBcIl4xNC42LjFcIixcbiAgICBcIkB0eXBlcy9ub2RlXCI6IFwiXjIyLjUuNVwiLFxuICAgIFwiQHR5cGVzL3JlYWN0XCI6IFwiXjE4LjMuM1wiLFxuICAgIFwiQHR5cGVzL3JlYWN0LWRvbVwiOiBcIl4xOC4zLjBcIixcbiAgICBcIkB2aXRlanMvcGx1Z2luLXJlYWN0LXN3Y1wiOiBcIl4zLjExLjBcIixcbiAgICBcIkB2aXRlc3QvdWlcIjogXCJeMy4yLjRcIixcbiAgICBcImF1dG9wcmVmaXhlclwiOiBcIl4xMC40LjIwXCIsXG4gICAgXCJlc2xpbnRcIjogXCJeOS45LjBcIixcbiAgICBcImVzbGludC1wbHVnaW4tcmVhY3QtaG9va3NcIjogXCJeNS4xLjAtcmMuMFwiLFxuICAgIFwiZXNsaW50LXBsdWdpbi1yZWFjdC1yZWZyZXNoXCI6IFwiXjAuNC45XCIsXG4gICAgXCJmYXN0LWNoZWNrXCI6IFwiXjQuMy4wXCIsXG4gICAgXCJnbG9iYWxzXCI6IFwiXjE1LjkuMFwiLFxuICAgIFwianNkb21cIjogXCJeMjcuMC4wXCIsXG4gICAgXCJsb3ZhYmxlLXRhZ2dlclwiOiBcIl4xLjEuN1wiLFxuICAgIFwicG9zdGNzc1wiOiBcIl44LjQuNDdcIixcbiAgICBcInRhaWx3aW5kY3NzXCI6IFwiXjMuNC4xMVwiLFxuICAgIFwidHlwZXNjcmlwdFwiOiBcIl41LjkuM1wiLFxuICAgIFwidHlwZXNjcmlwdC1lc2xpbnRcIjogXCJeOC4wLjFcIixcbiAgICBcInZpdGVcIjogXCJeNS40LjIxXCIsXG4gICAgXCJ2aXRlLWJ1bmRsZS1hbmFseXplclwiOiBcIl4wLjcuMFwiLFxuICAgIFwidml0ZXN0XCI6IFwiXjMuMi40XCJcbiAgfVxufVxuIl0sCiAgIm1hcHBpbmdzIjogIjtBQUFzWSxTQUFTLG9CQUFvQjtBQUNuYSxPQUFPLFdBQVc7QUFDbEIsT0FBTyxVQUFVO0FBQ2pCLFNBQVMsdUJBQXVCOzs7QUNIaEM7QUFBQSxFQUNFLE1BQVE7QUFBQSxFQUNSLFNBQVc7QUFBQSxFQUNYLFNBQVc7QUFBQSxFQUNYLE1BQVE7QUFBQSxFQUNSLFNBQVc7QUFBQSxJQUNULE1BQVE7QUFBQSxFQUNWO0FBQUEsRUFDQSxTQUFXO0FBQUEsSUFDVCxLQUFPO0FBQUEsSUFDUCxPQUFTO0FBQUEsSUFDVCxhQUFhO0FBQUEsSUFDYixpQkFBaUI7QUFBQSxJQUNqQixrQkFBa0I7QUFBQSxJQUNsQixnQkFBZ0I7QUFBQSxJQUNoQixNQUFRO0FBQUEsSUFDUixTQUFXO0FBQUEsSUFDWCxNQUFRO0FBQUEsSUFDUixZQUFZO0FBQUEsSUFDWixXQUFXO0FBQUEsSUFDWCx5QkFBeUI7QUFBQSxJQUN6Qiw0QkFBNEI7QUFBQSxJQUM1QixrQ0FBa0M7QUFBQSxJQUNsQyxnQ0FBZ0M7QUFBQSxJQUNoQyxrQkFBa0I7QUFBQSxJQUNsQixxQkFBcUI7QUFBQSxJQUNyQiwyQkFBMkI7QUFBQSxJQUMzQixlQUFlO0FBQUEsSUFDZix1QkFBdUI7QUFB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
