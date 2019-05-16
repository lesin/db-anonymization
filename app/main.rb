require 'active_record'
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'services', '*.rb')].each { |file| require file }

def db_configuration
  db_configuration_file = File.join(__dir__, '..',
                                    'db', 'config.yml')
  YAML.load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration[ENV['ENV']])

puts 'Currently in the database:'
puts "#{Dealership.count} dealerships"
puts "#{User.count} users"
puts "#{Customer.count} customers"
puts 'Are you sure you want anonymize all data in the database? (y/n)'
printf '> '

user_result = gets.chomp

if user_result == 'y'
  DatabaseAnonymization.call
  puts 'your data was anonymized'
end
