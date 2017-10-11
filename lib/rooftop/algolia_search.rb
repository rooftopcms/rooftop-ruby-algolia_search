require 'algoliasearch'
require "rooftop/algolia_search/version"
require "rooftop/algolia_search/post_indexing"
if defined?(Rails)
  require "rooftop/algolia_search/engine"
end

module Rooftop
  module AlgoliaSearch
    class << self
      attr_accessor :configuration
      def configure
        self.configuration ||= Configuration.new
        yield(configuration)
        self.configuration.configure_connection
      end
    end

    def self.included(base)
      base.include PostIndexing
    end

    class Configuration
      attr_accessor :index_api_key,
                    :search_api_key,
                    :application_id

      attr_reader :index_connection, :search_connection

      def configure_connection
        ::Algolia.init( application_id: @application_id,
                      api_key: @index_api_key)
      end
    end

    class Error < StandardError

    end
  end
end
