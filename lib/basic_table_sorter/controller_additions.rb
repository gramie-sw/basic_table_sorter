module BasicTableSorter
  module ControllerAdditions

    def self.included(base)
      base.helper_method :table_sort_direction
    end

    def table_sort_direction
      %w[asc desc].include?(params[:table_sort_direction]) ? params[:table_sort_direction] : "asc"
    end

    def custom_table_sort?
      params.has_key? :table_sort
    end

    def table_sort_order
      custom_table_sort? ? "#{Array(params[:table_sort]).join(" #{table_sort_direction}, ")} #{table_sort_direction}" : nil
    end

    def authorize_table_sort_params
      if params[:table_sort]
        sort_params_permission_service = BasicTableSorterPermissionService.create
        Array(params[:table_sort]).each do |value|
          unless sort_params_permission_service.allowed_sort_param?(params[:controller], params[:action], value)
            raise TableSortParamNotAuthorized, "param table_sort = '#{params[:table_sort]}' not allowed"
          end
        end
      end
    end
  end
end