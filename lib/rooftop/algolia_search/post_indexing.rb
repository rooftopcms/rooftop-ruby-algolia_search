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
        attr_reader :search_index_name, :search_index_settings, :search_fields, :search_index_replica_names

        def search_index_name=(name)
          @search_index_name = name
          setup_index_name!
        end

        def search_index_settings=(settings)
          @search_index_settings ||= settings
          end

        def search_index_replica_names=(settings)
          @search_index_replica_names ||= settings
        end


        def setup_index_settings!
          raise ArgumentError, "No search index settings have been defined. Call self.search_index_settings = on the class you've mixed Rooftop::AlgoliaSearch into." if @search_index_settings.nil?
          if replica_indexes.any?
            # we need to set the settings for replicas too
            replica_indexes.each do |index|
              index.set_settings(@search_index_settings.merge(ranking: Array.wrap(@search_index_replica_names[index.name.to_sym])))
            end
            search_index.set_settings(@search_index_settings.merge({replicas: replica_indexes.collect(&:name)}),forwardToReplicas: true)
          else
            search_index.set_settings(@search_index_settings)
          end
        end

        def setup_index_name!
          @search_index_name ||= self.to_s.underscore
        end


        def add_search_fields(*fields)
          @search_fields ||= []
          fields.each {|f| @search_fields << f}
        end

        def add_search_field(field, options = nil)
          @search_fields ||= []

          @search_fields << [field, options].compact
        end

        def search_fields
          @search_fields ||= []
        end

        def reindex_all
          reindex_entities(all.to_a)
        end

        def reindex_entities(entities)
          entities = Array.wrap(entities)
          search_index.add_objects(entities.collect(&:to_search_index_parameters))
        end

        alias_method :reindex_entity, :reindex_entities

        def deindex_entities(entities)
          entities = Array.wrap(entities)
          search_index.delete_objects(entities.collect(&:id))
        end

        alias_method :deindex_entity, :deindex_entities

        def clear_index!
          search_index.clear_index
        end


        def search_index
          @search_index ||= Algolia::Index.new(@search_index_name)
        end

        #Iterate over replica names creating new indexes in memory (memoized)
        def replica_indexes
          if @search_index_replica_names.is_a?(Hash) && @search_index_replica_names.any?
            @search_index_replicas = @search_index_replica_names.collect do |name, sort|
              Algolia::Index.new(name.to_s)
            end
          else
            []
          end
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

      alias :index! :reindex!

      def deindex!
        self.class.deindex_entity(self)
      end

      def to_search_index_parameters
        self.class.search_fields.inject({}) do |hash, fields|
          hash[:objectID] = self.id

          if fields.last.is_a? Proc
            hash[fields.first] = fields.last.call(self)
          else
            fields.each do |field|
              begin
                hash[field] = self.send(field)
              rescue NoMethodError
                if self.has_field?(field)
                  hash[field] = self.fields.send(field)
                end
              end
            end
          end

          hash
        end
      end
    end
  end
end