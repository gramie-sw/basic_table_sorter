require 'spec_helper'

describe BasicTableSorter::ViewHelpers do

  let(:helper) do
    helper_class = Class.new
    helper_class.send(:include, BasicTableSorter::ViewHelpers)
    helper_class.send(:include, ActionView::Helpers::TagHelper)
    helper_class.new
  end

  describe '#sortable' do

    it 'should call link_to with text and prams' do
      helper.stub(:params).and_return({})
      helper.should_receive(:link_to).with('Title', {table_sort: :title, table_sort_direction: 'asc'})
      helper.sortable(:title, 'Title')
    end

    it 'should call link_to with' do
      helper.stub(:params).and_return({table_sort: 'title'})
      helper.stub(:table_sort_direction).and_return('asc')

      expected_params = {table_sort: :title, table_sort_direction: 'desc'}
      helper.should_receive(:link_to).with(expected_params, class: 'selected-column') do |&block|
        block.call.should eq '<span>Title</span><i class="icon-chevron-down" />'
      end
      helper.sortable(:title, 'Title')
    end

    context 'is selected column and sorted asc' do

      it 'should have icon-chevron-up' do
        helper.stub(:table_sort_direction).and_return('asc')
        helper.stub(:params).and_return({controller: :users, action: :index, table_sort: 'first_name'})


        helper.should_receive(:link_to).with({table_sort: :first_name, table_sort_direction: 'desc'}, {:class => "selected-column"}) do |&block|
          block.call.should include('icon-chevron-down')
        end.once

        helper.sortable(:first_name, 'name')
      end
    end

    context 'is selected column and sorted desc' do

      it 'should have icon-arrow-down ' do
        helper.stub(:table_sort_direction).and_return('desc')
        helper.stub(:params).and_return({controller: :users, action: :index, table_sort: 'first_name'})


        helper.should_receive(:link_to).with({table_sort: :first_name, table_sort_direction: 'asc'}, {:class => "selected-column"}) do |&block|
          block.call.should include('icon-chevron-up')
        end.once

        helper.sortable(:first_name, 'name')
      end
    end

    context 'is not current column' do

      it 'should have just a title' do
        helper.stub(:params).and_return({controller: :users, action: :index, table_sort: 'first_name'})

        helper.should_receive(:link_to).with('name', {table_sort: :last_name, table_sort_direction: 'asc'}) do |&block|
          block.should be nil
        end.once

        helper.sortable(:last_name, 'name')
      end
    end
  end
end