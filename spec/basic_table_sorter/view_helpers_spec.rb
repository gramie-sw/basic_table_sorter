require 'spec_helper'

describe BasicTableSorter::ViewHelpers do

  let(:helper) do
    helper_class = Class.new
    helper_class.send(:include, BasicTableSorter::ViewHelpers)
    helper_class.send(:include, ActionView::Helpers::TagHelper)
    allow_any_instance_of(helper_class).to receive(:url_for).and_return('url_returned_by_url_for')
    allow_any_instance_of(helper_class).to receive(:link_to)
    helper_class.new
  end

  describe '#sortable' do

    context 'column selected' do

      it 'should create link with title and icon' do
        allow(helper).to receive(:params).and_return({table_sort: 'title'})
        allow(helper).to receive(:table_sort_direction).and_return('asc')

        expect(helper).to receive(:link_to).with('url_returned_by_url_for', class: 'selected-column') do |&block|
          expect(block.call).to match /<span>Title<\/span><i class="icon-.*" \/>/
        end
        helper.sortable(:title, 'Title')
      end


      it 'should call url_for with correct params' do
        allow(helper).to receive(:params).and_return({table_sort: 'title'})
        allow(helper).to receive(:table_sort_direction).and_return('asc')
        expected_link_params = {table_sort: :title, table_sort_direction: 'desc'}
        expect(helper).to receive(:url_for).with(expected_link_params)
        helper.sortable(:title, 'Title')
      end

      context 'column sorted asc' do

        before :each do
          allow(helper).to receive(:table_sort_direction).and_return('asc')
          allow(helper).to receive(:params).and_return({controller: 'users', action: 'index', table_sort: 'name'})
        end

        it 'should have link to sort desc' do
          expect(helper).to receive(:link_to).with('url_returned_by_url_for', {:class => "selected-column"})
          helper.sortable(:name, 'Name')
        end

        it 'should have icon-chevron-down' do

          expect(helper).to receive(:link_to).with(any_args) { |&block|
            expect(block.call).to include('icon-chevron-down')
          }.once

          helper.sortable(:name, 'Name')
        end
      end

      context 'column sorted desc' do

        before :each do
          allow(helper).to receive(:table_sort_direction).and_return('desc')
          allow(helper).to receive(:params).and_return({controller: 'users', action: 'index', table_sort: 'name'})
        end

        it 'should have link to sort asc' do
          expected_link_params = {:table_sort => :name, :table_sort_direction => "asc"}
          expect(helper).to receive(:link_to).with('url_returned_by_url_for', {:class => "selected-column"})
          helper.sortable(:name, 'Name')
        end

        it 'should have icon-arrow-up' do
          expect(helper).to receive(:link_to).with(any_args) { |&block|
            expect(block.call).to include('icon-chevron-up')
          }.once

          helper.sortable(:name, 'Name')
        end
      end
    end

    context 'column not selected' do

      it 'should return link with title' do
        allow(helper).to receive(:params).and_return({table_sort: 'first_name'})
        expect(helper).to receive(:link_to).with('Name', 'url_returned_by_url_for')
        helper.sortable(:last_name, 'Name')
      end

      it 'should call url_for with correct params' do
        allow(helper).to receive(:params).and_return({table_sort: 'first_name'})
        expected_params = {table_sort: :last_name, table_sort_direction: 'asc'}
        expect(helper).to receive(:url_for).with(expected_params)
        helper.sortable(:last_name, 'Name')
      end
    end

    it 'should merge additional arguments before calling url for' do
      allow(helper).to receive(:params).and_return({table_sort: 'title'})
      epected_params = {table_sort: :last_name, table_sort_direction: 'asc', extra_param: 'extra_param'}
      expect(helper).to receive(:url_for).with(epected_params)
      helper.sortable(:last_name, 'Name', extra_param: 'extra_param')
    end
  end
end