require 'spec_helper'

describe 'ControllerAdditions' do

  before :each do
    @controller_class = Class.new
    @controller_class.stub(:helper_method)
    @controller_class.send(:include, BasicTableSorter::ControllerAdditions)
    @controller = @controller_class.new
  end

  describe '::included' do

    it 'should provide table_sort_direction as helper method' do
      controller_class = Class.new
      controller_class.should_receive(:helper_method).with(:table_sort_direction)
      controller = controller_class.new
      controller.singleton_class.send(:include, BasicTableSorter::ControllerAdditions)
    end
  end

  describe '#table_sort_direction' do

    it 'should return asc if params table_sort_direction does not exits' do
      @controller.stub(:params).and_return({})
      @controller.table_sort_direction.should eq 'asc'
    end

    it 'should return asc if params table_sort_direction is not asc or desc' do
      @controller.stub(:params).and_return({table_sort_direction: 'test'})
      @controller.table_sort_direction.should eq 'asc'
    end

    it 'should return desc if params table_sort_direction has value desc' do
      @controller.stub(:params).and_return({table_sort_direction: 'desc'})
      @controller.table_sort_direction.should eq 'desc'
    end
  end

  describe '#custom_table_sort?' do

    it 'should return true if params has key table_sort' do
      @controller.stub(:params).and_return({table_sort: 'test'})
      @controller.custom_table_sort?.should be_true
    end

    it 'should return false if params has no key table_sort' do
      @controller.stub(:params).and_return({})
      @controller.custom_table_sort?.should be_false
    end
  end

  describe '#table_sort_order' do

    it 'should return column with table sort direction as string' do
      @controller.stub(:params).and_return({table_sort: 'last_name', table_sort_direction: 'desc'})
      @controller.table_sort_order.should eq "last_name desc"
    end

    it 'should return columns together with sort direction as string if multiple given' do
      @controller.stub(:params).and_return({table_sort: ['last_name', 'first_name'], table_sort_direction: 'desc'})
      @controller.table_sort_order.should eq "last_name desc, first_name desc"
    end

    it 'should return nil when no param :table_sort present' do
      @controller.stub(:params).and_return({})
      @controller.table_sort_order.should be_nil
    end
  end

  describe '#authorize_table_sort_params' do

    it 'should call allowed_sort_param? if param with value table_sort exits' do
      @controller.stub(:params).and_return(controller: 'users', action: 'index', table_sort: 'last_name')
      BasicTableSorterPermissionService.
          any_instance.should_receive(:allowed_sort_param?).
          with('users', 'index', 'last_name').
          and_return(true)
      @controller.authorize_table_sort_params
    end

    it 'should raise BasicTableSorter::TableSortParamNotAuthorized if allowed_sort_param? returns false' do
      @controller.stub(:params).and_return(table_sort: 'last_name')
      BasicTableSorterPermissionService.any_instance.stub(:allowed_sort_param?).and_return false
      expect {
        @controller.authorize_table_sort_params
      }.to raise_error BasicTableSorter::TableSortParamNotAuthorized,  "param table_sort = 'last_name' not allowed"
    end

    it 'should not call authorize_table_sort_params if params has no value table_sort' do
      @controller.stub(:params).and_return({})
      @controller.should_not_receive(:allowed_sort_param?)
      @controller.authorize_table_sort_params
    end
  end
end