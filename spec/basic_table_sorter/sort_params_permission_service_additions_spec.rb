require 'spec_helper'

describe 'SortParamsPermissionServiceAdditions' do

  before :each do
    @sort_params_permission_service = SortParamsPermissionService.create
  end

  describe '::included' do

    it 'should extend included class with module ClassMethods' do
      clazz = Class.new
      clazz.should_receive(:extend).with(BasicTableSorter::SortParamsPermissionServiceAdditions::ClassMethods)
      clazz.send(:include, BasicTableSorter::SortParamsPermissionServiceAdditions)
    end
  end

  describe '::create' do

    it 'should create a SortParamsPermissionService instance object' do
      @sort_params_permission_service.should be_an_instance_of(SortParamsPermissionService)
    end

    it 'should call configure_permissions' do
      SortParamsPermissionService.any_instance.should_receive(:configure_permissions)
      SortParamsPermissionService.create
    end
  end

  describe '#allowed_sort_value?' do

    it 'should return false if @allowed_sort_values is nil' do
      @sort_params_permission_service.instance_variable_set(:@allowed_sort_values, nil)
      @sort_params_permission_service.allowed_sort_value?(nil, nil, nil).should be_false
    end

    it 'should return false if @allowed_sort_value does not have given value' do
      allowed_sort_values = {}
      allowed_sort_values[['customer', 'index']] = ['last_name']
      @sort_params_permission_service.instance_variable_set(:@allowed_sort_values, allowed_sort_values)
      @sort_params_permission_service.allowed_sort_value?('customer', 'index', 'first_name').should be_false
    end

    it 'should return true if @allowed_sort_value does have given value' do
      allowed_sort_values = {}
      allowed_sort_values[['customer', 'index']] = ['first_name']
      @sort_params_permission_service.instance_variable_set(:@allowed_sort_values, allowed_sort_values)
      @sort_params_permission_service.allowed_sort_value?('customer', 'index', 'first_name').should be_true
    end
  end

  describe '#allow_sort_values' do

    it 'should insert value into @allow sort values' do
      @sort_params_permission_service.allow_sort_values('customer', 'index', 'last_name')
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'index']].should eq ['last_name']
    end

    it 'should insert values into @allow sort values' do
      @sort_params_permission_service.allow_sort_values('customer', 'index', ['first_name', 'last_name'])
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'index']].should eq ['first_name', 'last_name']
    end

    it 'should insert value for two keys' do
      @sort_params_permission_service.allow_sort_values(['customer', 'person'], ['index', 'edit'], 'first_name')
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'index']].should eq ['first_name']
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['person', 'index']].should eq ['first_name']
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['customer', 'edit']].should eq ['first_name']
      @sort_params_permission_service.instance_variable_get(:@allowed_sort_values)[['person', 'edit']].should eq ['first_name']
    end
  end
end