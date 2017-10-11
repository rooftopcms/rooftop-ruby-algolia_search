module Rooftop
  module AlgoliaSearch
    class Engine < ::Rails::Engine

      isolate_namespace Rooftop::AlgoliaSearch

      initializer "add_helpers" do
        ActiveSupport.on_load(:action_controller) do
          include Rooftop::AlgoliaSearch::FacetHelper
        end
      end

      rake_tasks do
        Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
      end



    end
  end
end
