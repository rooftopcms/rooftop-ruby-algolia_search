module Rooftop
  module AlgoliaSearch
    module FacetHelper

      def build_facet_query(hash)
      #   takes a hash like this:
      #   {
      #     foo: ['bar', 'baz'],
      #     qux: ['boo']
      #
      #   }

        # returns this
        # [["foo:bar", "foo:baz"],"qux:boo"]
        hash.collect do |k,v|
          if v.is_a?(Array)
            v.collect {|val| "#{k}:#{val}"}
          elsif v.is_a?(String) || v.is_a?(Symbol)
            "#{k}:#{v}"
          end
        end
      end
    end
  end
end