import { defineConfig } from 'vitest/config';
import { resolve } from 'path';

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./src/tests/setup.ts'],
    include: [
      'src/tests/migration/**/*.test.ts',
      'src/tests/migration/**/*.test.tsx'
    ],
    exclude: [
      'node_modules',
      'dist',
      'src/tests/**/*.spec.ts'
    ],
    coverage: {
      reporter: ['text', 'json', 'html'],
      include: [
        'src/utils/migrationValidation.ts',
        'src/utils/legacyAccessMonitor.ts',
        'src/utils/migrationTestRunner.ts',
        'src/utils/runMigrationTests.ts'
      ],
      exclude: [
        'src/tests/**',
        '**/*.d.ts'
      ],
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80
        }
      }
    },
    testTimeout: 10000,
    hookTimeout: 10000
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, './src'),
      '@/components': resolve(__dirname, './src/components'),
      '@/hooks': resolve(__dirname, './src/hooks'),
      '@/utils': resolve(__dirname, './src/utils'),
      '@/services': resolve(__dirname, './src/services'),
      '@/types': resolve(__dirname, './src/types')
    }
  }
});
