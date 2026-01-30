import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  build: {
    lib: {
      entry: resolve(__dirname, 'src/scripts/validateProductionConfig.ts'),
      name: 'ValidationScript',
      fileName: 'validation'
    },
    rollupOptions: {
      external: ['fs', 'path']
    }
  },
  define: {
    'import.meta.env.VITE_RUN_VALIDATION': '"true"'
  }
});