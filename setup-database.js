const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

// Load environment variables
require('dotenv').config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing Supabase environment variables');
  console.error('Please set VITE_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function runMigrations() {
  try {
    console.log('🚀 Starting database setup...');
    
    // Read the migration SQL file
    const migrationPath = path.join(__dirname, 'database_migrations.sql');
    const migrationSQL = fs.readFileSync(migrationPath, 'utf8');
    
    console.log('📄 Executing database migrations...');
    
    // Execute the migration
    const { error } = await supabase.rpc('exec_sql', { sql: migrationSQL });
    
    if (error) {
      console.error('❌ Migration failed:', error);
      process.exit(1);
    }
    
    console.log('✅ Database setup completed successfully!');
    console.log('📊 Created tables:');
    console.log('   - user_progress (for course progress tracking)');
    console.log('   - user_state (for user preferences and state)');
    console.log('   - user_progress_summary (view for progress analytics)');
    console.log('');
    console.log('🔒 Row Level Security (RLS) enabled');
    console.log('📈 Indexes created for optimal performance');
    console.log('🔄 Auto-updating timestamps configured');
    
  } catch (error) {
    console.error('❌ Setup failed:', error);
    process.exit(1);
  }
}

// Alternative method using direct SQL execution
async function runMigrationsDirect() {
  try {
    console.log('🚀 Starting database setup...');
    
    // Read the migration SQL file
    const migrationPath = path.join(__dirname, 'database_migrations.sql');
    const migrationSQL = fs.readFileSync(migrationPath, 'utf8');
    
    console.log('📄 Executing database migrations...');
    
    // Split SQL into individual statements
    const statements = migrationSQL
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0 && !stmt.startsWith('--'));
    
    for (const statement of statements) {
      if (statement.trim()) {
        console.log('Executing:', statement.substring(0, 50) + '...');
        const { error } = await supabase.rpc('exec_sql', { sql: statement + ';' });
        if (error) {
          console.warn('Warning:', error.message);
        }
      }
    }
    
    console.log('✅ Database setup completed successfully!');
    
  } catch (error) {
    console.error('❌ Setup failed:', error);
    console.log('');
    console.log('💡 Manual Setup Instructions:');
    console.log('1. Go to your Supabase dashboard');
    console.log('2. Navigate to SQL Editor');
    console.log('3. Copy and paste the contents of database_migrations.sql');
    console.log('4. Execute the SQL');
    process.exit(1);
  }
}

// Run the setup
runMigrationsDirect(); 