# Course Design Standards - Entrepreneurship Standard

## 🎯 **Design Philosophy**

All courses must follow the **"Entrepreneurship: Building Your Business"** design standard for consistency and professional appearance. This course represents the perfect balance of visual appeal, usability, and professional presentation.

## 📋 **Mandatory Design Rules**

### **1. Course Header Standards**
- **Dimensions**: min-height: 260px, max-height: 420px
- **Border Radius**: 24px (rounded-3xl)
- **Shadow**: 0 25px 50px -12px rgba(0, 0, 0, 0.25)
- **Background**: Gradient overlay with professional image
- **Animation**: fadeIn 0.6s ease-out

### **2. Color Palette**
- **Primary Gradient**: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 50%, #ec4899 100%)
- **Accent Gradient**: linear-gradient(135deg, #dc2626 0%, #db2777 50%, #7c3aed 100%)
- **Rating Gradient**: linear-gradient(135deg, #fbbf24 0%, #f59e0b 50%, #d97706 100%)
- **Text Colors**: #ffffff (white), #374151 (gray-700), #6b7280 (gray-500)

### **3. Typography Standards**
- **Title**: 1.875rem (text-3xl), font-weight: 900, line-height: 1.1
- **Subtitle**: 1.125rem (text-lg), font-weight: 600
- **Body**: 1rem (text-base), line-height: 1.7
- **Small**: 0.875rem (text-sm), color: #6b7280

### **4. Component Standards**

#### **Course Stats**
- **Layout**: Flexbox with gap: 1rem
- **Style**: Rounded-full badges with gradient backgrounds
- **Hover**: scale(1.05) with enhanced shadow
- **Icons**: 16px (h-4 w-4) with 90% opacity

#### **Course Overview**
- **Background**: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%)
- **Border Radius**: 16px
- **Padding**: 2rem
- **Shadow**: 0 4px 6px -1px rgba(0, 0, 0, 0.1)

#### **Learning Objectives**
- **Background**: White with left border accent (#3b82f6)
- **Border Radius**: 12px
- **Padding**: 1.5rem
- **Shadow**: 0 1px 3px 0 rgba(0, 0, 0, 0.1)

#### **Course Curriculum**
- **Module Items**: Border with hover effects
- **Hover State**: border-color: #3b82f6, transform: translateY(-2px)
- **Lesson Items**: Clean layout with duration badges
- **Icons**: Consistent 16px sizing

#### **Enrollment Sidebar**
- **Position**: Sticky (top: 1.5rem)
- **Background**: White with subtle shadow
- **Border Radius**: 16px
- **Enroll Button**: Full-width gradient button with hover effects

### **5. Animation Standards**
- **Duration**: 0.3s for all transitions
- **Easing**: ease-out for smooth feel
- **Hover Effects**: scale(1.05) or translateY(-2px)
- **Loading**: fadeIn 0.6s ease-out

### **6. Responsive Design**
- **Mobile**: Reduced font sizes and padding
- **Tablet**: Maintained proportions
- **Desktop**: Full design implementation

## 🎨 **Implementation Guidelines**

### **CSS Classes to Use**
```css
/* Course Header */
.course-header-container
.course-header-background
.course-header-image
.course-header-overlay
.course-header-content
.course-header-badge
.course-header-title
.course-header-stats
.course-stat-item
.course-stat-rating

/* Course Content */
.course-content-container
.course-overview-section
.course-description
.course-learning-objectives
.course-objective-item
.course-objective-icon

/* Course Curriculum */
.course-curriculum-section
.course-module-item
.course-module-header
.course-module-title
.course-module-description
.course-lesson-item
.course-lesson-icon
.course-lesson-info
.course-lesson-title
.course-lesson-duration

/* Enrollment Sidebar */
.course-enrollment-sidebar
.course-enrollment-title
.course-enroll-button
.course-features-list
.course-feature-item
.course-feature-icon
```

### **Required Image Standards**
- **Hero Images**: 1600px width, professional quality
- **Aspect Ratio**: 16:9 or 4:3
- **Format**: JPG/PNG with optimization
- **Content**: Relevant to course topic with professional appearance

### **Icon Standards**
- **Library**: Lucide React icons
- **Size**: 16px (h-4 w-4) for most use cases
- **Color**: Consistent with design system
- **Spacing**: 0.5rem gap with text

## 🔧 **Quality Assurance Checklist**

### **Before Publishing Any Course:**
- [ ] Header follows exact Entrepreneurship dimensions
- [ ] Color palette matches standard gradients
- [ ] Typography uses correct font sizes and weights
- [ ] All animations are smooth (0.3s duration)
- [ ] Responsive design works on all screen sizes
- [ ] Images are high-quality and relevant
- [ ] Icons are consistent and properly sized
- [ ] Hover effects work correctly
- [ ] Dark mode support is implemented
- [ ] Accessibility standards are met

### **Performance Standards:**
- [ ] Images are optimized (< 100KB each)
- [ ] CSS animations use hardware acceleration
- [ ] No layout shifts during loading
- [ ] Smooth scrolling performance
- [ ] Fast initial page load

## 📱 **Mobile Optimization**

### **Required Mobile Adjustments:**
- **Header Title**: 1.5rem (text-2xl) on mobile
- **Stats**: Reduced gap (0.5rem) and font size (0.75rem)
- **Content Padding**: 1rem instead of 2rem
- **Sidebar**: Full-width on mobile, not sticky
- **Buttons**: Maintain touch-friendly sizing (44px minimum)

## 🌙 **Dark Mode Support**

### **Required Dark Mode Styles:**
- **Backgrounds**: Dark grays (#1f2937, #374151)
- **Text**: Light colors (#f9fafb, #e5e7eb)
- **Borders**: Subtle white borders with low opacity
- **Shadows**: Adjusted for dark backgrounds
- **Gradients**: Maintained but with adjusted opacity

## ♿ **Accessibility Requirements**

### **Mandatory Accessibility Features:**
- **Color Contrast**: Minimum 4.5:1 ratio
- **Focus Indicators**: Visible focus states
- **Reduced Motion**: Respect user preferences
- **Screen Reader**: Proper ARIA labels
- **Keyboard Navigation**: Full keyboard support

## 📊 **Success Metrics**

### **Design Consistency Score:**
- **Visual Alignment**: 95%+ match with Entrepreneurship course
- **Color Accuracy**: 100% adherence to color palette
- **Typography**: 100% correct font usage
- **Animation Smoothness**: 60fps performance
- **Mobile Experience**: 90%+ user satisfaction

## 🚀 **Implementation Process**

1. **Design Review**: Compare with Entrepreneurship course
2. **CSS Implementation**: Use provided CSS classes
3. **Image Selection**: Choose high-quality, relevant images
4. **Content Structure**: Follow established layout patterns
5. **Testing**: Verify on all devices and browsers
6. **Quality Check**: Complete the QA checklist
7. **Deployment**: Only deploy when all standards are met

---

**Remember**: The Entrepreneurship course design is the gold standard. All courses must achieve the same level of visual excellence and user experience. 