import { defineConfig } from 'vitest/config';
import path from 'path';

/**
 * Vitest Configuration for Card Payment Flow Tests
 * 
 * This configuration is specifically optimized for running the comprehensive
 * card payment flow test suite with proper timeouts and resource management.
 */
export default defineConfig({
  test: {
    // Test environment configuration
    environment: 'jsdom',
    
    // Global test setup
    setupFiles: ['./src/test/setup.ts'],
    
    // Test file patterns for card payment tests
    include: [
      'src/test/card-payment-comprehensive.test.ts',
      'src/test/e2e/card-payment-flow.e2e.test.ts',
      'src/test/webhook/webhook-simulation.test.ts',
      'src/test/realtime/multi-tab-sync.test.ts',
      'src/test/performance/high-volume-processing.test.ts',
      'src/test/card-payment-test-suite.ts'
    ],
    
    // Exclude patterns
    exclude: [
      'node_modules/**',
      'dist/**',
      '.git/**'
    ],
    
    // Timeout configuration for performance tests
    testTimeout: 30000, // 30 seconds for performance tests
    hookTimeout: 10000, // 10 seconds for setup/teardown
    
    // Concurrency settings
    threads: true,
    maxThreads: 4,
    minThreads: 1,
    
    // Reporter configuration
    reporter: ['verbose', 'json'],
    outputFile: {
      json: './test-results/card-payment-tests.json'
    },
    
    // Coverage configuration
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      reportsDirectory: './coverage/card-payment',
      include: [
        'src/services/PaymentTypeDetector.ts',
        'src/services/CardPaymentFastTrack.ts',
        'src/services/EnhancedRealTimeSync.ts',
        'src/services/CourseAccessController.ts',
        'src/hooks/useEnhancedRealTimeSync.ts',
        'src/hooks/useEnhancedCourseAccess.ts'
      ],
      exclude: [
        'src/test/**',
        'src/**/*.test.ts',
        'src/**/*.spec.ts'
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
    
    // Global test configuration
    globals: true,
    
    // Mock configuration
    clearMocks: true,
    restoreMocks: true,
    
    // Performance monitoring
    logHeapUsage: true,
    
    // Retry configuration for flaky tests
    retry: 2,
    
    // Test isolation
    isolate: true,
    
    // Pool options for performance tests
    pool: 'threads',
    poolOptions: {
      threads: {
        singleThread: false,
        isolate: true,
        useAtomics: true
      }
    }
  },
  
  // Resolve configuration
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      '@/test': path.resolve(__dirname, './src/test'),
      '@/services': path.resolve(__dirname, './src/services'),
      '@/hooks': path.resolve(__dirname, './src/hooks'),
      '@/types': path.resolve(__dirname, './src/types'),
      '@/utils': path.resolve(__dirname, './src/utils')
    }
  },
  
  // Define configuration for different test types
  define: {
    __TEST_ENV__: '"card-payment-tests"',
    __PERFORMANCE_TESTS__: 'true',
    __E2E_TESTS__: 'true',
    __WEBHOOK_TESTS__: 'true',
    __REALTIME_TESTS__: 'true'
  }
});