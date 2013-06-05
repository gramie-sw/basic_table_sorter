RSpec::Matchers.define :allow_sort_param do |controller, action, value|
  match do |sort_params_permission_service|
    sort_params_permission_service.allowed_sort_param?(controller, action, value.to_s).should be_true
  end
end