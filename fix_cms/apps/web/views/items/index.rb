module Web
  module Views
    module Items
      class Index
        include Web::View

        def fix_item(item_id)
          html.form(action: routes.item_issue_path, method: 'POST') do
            input(type: 'hidden', name: '_method', value: 'DELETE')
            input(type: 'hidden', name: 'item_id', value: item_id)
            input(type: 'submit', value: 'Fix item', class: 'btn btn-success')
          end
        end
      end
    end
  end
end
