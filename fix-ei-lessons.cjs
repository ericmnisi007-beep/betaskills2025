const fs = require('fs');
const path = require('path');

// Recursively find all lesson files
function findLessonFiles(dir) {
  const files = [];
  const items = fs.readdirSync(dir);
  
  for (const item of items) {
    const fullPath = path.join(dir, item);
    const stat = fs.statSync(fullPath);
    
    if (stat.isDirectory()) {
      files.push(...findLessonFiles(fullPath));
    } else if (item.startsWith('lesson') && item.endsWith('.tsx')) {
      files.push(fullPath);
    }
  }
  
  return files;
}

const files = findLessonFiles('src/data/emotionalIntelligence');

console.log(`Found ${files.length} lesson files to fix`);

let fixed = 0;

files.forEach(file => {
  let content = fs.readFileSync(file, 'utf8');
  const original = content;
  
  // Fix the pattern: two spaces before backtick, then }; on next line
  // Should be: four spaces before backtick, then two spaces + } on next line, then }; on next line
  content = content.replace(/\n  `\r?\n};\r?\n\r?\nexport default lesson;/g, '\n    `\n  }\n};\n\nexport default lesson;');
  
  if (content !== original) {
    fs.writeFileSync(file, content, 'utf8');
    console.log(`Fixed: ${file}`);
    fixed++;
  }
});

console.log(`\nFixed ${fixed} files`);
