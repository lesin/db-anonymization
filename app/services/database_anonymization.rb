require 'faker'

class DatabaseAnonymization
  DEFAULT_PHONE = '+48111111111'.freeze
  DEFAULT_EMPTY_PHONE = '0'.freeze

  def self.call
    new.call
  end

  def call
    anonymize_database
  end

  private

  def anonymize_database
    ActiveRecord::Base.transaction do
      puts 'anonymize dealerships data'
      Dealership.find_each do |dealership|
        dealership.update_columns(
          name: Faker::Company.name,
          email: dealership.id.to_s + Faker::Internet.email,
          phone: DEFAULT_PHONE,
          encrypted_password: ENV['DEFAULT_PASSWORD_ENCRYPTED'],
          country_code: 'PL',
          timezone: 'Warsaw',
          short_name: nil,
          address: Faker::Address.full_address,
          cdk_dealer_codes: nil,
          dealer_track_dealer_code: nil,
          dealer_track_enterprise_code: nil,
          dealer_track_server: nil,
          pbs_dealer_code: nil,
          openmate_dealer_code: nil,
          dealer_built_dealer_codes: nil,
          infomedia_dealer_code: nil
        )
        printf '.'
      end

      puts "\nanonymize users"
      User.find_each do |user|
        user.update_columns(
          email: user.id.to_s + Faker::Internet.email,
          encrypted_password: ENV['DEFAULT_PASSWORD_ENCRYPTED'],
          name: Faker::Name.name,
          phone: DEFAULT_EMPTY_PHONE,
          username: user.id.to_s + Faker::Internet.email,
          cust_no: nil,
          cdk_employee_number: nil,
          avatar: nil
        )
        printf '.'
      end

      puts "\nanonymize customers"
      Customer.find_each do |customer|
        customer.update_columns(
          email: customer.id.to_s + Faker::Internet.email,
          name: Faker::Name.name,
          phone: DEFAULT_EMPTY_PHONE
        )
        printf '.'
      end
    end
  end
end
