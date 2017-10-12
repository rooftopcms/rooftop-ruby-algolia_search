module Rooftop
  module AlgoliaSearch
    module FacetHelper

      def build_facet_query(hash,opts = {})
      #   takes a hash like this:
      #   {
      #     foo: ['bar', 'baz'],
      #     qux: ['boo']
      #
      #   }

        if opts[:or]
          # returns this
          # ["foo:bar", "foo:baz", "qux:boo"]
          result = []
          hash.each do |k,v|
            if v.is_a?(Array)
              v.each {|val| result << "#{k}:#{val}"}
            else
              result << "#{k}:#{v}"
            end
          end
          return [result]
        else
          # returns this
          # [["foo:bar", "foo:baz"],"qux:boo"]
          hash.collect do |k,v|
            if v.is_a?(Array)
              v.collect {|val| "#{k}:#{val}"}
            else
              "#{k}:#{v}"
            end
          end

        end

      end
    end
  end
end