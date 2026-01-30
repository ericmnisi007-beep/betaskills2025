/// <reference types="vitest" />
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
    include: [
      'src/test/integration/production-payment-flows.e2e.test.ts',
      'src/test/integration/real-time-status-sync.integration.test.ts',
      'src/test/integration/webhook-signature-validation.test.ts',
      'src/test/integration/admin-approval-realtime.test.ts'
    ],
    testTimeout: 30000, // 30 seconds per test
    hookTimeout: 10000, // 10 seconds for setup/teardown
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      reportsDirectory: './test-reports/coverage',
      include: [
        'src/services/**/*.ts',
        'src/hooks/**/*.ts',
        'src/components/**/*.tsx',
        'src/utils/**/*.ts'
      ],
      exclude: [
        'src/**/*.test.ts',
        'src/**/*.test.tsx',
        'src/test/**/*',
        'src/**/*.d.ts'
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
    reporter: ['verbose', 'json', 'html'],
    outputFile: {
      json: './test-reports/production-flows-results.json',
      html: './test-reports/production-flows-results.html'
    },
    pool: 'threads',
    poolOptions: {
      threads: {
        singleThread: true // Ensure tests run sequentially for real-time testing
      }
    }
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
});