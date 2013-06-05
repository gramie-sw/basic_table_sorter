module BasicTableSorter
  module PermissionServiceAdditions

    def allowed_sort_param? controller, action, value
      allowed = @allowed_sort_values && @allowed_sort_values[[controller.to_s, action.to_s]]
      allowed ? allowed.include?(value) : allowed
    end

    def allow_sort_params controllers, actions, param_values
      @allowed_sort_values ||= {}
      Array(controllers).each do |controller|
        Array(actions).each do |action|
          unless @allowed_sort_values.has_key? [controller.to_s, action.to_s]
            @allowed_sort_values[[controller.to_s, action.to_s]] = []
          end
          @allowed_sort_values[[controller.to_s, action.to_s]].concat Array(param_values).map(&:to_s)
        end
      end
    end

    module ClassMethods

      def create()
        service = self.new
        service.configure_permissions
        service
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end