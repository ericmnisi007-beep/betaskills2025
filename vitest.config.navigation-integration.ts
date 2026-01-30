import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react-swc';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  test: {
    name: 'course-navigation-integration',
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
    include: [
      'src/test/integration/course-navigation-*.integration.test.tsx',
      'src/test/integration/complete-user-journey.integration.test.tsx'
    ],
    exclude: [
      'node_modules/**',
      'dist/**',
      '**/*.{node,production}.test.ts'
    ],
    globals: true,
    testTimeout: 10000,
    hookTimeout: 10000,
    teardownTimeout: 5000,
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      include: [
        'src/services/UnifiedEnrollmentValidator.ts',
        'src/services/EnhancedNavigationHandler.ts',
        'src/services/CourseContentValidator.ts',
        'src/services/NavigationErrorHandler.ts',
        'src/components/courses/CourseGridEnrollmentButton.tsx',
        'src/pages/Course.tsx',
        'src/pages/Courses.tsx'
      ],
      exclude: [
        'src/test/**',
        'src/**/*.test.ts',
        'src/**/*.test.tsx'
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
    reporters: ['verbose', 'json'],
    outputFile: {
      json: './test-results/navigation-integration-tests.json'
    }
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
});