# Files Requiring Import Fixes

## Critical Source Files (Non-Test)

These files import from deleted Ikhokha services and need to be updated:

### Components
- `src/components/CourseCard.tsx` - imports ProductionPaymentOrchestrator, EnrollmentStatus

### Hooks
- `src/hooks/useEnrollmentState.ts` - imports EnrollmentStatus, PaymentType, PaymentStatus
- `src/hooks/useRealTimePaymentSync.ts` - imports EnrollmentStatus, PaymentStatus
- `src/hooks/usePaymentFailureRecovery.ts` - imports PaymentData, PaymentResult
- `src/hooks/useAdminDataManager.ts` - imports IkhokhaPayment

### Services
- `src/services/CourseAccessController.ts` - imports EnrollmentStatus, PaymentStatus, ProductionEnrollment, PaymentType
- `src/services/EnrollmentStateManager.ts` - imports PaymentStatus, EnrollmentStatusUpdate
- `src/services/AdminApprovalWorkflow.ts` - imports EnrollmentStatus, ProductionEnrollment

### Utils
- `src/utils/enrollmentPersistence.ts` - ALREADY FIXED ✓

## Strategy

Since these types (EnrollmentStatus, PaymentType, PaymentStatus) already exist in `src/types/enrollment.ts`, we just need to:

1. Update imports to use `@/types/enrollment` instead of `@/types/ikhokha`
2. Remove references to deleted services (ProductionPaymentOrchestrator, etc.)
3. Simplify components to work with EFT-only flow

## EFT-Only Flow

The application should now only support:
- Manual EFT payments with proof of payment upload
- Admin approval workflow
- No automatic card payment processing
- No webhook handling
