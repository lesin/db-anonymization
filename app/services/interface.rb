# frozen_string_literal: true

require 'active_record'
require 'erb'

Dir[File.join(__dir__, '..', 'models', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '..', 'services', '*.rb')].each { |file| require file }

class Interface
  REQUIRED_ENV = %w[ENV DATABASE_USERNAME DATABASE_PASSWORD DATABASE_HOST
                    DATABASE_NAME DEFAULT_PASSWORD_ENCRYPTED].freeze
  private_constant :REQUIRED_ENV

  def self.call
    new.call
  end

  def call
    return if env_variables_not_set?

    establish_db_connection
    return unless continue_db_anonimization?

    DatabaseAnonymization.call
    puts 'your data was anonymized!'
  end

  private

  def establish_db_connection
    ActiveRecord::Base.establish_connection(db_configuration[ENV['ENV']])

    puts 'Currently in the database:'
    puts "#{Dealership.count} dealerships"
    puts "#{User.count} users"
    puts "#{Customer.count} customers"
  end

  def env_variables_not_set?
    REQUIRED_ENV.each do |env_name|
      if ENV[env_name].nil?
        puts "missing environmental variable '#{env_name}'"
        return true
      end
    end
    false
  end

  def db_configuration
    template = ERB.new(File.new('./db/config.yml.erb').read)
    YAML.load(template.result(binding))
  end

  def continue_db_anonimization?
    puts 'Are you sure you want to anonymize all data in the database? (y/n)'
    printf '> '

    user_result = gets.chomp
    user_result == 'y'
  end
end
