require 'declarative_authorization/maintenance'

module Alchemy
  module Specs

    # Helpers for integration specs
    #
    # This file is auto included in rspec integration/request tests.
    #
    module Helpers
      include Authorization::TestHelper

      # Shortcut method for:
      #
      #   * create_admin_user
      #   * login_into_alchemy
      #
      def authorize_as_admin
        create_admin_user
        login_into_alchemy
      end

      # Capybara actions to login into Alchemy Backend
      #
      # You should have a admin user before loggin in.
      #
      # See: create_admin_user method
      #
      def login_into_alchemy
        visit '/alchemy/admin/login'
        # delay the capybara steps on travis ci under ruby 1.8.7
        sleep 1 if ENV['CI'] && RUBY_VERSION == "1.8.7"
        fill_in('alchemy_user_session_login', :with => 'jdoe')
        fill_in('alchemy_user_session_password', :with => 's3cr3t')
        click_on('Login')
      end

      # Load additional authorization_rules for specs.
      #
      # For some strange reason, this isn't done automatically while running the specs
      #
      def load_authorization_rules
        instance = Alchemy::AuthEngine.get_instance
        instance.load(File.join(File.dirname(__FILE__), '../../dummy', 'config/authorization_rules.rb'))
      end

      # Creates an admin user in a way it works
      #
      # You should create it once in a before block
      #
      # === Example:
      #
      #   before do
      #     create_admin_user
      #   end
      #
      def create_admin_user
        @user = FactoryGirl.build(:admin_user).save_without_session_maintenance
      end

    end

  end
end

RSpec.configure do |c|
  c.include Alchemy::Specs::Helpers, :type => :request
end
