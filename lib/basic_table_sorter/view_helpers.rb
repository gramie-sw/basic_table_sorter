module BasicTableSorter
  module ViewHelpers

    def sortable(columns, title, additional_params = {})

      column_selected = Array(columns).map(&:to_s).eql? Array(params[:table_sort])

      sort_direction = (column_selected && "asc" == table_sort_direction) ? "desc" : "asc"
      icon_class = sort_direction == 'asc' ? 'icon-chevron-up' : 'icon-chevron-down'

      params = {table_sort: columns, table_sort_direction: sort_direction}.merge(additional_params)

      if column_selected
        link_to params, class: 'selected-column' do
          content_tag(:span, title) + tag(:i, class: icon_class)
        end
      else
        link_to title, params
      end
    end
  end
end