require 'algoliasearch'
require "rooftop/algolia_search/version"
require "rooftop/algolia_search/post_indexing"
require "rooftop/algolia_search/post_searching"
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
      @included_classes ||= []
      @included_classes << base unless @included_classes.include?(base)
      base.include PostIndexing
      base.include PostSearching
    end

    class Configuration
      attr_accessor :index_api_key,
                    :search_api_key,
                    :application_id,
                    :settings

      attr_reader :index_connection, :search_connection

      def configure_connection
        ::Algolia.init( application_id: @application_id,
                      api_key: @index_api_key)
      end
    end

    class Error < StandardError

    end

    def self.included_classes
      @included_classes
    end
  end
end
