require 'omniauth/strategies/oauth'
require 'evernote'

module OmniAuth
  module Strategies
    class Evernote < OmniAuth::Strategies::OAuth
      option :name, 'evernote'
      option :client_options, {
        :site => 'https://www.evernote.com',
        :request_token_path => '/oauth',
        :access_token_path => '/oauth',
        :authorize_path => '/OAuth.action'
      }

      uid { raw_info.id }

      info do
        {
          'name' => raw_info.name,
          'nickname' => raw_info.username,
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= begin
          user_store_url = consumer.site + '/edam/user'
          client = ::Evernote::Client.new(::Evernote::EDAM::UserStore::UserStore::Client, user_store_url, {})
          client.getUser(access_token.token)
        end
      end
    end
  end
end
