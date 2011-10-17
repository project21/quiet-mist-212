require 'database_cleaner'
STDERR.puts "Cleaning database..."
DatabaseCleaner.clean_with :truncation
STDERR.puts "Database cleaned"
#DatabaseCleaner[:active_record].clean_with(:truncation)
