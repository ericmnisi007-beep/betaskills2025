import React, { lazy, Suspense, useEffect } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { QueryClientProvider, QueryClient } from '@tanstack/react-query';
import { AuthProvider } from "@/hooks/AuthContext";
import { CoursesProvider } from "@/hooks/CoursesContext";
import { EnrollmentProvider } from "@/hooks/EnrollmentContext";
import { Toaster } from "@/components/ui/toaster";
import Layout from '@/components/Layout';
import EnrollmentStatusSync from '@/components/EnrollmentStatusSync';
import { initializeSafeEnrollmentSystem } from '@/utils/enrollmentErrorFix';
import { dataSyncService } from '@/services/DataSyncService';

// Simple loading component
const LoadingSpinner = () => (
  <div className="flex items-center justify-center min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
    <div className="text-center">
      <div className="animate-spin rounded-full h-16 w-16 border-b-4 border-blue-600 mx-auto mb-4"></div>
      <h2 className="text-xl font-semibold text-gray-800 mb-2">Beta Skills</h2>
      <p className="text-gray-600">Loading your learning platform...</p>
    </div>
  </div>
);

// Simple error boundary
class ErrorBoundary extends React.Component<
  { children: React.ReactNode },
  { hasError: boolean; error?: Error }
> {
  constructor(props: { children: React.ReactNode }) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('App Error:', error);
    console.error('Error Info:', errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen bg-gradient-to-br from-red-50 to-pink-100 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-lg p-8 max-w-md w-full text-center">
            <div className="text-red-500 text-6xl mb-4">⚠️</div>
            <h1 className="text-2xl font-bold text-gray-800 mb-4">Oops! Something went wrong</h1>
            <p className="text-gray-600 mb-6">
              We're having trouble loading Beta Skills. This is usually a temporary issue.
            </p>
            <div className="space-y-3">
              <button
                onClick={() => window.location.reload()}
                className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 transition-colors font-medium"
              >
                🔄 Refresh Page
              </button>
              <button
                onClick={() => this.setState({ hasError: false })}
                className="w-full bg-gray-200 text-gray-800 py-3 px-4 rounded-lg hover:bg-gray-300 transition-colors font-medium"
              >
                🔄 Try Again
              </button>
            </div>
            <details className="mt-6 text-left">
              <summary className="cursor-pointer text-sm text-gray-500 hover:text-gray-700">
                Technical Details
              </summary>
              <div className="mt-2 text-xs text-gray-400 bg-gray-50 p-3 rounded">
                <p>Error: {this.state.error?.message || 'Unknown error'}</p>
                <p className="mt-1">Try refreshing or contact support if this persists.</p>
              </div>
            </details>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}

// Simple layout for auth pages only
const SimpleLayout = ({ children }: { children: React.ReactNode }) => (
  <div className="min-h-screen bg-gray-50">
    <header className="bg-white shadow-sm border-b">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center py-4">
          <div className="flex items-center space-x-3">
            <div className="w-8 h-8 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
              <span className="text-white font-bold text-sm">BS</span>
            </div>
            <h1 className="text-xl font-semibold text-gray-900">Beta Skills</h1>
          </div>
        </div>
      </div>
    </header>
    <main>{children}</main>
  </div>
);

// Safe lazy loading with fallback
const safeLazyImport = (importFn: () => Promise<any>) => {
  return lazy(() =>
    importFn().catch(() => {
      // Fallback component if import fails
      return {
        default: () => (
          <div className="min-h-screen flex items-center justify-center">
            <div className="text-center">
              <h2 className="text-xl font-semibold mb-4">Page Loading Error</h2>
              <p className="text-gray-600 mb-4">Unable to load this page.</p>
              <button
                onClick={() => window.location.reload()}
                className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
              >
                Refresh Page
              </button>
            </div>
          </div>
        )
      };
    })
  );
};

// Lazy load pages safely
const Index = safeLazyImport(() => import("./pages/Index"));
const Auth = safeLazyImport(() => import("./pages/Auth"));
const ResetPassword = safeLazyImport(() => import("./pages/ResetPassword"));
const Courses = safeLazyImport(() => import("./pages/Courses"));
const Dashboard = safeLazyImport(() => import("./pages/Dashboard"));
const AdminDashboard = safeLazyImport(() => import("./pages/AdminDashboard"));
const PaymentPage = safeLazyImport(() => import("./pages/PaymentPage"));
const PaymentSuccess = safeLazyImport(() => import("./pages/PaymentSuccess"));
const PaymentFailed = safeLazyImport(() => import("./pages/PaymentFailed"));
const PaymentCancel = safeLazyImport(() => import("./pages/PaymentCancel"));
const Course = safeLazyImport(() => import("./pages/Course"));
const CourseOverviewPage = safeLazyImport(() => import("./pages/CourseOverviewPage"));
const CertificatePage = safeLazyImport(() => import("./components/course/CertificatePage").then(m => ({ default: m.CertificatePage })));
const Enrollment = safeLazyImport(() => import("./pages/Enrollment"));
const NotFound = safeLazyImport(() => import("./pages/NotFound"));

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 3,
      staleTime: 5 * 60 * 1000, // 5 minutes
      refetchOnWindowFocus: false,
    },
  },
});

