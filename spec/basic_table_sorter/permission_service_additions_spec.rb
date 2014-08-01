require 'spec_helper'

describe BasicTableSorter::PermissionServiceAdditions do

  before :each do
    @sort_params_permission_service = BasicTableSorterPermissionService.create
  end

  describe '::included' do

    it 'should extend included class with module ClassMethods' do
      clazz = Class.new
      expect(clazz).to receive(:extend).with(BasicTableSorter::PermissionServiceAdditions::ClassMethods)
      clazz.send(:include, BasicTableSorter::PermissionServiceAdditions)
    end
  end

  describe '::create' do

    it 'should create a BasicTableSorterPermissionService instance object' do
      expect(@sort_params_permission_service).to be_an_instance_of(BasicTableSorterPermissionService)
    end

    it 'should call configure_permissions' do
      expect_any_instance_of(BasicTableSorterPermissionService).to receive(:configure_permissions)
      BasicTableSorterPermissionService.create
    end
  end

  describe '#allowed_sort_param?' do

    it 'should return false if @allowed_sort_values is nil' do
      @sort_params_permission_service.instance_variable_set(:@allowed_sort_values, nil)
      expect(@sort_params_permission_service.allowed_sort_param?(nil, nil, nil)).to be_falsey
    end

    it 'should return false if @allowed_sort_value does not have given value' do
      allowed_sort_values = {}
      allowed_sort_values[['customer', 'index']] = ['last_name']
      @sort_params_permission_service.instance_variable_set(:@allowed_sort_values, allowed_sort_values)
      expect(@sort_params_permission_service.allowed_sort_param?('customer', 'index', 'first_name')).to be_falsey
    end

    it 'should return true if @allowed_sort_value does have given value' do
      allowed_sort_values = {}
      allowed_sort_values[['customer', 'index']] = ['first_name']
      @sort_params_permission_service.instance_variable_set(:@allowed_sort_values, allowed_sort_values)
      expect(@sort_params_permission_service.allowed_sort_param?('customer', 'index', 'first_name')).to be_truthy
    end
  end

  describe '#allow_sort_params' do

    it 'should insert value into @allow sort values' do
      @sort_params_permission_service.allow_sort_params('customer', 'index', 'last_name')
      expect(@sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'index']]).to eq ['last_name']
    end

    it 'should insert values into @allow sort values' do
      @sort_params_permission_service.allow_sort_params('customer', 'index', ['first_name', 'last_name'])
      expect(@sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'index']]).to eq ['first_name', 'last_name']
    end

    it 'should insert value for two keys' do
      @sort_params_permission_service.allow_sort_params(['customer', 'person'], ['index', 'edit'], 'first_name')
      expect(@sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'index']]).to eq ['first_name']
      expect(@sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['person', 'index']]).to eq ['first_name']
      expect(@sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'edit']]).to eq ['first_name']
      expect(@sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['person', 'edit']]).to eq ['first_name']
    end
  end
end