namespace :rooftop do
  namespace :algolia_search do

    desc "Initialise index settings for all models which include Rooftop::AlgoliaSearch"
    task initialize_indexes: :environment do
      puts "Resetting index settings, which might have been overwritten in the Algolia UI - are you sure?"
      puts "Please enter Y, y, N or n"
      STDOUT.flush
      input = STDIN.gets.chomp
      case input.upcase
        when "Y"
          puts "Continuing"
        else
          puts "Cancelled"
          next
      end
      ::Rails.application.eager_load!
      Rooftop::AlgoliaSearch.included_classes.each do |klass|
        puts "Setting index settings for #{klass}"
        klass.setup_index_settings!
      end
    end

    desc "Index all searchable entities"
    task reindex: :environment do
      puts "Reindexing all - are you sure?"
      puts "Please enter Y, y, N or n"
      STDOUT.flush
      input = STDIN.gets.chomp
      case input.upcase
        when "Y"
          puts "Continuing"
        else
          puts "Cancelled"
          next
      end

      ::Rails.application.eager_load!
      Rooftop::AlgoliaSearch.included_classes.each do |klass|
        puts "Reindexing #{klass}"
        klass.search_index.delete
        klass.reindex_entities(klass.all)
        puts "Done\n"
      end
    end
  end
end


