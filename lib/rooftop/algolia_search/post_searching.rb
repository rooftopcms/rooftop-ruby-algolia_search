module Rooftop
  module AlgoliaSearch
    module PostSearching

      def self.included(base)
        base.extend ClassMethods

      end

      module ClassMethods

        def search(query, opts = {})
          opts = opts.with_indifferent_access
          search_index.search(query, opts).with_indifferent_access
        end
      end

    end
  end
end