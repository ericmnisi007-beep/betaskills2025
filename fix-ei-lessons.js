const fs = require('fs');
const path = require('path');
const glob = require('glob');

// Find all lesson files in emotionalIntelligence
const files = glob.sync('src/data/emotionalIntelligence/**/lesson*.tsx');

console.log(`Found ${files.length} lesson files to fix`);

let fixed = 0;

files.forEach(file => {
  let content = fs.readFileSync(file, 'utf8');
  const original = content;
  
  // Fix all the malformed patterns
  content = content.replace(/  `\r?\n};/g, '    `\n  }\n};');
  content = content.replace(/  ```n  }`n};/g, '    `\n  }\n};');
  content = content.replace(/`r`n    ```r`n  }`r`n};`r`n`r`nexport default lesson;/g, '    `\n  }\n};\n\nexport default lesson;');
  
  if (content !== original) {
    fs.writeFileSync(file, content, 'utf8');
    console.log(`Fixed: ${file}`);
    fixed++;
  }
});

console.log(`\nFixed ${fixed} files`);
