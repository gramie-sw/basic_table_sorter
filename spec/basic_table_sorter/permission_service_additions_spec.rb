require 'spec_helper'

describe BasicTableSorter::PermissionServiceAdditions do

  before :each do
    @sort_params_permission_service = BasicTableSorterPermissionService.create
  end

  describe '::included' do

    it 'should extend included class with module ClassMethods' do
      clazz = Class.new
      clazz.should_receive(:extend).with(BasicTableSorter::PermissionServiceAdditions::ClassMethods)
      clazz.send(:include, BasicTableSorter::PermissionServiceAdditions)
    end
  end

  describe '::create' do

    it 'should create a BasicTableSorterPermissionService instance object' do
      @sort_params_permission_service.should be_an_instance_of(BasicTableSorterPermissionService)
    end

    it 'should call configure_permissions' do
      BasicTableSorterPermissionService.any_instance.should_receive(:configure_permissions)
      BasicTableSorterPermissionService.create
    end
  end

  describe '#allowed_sort_param?' do

    it 'should return false if @allowed_sort_values is nil' do
      @sort_params_permission_service.instance_variable_set(:@allowed_sort_values, nil)
      @sort_params_permission_service.allowed_sort_param?(nil, nil, nil).should be_false
    end

    it 'should return false if @allowed_sort_value does not have given value' do
      allowed_sort_values = {}
      allowed_sort_values[['customer', 'index']] = ['last_name']
      @sort_params_permission_service.instance_variable_set(:@allowed_sort_values, allowed_sort_values)
      @sort_params_permission_service.allowed_sort_param?('customer', 'index', 'first_name').should be_false
    end

    it 'should return true if @allowed_sort_value does have given value' do
      allowed_sort_values = {}
      allowed_sort_values[['customer', 'index']] = ['first_name']
      @sort_params_permission_service.instance_variable_set(:@allowed_sort_values, allowed_sort_values)
      @sort_params_permission_service.allowed_sort_param?('customer', 'index', 'first_name').should be_true
    end
  end

  describe '#allow_sort_params' do

    it 'should insert value into @allow sort values' do
      @sort_params_permission_service.allow_sort_params('customer', 'index', 'last_name')
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'index']].should eq ['last_name']
    end

    it 'should insert values into @allow sort values' do
      @sort_params_permission_service.allow_sort_params('customer', 'index', ['first_name', 'last_name'])
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'index']].should eq ['first_name', 'last_name']
    end

    it 'should insert value for two keys' do
      @sort_params_permission_service.allow_sort_params(['customer', 'person'], ['index', 'edit'], 'first_name')
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'index']].should eq ['first_name']
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['person', 'index']].should eq ['first_name']
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'edit']].should eq ['first_name']
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['person', 'edit']].should eq ['first_name']
    end
  end
end