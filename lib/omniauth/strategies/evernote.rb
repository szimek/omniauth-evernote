require 'omniauth/strategies/oauth'
require 'evernote-thrift'

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

      uid { raw_info.id.to_s }

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
        @raw_info ||=
          begin
            userStoreUrl = consumer.site + '/edam/user'
            userStoreTransport = ::Thrift::HTTPClientTransport.new(userStoreUrl)
            userStoreProtocol = ::Thrift::BinaryProtocol.new(userStoreTransport)
            userStore = ::Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)
            userStore.getUser(access_token.token)
          end
      end
    end
  end
end
