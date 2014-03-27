require 'toml'
require 'active_support/core_ext'

module Nata2
  class Client
    class Config
      def self.get(method, *args)
        @self ||= new
        args.empty? ? @self.send(method) : @self.send(method, *args)
      end

      private

      def fetch_lines_limit
        config[:default][:fetch_lines_limit]
      end

      def connection_settings(hostname)
        hostname = hostname.to_sym unless hostname.is_a?(Symbol)

        result = if config[hostname]
                   config[:default].deep_merge(config[hostname])
                 else
                   config[:default]
                 end
        result.select { |k,v| k == :ssh || k == :mysql }
      end

      def test
        'test'
      end

      def config
        @config ||= TOML.load_file(File.expand_path('../../..') + '/config.sample.toml').deep_symbolize_keys
      end
    end
  end
end