module BasicTableSorter
  class Railtie < Rails::Railtie
    initializer "basic_table_sorter.controller_additions" do
      ActionController::Base.send :include, ControllerAdditions
    end
  end
end