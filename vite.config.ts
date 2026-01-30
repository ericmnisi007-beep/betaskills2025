import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";
import { componentTagger } from "lovable-tagger";
import packageJson from "./package.json";

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => ({
  server: {
    host: "localhost",
    port: 3000,
    strictPort: false,
    open: true,
  },
  plugins: [
    react(),
    mode === 'development' && componentTagger(),
  ].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  define: {
    global: 'globalThis',
  },
  build: {
    rollupOptions: {
      output: {
        // Minimal chunking to prevent React issues
        manualChunks: {
          // Keep React and all related dependencies in one chunk
          'vendor-react': ['react', 'react-dom', 'react-router-dom', 'react/jsx-runtime'],
          'vendor-supabase': ['@supabase/supabase-js'],
          'vendor-ui': Object.keys(packageJson.dependencies).filter(dep => dep.startsWith('@radix-ui')),
        },
        chunkFileNames: 'assets/[name]-[hash].js',
        entryFileNames: 'assets/[name]-[hash].js',
        assetFileNames: 'assets/[name]-[hash].[ext]'
      },
    },
    sourcemap: mode === 'development',
    chunkSizeWarningLimit: 2000,
    minify: mode === 'production' ? 'esbuild' : false,
    target: 'es2020', // More modern target for better compatibility
    // Enable tree shaking
    treeshake: true,
  },
  optimizeDeps: {
    include: [
      'react', 
      'react-dom', 
      'react/jsx-runtime',
      'react/jsx-dev-runtime',
      'react-router-dom',
      '@supabase/supabase-js'
    ],
    force: true, // Force re-optimization
  },
  esbuild: {
    // Remove console statements and debugger in production
    ...(mode === 'production' && {
      drop: ['console', 'debugger'],
    }),
  },
}));
