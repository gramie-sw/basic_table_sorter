require 'spec_helper'

describe 'ControllerAdditions' do

  before :each do
    @controller_class = Class.new
    allow(@controller_class).to receive(:helper_method)
    @controller_class.send(:include, BasicTableSorter::ControllerAdditions)
    @controller = @controller_class.new
  end

  describe '::included' do

    it 'should provide table_sort_direction as helper method' do
      controller_class = Class.new
      expect(controller_class).to receive(:helper_method).with(:table_sort_direction)
      controller = controller_class.new
      controller.singleton_class.send(:include, BasicTableSorter::ControllerAdditions)
    end
  end

  describe '#table_sort_direction' do

    it 'should return asc if params table_sort_direction does not exits' do
      allow(@controller).to receive(:params).and_return({})
      expect(@controller.table_sort_direction).to eq 'asc'
    end

    it 'should return asc if params table_sort_direction is not asc or desc' do
      allow(@controller).to receive(:params).and_return({table_sort_direction: 'test'})
      expect(@controller.table_sort_direction).to eq 'asc'
    end

    it 'should return desc if params table_sort_direction has value desc' do
      allow(@controller).to receive(:params).and_return({table_sort_direction: 'desc'})
      expect(@controller.table_sort_direction).to eq 'desc'
    end
  end

  describe '#custom_table_sort?' do

    it 'should return true if params has key table_sort' do
      allow(@controller).to receive(:params).and_return({table_sort: 'test'})
      expect(@controller.custom_table_sort?).to be_truthy
    end

    it 'should return false if params has no key table_sort' do
      allow(@controller).to receive(:params).and_return({})
      expect(@controller.custom_table_sort?).to be_falsey
    end
  end

  describe '#table_sort_order' do

    it 'should return column with table sort direction as string' do
      allow(@controller).to receive(:params).and_return({table_sort: 'last_name', table_sort_direction: 'desc'})
      expect(@controller.table_sort_order).to eq "last_name desc"
    end

    it 'should return columns together with sort direction as string if multiple given' do
      allow(@controller).to receive(:params).and_return({table_sort: ['last_name', 'first_name'], table_sort_direction: 'desc'})
      expect(@controller.table_sort_order).to eq "last_name desc, first_name desc"
    end

    it 'should return nil when no param :table_sort present' do
      allow(@controller).to receive(:params).and_return({})
      expect(@controller.table_sort_order).to be_nil
    end
  end

  describe '#authorize_table_sort_params' do

    it 'should call allowed_sort_param? if param with value table_sort exits' do
      allow(@controller).to receive(:params).and_return(controller: 'users', action: 'index', table_sort: 'last_name')
      expect_any_instance_of(BasicTableSorterPermissionService).to receive(:allowed_sort_param?).
          with('users', 'index', 'last_name').
          and_return(true)
      @controller.authorize_table_sort_params
    end

    it 'should raise BasicTableSorter::TableSortParamNotAuthorized if allowed_sort_param? returns false' do
      allow(@controller).to receive(:params).and_return(table_sort: 'last_name')
      allow_any_instance_of(BasicTableSorterPermissionService).to receive(:allowed_sort_param?).and_return false
      expect {
        @controller.authorize_table_sort_params
      }.to raise_error BasicTableSorter::TableSortParamNotAuthorized,  "param table_sort = 'last_name' not allowed"
    end

    it 'should not call authorize_table_sort_params if params has no value table_sort' do
      allow(@controller).to receive(:params).and_return({})
      expect(@controller).not_to receive(:allowed_sort_param?)
      @controller.authorize_table_sort_params
    end
  end
end