const fs = require('fs');
const path = require('path');

// Simple validation script for featured courses
console.log('Starting validation of featured courses data structure...');

// Read the featured courses file
const featuredCoursesPath = path.join(__dirname, 'src/data/featuredCourses.ts');
console.log('Reading file:', featuredCoursesPath);

try {
  const content = fs.readFileSync(featuredCoursesPath, 'utf8');
  console.log('File read successfully, length:', content.length);
} catch (error) {
  console.error('Error reading file:', error.message);
  process.exit(1);
}

const content = fs.readFileSync(featuredCoursesPath, 'utf8');

// Check for required properties
const requiredProperties = [
  'id', 'title', 'description', 'category', 'level', 
  'duration', 'price', 'currency', 'instructor', 
  'rating', 'students', 'image', 'available', 'courseId'
];

console.log('Required properties:', requiredProperties);

// Check if all required properties are present in the structure
const hasAllProperties = requiredProperties.every(prop => 
  content.includes(prop + ':')
);

console.log('All required properties present:', hasAllProperties);

// Check for category mapping
const categories = [
  'Business', 'ICT', 'Electronics', 'Construction and Civil',
  'Health and Beauty', 'Film & Broadcasting', 'Religion',
  'Hospitality and Culinary', 'Motor Vehicles', 'Appliances',
  'Professional Services'
];

console.log('Checking category mapping...');
categories.forEach(category => {
  if (content.includes(`category: '${category}'`)) {
    console.log(`✓ Category '${category}' found`);
  }
});

console.log('Validation complete.');