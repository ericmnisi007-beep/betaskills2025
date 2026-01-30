// Test Enrollment System
console.log('🧪 Testing enrollment system...');

// Test 1: Check localStorage
const enrollments = JSON.parse(localStorage.getItem('enrollments') || '[]');
console.log('📋 Current enrollments in localStorage:', enrollments.length);
enrollments.forEach((e, i) => {
  console.log(`  ${i + 1}. ${e.user_email} - ${e.course_title} - ${e.status}`);
});

// Test 2: Create a test enrollment
const testEnrollment = {
  id: `test_${Date.now()}`,
  user_id: 'test-user-id',
  user_email: 'test@example.com',
  course_id: 'test-course-id',
  course_title: 'Test Course',
  status: 'pending',
  created_at: new Date().toISOString()
};

// Add to localStorage
const existingEnrollments = JSON.parse(localStorage.getItem('enrollments') || '[]');
existingEnrollments.push(testEnrollment);
localStorage.setItem('enrollments', JSON.stringify(existingEnrollments));

// Test 3: Dispatch enrollment event
console.log('📡 Dispatching test enrollment event...');
window.dispatchEvent(new CustomEvent('enrollment-submitted', {
  detail: { 
    courseId: 'test-course-id', 
    userId: 'test-user-id', 
    type: 'manual_approval', 
    status: 'pending',
    enrollmentData: testEnrollment
  }
}));

console.log('✅ Test enrollment created and event dispatched!');
console.log('📋 Check instructor dashboard - you should see the test enrollment appear.');
