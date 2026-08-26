// build-config.js
const fs = require('fs');
const path = require('path');

const templatePath = path.join(__dirname, 'config.template.js');
const outputPath = path.join(__dirname, 'config.js');

// Read the template
let template = fs.readFileSync(templatePath, 'utf8');

// Replace placeholders with actual environment variables
template = template.replace(/__SUPABASE_URL__/g, process.env.SUPABASE_URL || '');
template = template.replace(/__SUPABASE_ANON_KEY__/g, process.env.SUPABASE_ANON_KEY || '');

// Write the final config.js
fs.writeFileSync(outputPath, template, 'utf8');

console.log('✅ config.js generated successfully');
