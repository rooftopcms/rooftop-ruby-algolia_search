module Rooftop
  module AlgoliaSearch
    module PostIndexing

      def self.included(base)
        base.extend ClassMethods

        base.send :setup_index_name!

        base.send :after_save, :reindex!
        base.send :after_destroy, :deindex!

      end

      module ClassMethods
        attr_reader :search_index_name

        def search_index_name=(name)
          @search_index_name = name
          setup_index_name!
        end

        def setup_index_name!
          @search_index_name ||= self.to_s.underscore
        end


        def add_search_fields(*fields)
          @search_fields ||= []
          fields.each {|f| @search_fields << f}
        end
        alias_method :add_search_field, :add_search_fields

        def search_fields
          @search_fields ||= []
        end

        def reindex_all
          reindex_entities(all.to_a)
        end

        def reindex_entities(*entities)
          search_index.add_objects(entities.collect(&:to_search_index_parameters))
        end

        alias_method :reindex_entity, :reindex_entities

        def deindex_entities(*entities)
          search_index.delete_objects(entities.collect(&:id))
        end

        alias_method :deindex_entity, :deindex_entities


        def search_index
          Algolia::Index.new(@search_index_name)
        end

      end

      # Reindex an instance
      def reindex!
        # only reindex things which are published
        if status == 'publish'
          self.class.reindex_entity(self)
        else
          deindex!
        end
      end

      def deindex!
        self.class.deindex_entity(self)
      end

      def to_search_index_parameters
        self.class.search_fields.inject({}) do |hash, fields|
          hash[:objectID] = self.id
          fields.each do |field|
            begin
              hash[field] = self.send(field)
            rescue NoMethodError
              if self.has_field?(field)
                hash[field] = self.fields.send(field)
              end
            end
          end
          hash
        end
      end
    end
  end
end