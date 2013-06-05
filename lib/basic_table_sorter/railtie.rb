module BasicTableSorter
  class Railtie < Rails::Railtie
    initializer "basic_table_sorter.controller_additions" do
      ActionController::Base.send :include, ControllerAdditions
    end
    initializer "basic_table_sorter.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end