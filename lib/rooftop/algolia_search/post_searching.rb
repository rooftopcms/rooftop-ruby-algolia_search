module Rooftop
  module AlgoliaSearch
    module PostSearching

      def self.included(base)
        base.extend ClassMethods

      end

      module ClassMethods

        def search(query, opts = {}, index_name=nil)
          opts = opts.with_indifferent_access
          if index_name
            index = replica_indexes.find {|i| i.name == index_name}
            raise ArgumentError, "Unknown search index name: #{index_name}" if index.nil?
          else
            index = search_index
          end
          index.search(query, opts).with_indifferent_access
        end
      end

    end
  end
end