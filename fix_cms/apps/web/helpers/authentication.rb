# frozen_string_literal: true

module Web
  module Helpers
  end
end

module Web
  module Helpers
    module Authentication
      def self.included(action)
        action.class_eval do
          expose :current_account
          before :authenticate!
        end
      end

      def authenticate!
        origin_path = params.env['REQUEST_PATH'] ? "/?origin=#{params.env['REQUEST_PATH']}" : nil
        redirect_to("/auth/login#{origin_path}") unless authenticated?
      end

      def authenticated?
        !!current_account.id
      end

      def current_account
        @current_account ||= Account.new(session[:account])
      end
    end
  end
end
