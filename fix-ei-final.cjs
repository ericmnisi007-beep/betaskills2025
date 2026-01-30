const fs = require('fs');
const path = require('path');

// Files with content as plain string (not object)
const plainContentFiles = [
  'src/data/emotionalIntelligence/module2/lesson2-importance-of-self-awareness.tsx',
  'src/data/emotionalIntelligence/module2/lesson4-understanding-strengths-weaknesses.tsx',
  'src/data/emotionalIntelligence/module2/lesson6-benefits-of-high-self-awareness.tsx',
  'src/data/emotionalIntelligence/module3/lesson2-importance-of-self-regulation.tsx',
  'src/data/emotionalIntelligence/module3/lesson4-techniques-for-managing-emotions.tsx',
  'src/data/emotionalIntelligence/module3/lesson5-examples-of-self-regulation-in-action.tsx',
  'src/data/emotionalIntelligence/module3/lesson6-benefits-of-good-self-regulation.tsx',
  'src/data/emotionalIntelligence/module4/lesson2-types-of-motivation.tsx',
  'src/data/emotionalIntelligence/module4/lesson3-setting-meaningful-goals.tsx',
  'src/data/emotionalIntelligence/module4/lesson4-role-of-optimism.tsx',
  'src/data/emotionalIntelligence/module5/lesson4-nonverbal-cues.tsx',
  'src/data/emotionalIntelligence/module6/lesson1-what-are-social-skills.tsx',
  'src/data/emotionalIntelligence/module6/lesson2-effective-communication.tsx',
  'src/data/emotionalIntelligence/module6/lesson3-conflict-resolution.tsx',
  'src/data/emotionalIntelligence/module6/lesson4-collaboration-and-teamwork.tsx',
  'src/data/emotionalIntelligence/module6/lesson5-building-rapport.tsx',
  'src/data/emotionalIntelligence/module6/lesson6-influencing-others-positively.tsx',
  'src/data/emotionalIntelligence/module7/lesson1-ei-in-leadership.tsx',
  'src/data/emotionalIntelligence/module7/lesson3-personal-professional-growth.tsx'
];

let fixed = 0;

plainContentFiles.forEach(file => {
  let content = fs.readFileSync(file, 'utf8');
  const original = content;
  
  // For plain content files: remove the extra }
  content = content.replace(/\n    `\n  }\n};\n\nexport default lesson;/g, '\n  `\n};\n\nexport default lesson;');
  
  if (content !== original) {
    fs.writeFileSync(file, content, 'utf8');
    console.log(`Fixed: ${file}`);
    fixed++;
  }
});

console.log(`\nFixed ${fixed} files`);
