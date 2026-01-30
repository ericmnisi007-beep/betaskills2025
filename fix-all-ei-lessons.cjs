const fs = require('fs');
const path = require('path');

function fixFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  let fixed = false;
  
  // Fix the malformed patterns
  if (content.includes('`r`n') || content.includes('`n')) {
    content = content.replace(/`r`n/g, '\n');
    content = content.replace(/`n/g, '\n');
    fixed = true;
  }
  
  // Fix the closing structure - should be:
  // textContent: `
  // ... content ...
  //     `
  //   }
  // };
  
  const before = content;
  
  // Check if this file uses content: { textContent: ` or just content: `
  const hasTextContent = content.includes('textContent: `');
  
  if (hasTextContent) {
    // Pattern for content: { textContent: ` } - needs TWO closing braces
    // If it only has ONE (2 spaces before backtick), add the missing brace
    content = content.replace(/([^\r\n])\r\n  `\r\n};\r\n\r\nexport default lesson;/g, '$1\r\n    `\r\n  }\r\n};\r\n\r\nexport default lesson;');
  } else {
    // Pattern for content: ` - needs ONE closing brace
    // If it has TWO (4 spaces before backtick), remove the extra one
    content = content.replace(/([^\r\n])\r\n    `\r\n  }\r\n};\r\n\r\nexport default lesson;/g, '$1\r\n  `\r\n};\r\n\r\nexport default lesson;');
  }
  
  if (content !== before) {
    fixed = true;
  }
  
  if (fixed || content !== fs.readFileSync(filePath, 'utf8')) {
    fs.writeFileSync(filePath, content, 'utf8');
    return true;
  }
  return false;
}

function walkDir(dir) {
  const files = fs.readdirSync(dir);
  let fixedCount = 0;
  
  for (const file of files) {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    
    if (stat.isDirectory()) {
      fixedCount += walkDir(filePath);
    } else if (file.startsWith('lesson') && file.endsWith('.tsx')) {
      if (fixFile(filePath)) {
        console.log('Fixed:', filePath);
        fixedCount++;
      }
    }
  }
  
  return fixedCount;
}

const eiDir = 'src/data/emotionalIntelligence';
const count = walkDir(eiDir);
console.log(`\nFixed ${count} files`);
