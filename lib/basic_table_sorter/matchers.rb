RSpec::Matchers.define :allow_sort_value do |*args|
  match do |sort_params_permission_service|
    sort_params_permission_service.allowed_sort_value?(*args).should be_true
  end
end