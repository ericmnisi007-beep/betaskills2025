const fs = require('fs');
const path = require('path');

function getAllFiles(dirPath, arrayOfFiles = []) {
  const files = fs.readdirSync(dirPath);
  
  files.forEach(file => {
    const filePath = path.join(dirPath, file);
    if (fs.statSync(filePath).isDirectory()) {
      arrayOfFiles = getAllFiles(filePath, arrayOfFiles);
    } else if (file.startsWith('lesson') && file.endsWith('.tsx')) {
      arrayOfFiles.push(filePath);
    }
  });
  
  return arrayOfFiles;
}

const files = getAllFiles('src/data/emotionalIntelligence');
let fixed = 0;

files.forEach(filepath => {
  let content = fs.readFileSync(filepath, 'utf8');
  const original = content;
  
  // Step 1: Fix the opening - replace backtick-n pattern with proper newlines
  content = content.replace("type: 'reading',`n  content: {`n    textContent: ``", "type: 'reading',\r\n  content: `");
  
  // Step 2: Fix the closing - for reading type, remove the extra wrapper
  // Pattern: content ending, then spaces+backtick, then newline, then };
  content = content.replace(/\r\n  `\r\n};\r\n\r\nexport default lesson;/g, '\r\n  `\r\n};\r\n\r\nexport default lesson;');
  
  // Step 3: Fix any remaining backtick-n patterns in closings
  content = content.replace(/  ```n  }`n};/g, '  `\r\n};');
  
  if (content !== original) {
    fs.writeFileSync(filepath, content, 'utf8');
    fixed++;
    console.log('Fixed:', filepath);
  }
});

console.log('\nTotal files fixed:', fixed);
