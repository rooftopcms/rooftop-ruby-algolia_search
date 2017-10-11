module Rooftop
  module AlgoliaSearch
    module PostSearching

      def self.included(base)
        base.extend ClassMethods

        base.send :setup_index_name!
      end

      module ClassMethods
        attr_reader :search_index_name

        def search_index_name=(name)
          @search_index_name = name
          setup_index_name!
        end

        def search_index
          @search_index ||= Algolia::Index.new(@search_index_name)
        end

        def perform_search(query)
          search_index.search(query)
        end
      end

    end
  end
end