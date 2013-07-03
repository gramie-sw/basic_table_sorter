require 'spec_helper'

describe BasicTableSorter::ViewHelpers do

  let(:helper) do
    helper_class = Class.new
    helper_class.send(:include, BasicTableSorter::ViewHelpers)
    helper_class.send(:include, ActionView::Helpers::TagHelper)
    helper_class.any_instance.stub(:url_for).and_return('url_returned_by_url_for')
    helper_class.any_instance.stub(:link_to)
    helper_class.new
  end

  describe '#sortable' do

    context 'column selected' do

      it 'should create link with title and icon' do
        helper.stub(:params).and_return({table_sort: 'title'})
        helper.stub(:table_sort_direction).and_return('asc')

        helper.should_receive(:link_to).with('url_returned_by_url_for', class: 'selected-column') do |&block|
          block.call.should match /<span>Title<\/span><i class="icon-.*" \/>/
        end
        helper.sortable(:title, 'Title')
      end


      it 'should call url_for with correct params' do
        helper.stub(:params).and_return({table_sort: 'title'})
        helper.stub(:table_sort_direction).and_return('asc')
        expected_link_params = {table_sort: :title, table_sort_direction: 'desc'}
        helper.should_receive(:url_for).with(expected_link_params)
        helper.sortable(:title, 'Title')
      end

      context 'column sorted asc' do

        before :each do
          helper.stub(:table_sort_direction).and_return('asc')
          helper.stub(:params).and_return({controller: 'users', action: 'index', table_sort: 'name'})
        end

        it 'should have link to sort desc' do
          helper.should_receive(:link_to).with('url_returned_by_url_for', {:class => "selected-column"})
          helper.sortable(:name, 'Name')
        end

        it 'should have icon-chevron-down' do

          helper.should_receive(:link_to).with(any_args) do |&block|
            block.call.should include('icon-chevron-down')
          end.once

          helper.sortable(:name, 'Name')
        end
      end

      context 'column sorted desc' do

        before :each do
          helper.stub(:table_sort_direction).and_return('desc')
          helper.stub(:params).and_return({controller: 'users', action: 'index', table_sort: 'name'})
        end

        it 'should have link to sort asc' do
          expected_link_params = {:table_sort => :name, :table_sort_direction => "asc"}
          helper.should_receive(:link_to).with('url_returned_by_url_for', {:class => "selected-column"})
          helper.sortable(:name, 'Name')
        end

        it 'should have icon-arrow-up' do
          helper.should_receive(:link_to).with(any_args) do |&block|
            block.call.should include('icon-chevron-up')
          end.once

          helper.sortable(:name, 'Name')
        end
      end
    end

    context 'column not selected' do

      it 'should return link with title' do
        helper.stub(:params).and_return({table_sort: 'first_name'})
        helper.should_receive(:link_to).with('Name', 'url_returned_by_url_for')
        helper.sortable(:last_name, 'Name')
      end

      it 'should call url_for with correct params' do
        helper.stub(:params).and_return({table_sort: 'first_name'})
        expected_params = {table_sort: :last_name, table_sort_direction: 'asc'}
        helper.should_receive(:url_for).with(expected_params)
        helper.sortable(:last_name, 'Name')
      end
    end

    it 'should merge additional arguments before calling url for' do
      helper.stub(:params).and_return({table_sort: 'title'})
      epected_params = {table_sort: :last_name, table_sort_direction: 'asc', extra_param: 'extra_param'}
      helper.should_receive(:url_for).with(epected_params)
      helper.sortable(:last_name, 'Name', extra_param: 'extra_param')
    end
  end
end