module Rooftop
  module AlgoliaSearch
    class Engine < ::Rails::Engine

      isolate_namespace Rooftop::AlgoliaSearch

      config.before_initialize do

      end

      rake_tasks do
        Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
      end



    end
  end
end