const App: React.FC = () => {
  // Initialize safe systems on app start
  useEffect(() => {
    try {
      initializeSafeEnrollmentSystem();
    } catch (error) {
      console.error('Failed to initialize safe enrollment system:', error);
    }

    // Initialize DataSyncService
    const initDataSync = async () => {
      try {
        await dataSyncService.initialize();
        console.log('✅ DataSyncService initialized');
      } catch (error) {
        console.error('❌ Failed to initialize DataSyncService:', error);
      }
    };
    
    initDataSync();

    // Add global error handler for payment integration errors
    const handlePaymentError = (event: ErrorEvent) => {
      if (event.message?.includes('production credentials') || 
          event.message?.includes('IkhokhaPaymentIntegration')) {
        console.warn('Payment integration error caught and handled:', event.message);
        event.preventDefault(); // Prevent the error from crashing the app
      }
    };

    window.addEventListener('error', handlePaymentError);
    
    return () => {
      window.removeEventListener('error', handlePaymentError);
      dataSyncService.cleanup();
    };
  }, []);

  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <AuthProvider>
          <CoursesProvider>
            <EnrollmentProvider>
              <BrowserRouter>
                <Suspense fallback={<LoadingSpinner />}>
                  <Routes>
                    <Route path="/" element={
                      <Layout showHeader={true}>
                        <Index />
                      </Layout>
                    } />
                    <Route path="/auth" element={
                      <SimpleLayout>
                        <Auth />
                      </SimpleLayout>
                    } />
                    <Route path="/reset-password" element={
                      <SimpleLayout>
                        <ResetPassword />
                      </SimpleLayout>
                    } />
                    <Route path="/courses" element={
                      <Layout showHeader={true}>
                        <Courses />
                      </Layout>
                    } />
                    <Route path="/course/:courseId" element={
                      <Layout showHeader={true}>
                        <ErrorBoundary>
                          <Course />
                        </ErrorBoundary>
                      </Layout>
                    } />
                    <Route path="/course/:courseId/verify" element={
                      <Layout showHeader={true}>
                        <ErrorBoundary>
                          <Course />
                        </ErrorBoundary>
                      </Layout>
                    } />
                    <Route path="/course/:courseId/overview" element={
                      <Layout showHeader={true}>
                        <CourseOverviewPage />
                      </Layout>
                    } />
                    <Route path="/course/:courseId/certificate" element={
                      <Layout showHeader={true}>
                        <CertificatePage />
                      </Layout>
                    } />
                    <Route path="/dashboard" element={
                      <Layout showHeader={true}>
                        <Dashboard />
                      </Layout>
                    } />
                    <Route path="/admin" element={
                      <Layout showHeader={true}>
                        <AdminDashboard />
                      </Layout>
                    } />
                    <Route path="/enrollment/:courseId" element={
                      <Layout showHeader={true}>
                        <Enrollment />
                      </Layout>
                    } />
                    <Route path="/payment/:courseId" element={
                      <Layout showHeader={true}>
                        <ErrorBoundary>
                          <PaymentPage />
                        </ErrorBoundary>
                      </Layout>
                    } />
                    <Route path="/payment/ai-human-relations" element={
                      <Layout showHeader={true}>
                        <PaymentPage />
                      </Layout>
                    } />
                    <Route path="/payment-success" element={
                      <Layout showHeader={true}>
                        <PaymentSuccess />
                      </Layout>
                    } />
                    <Route path="/payment-failed" element={
                      <Layout showHeader={true}>
                        <PaymentFailed />
                      </Layout>
                    } />
                    <Route path="/payment-cancel" element={
                      <Layout showHeader={true}>
                        <PaymentCancel />
                      </Layout>
                    } />
                    <Route path="*" element={
                      <Layout showHeader={true}>
                        <NotFound />
                      </Layout>
                    } />
                  </Routes>
                </Suspense>
                <EnrollmentStatusSync />
                <Toaster />
              </BrowserRouter>
            </EnrollmentProvider>
          </CoursesProvider>
        </AuthProvider>
      </QueryClientProvider>
    </ErrorBoundary>
  );
};

export default App;