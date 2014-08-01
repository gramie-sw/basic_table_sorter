RSpec::Matchers.define :allow_sort_param do |controller, action, value|
  match do |sort_params_permission_service|
    expect(sort_params_permission_service.allowed_sort_param?(controller, action, value.to_s)).to be_truthy
  end
end