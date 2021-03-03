module Web
  module Views
    module Items
      class Index
        include Web::View

        def current_account_admin?
          AccountRepository.new.find(current_account.id).role == 'admin'
        end

        def book_item(item_id)
          html.form(action: routes.book_item_path, method: 'POST') do
            input(type: 'hidden', name: 'item_id', value: item_id)
            input(type: 'submit', value: 'Book item', class: 'btn btn-success')
          end
        end

        def unbook_item(item_id)
          html.form(action: routes.book_item_path, method: 'POST') do
            input(type: 'hidden', name: '_method', value: 'DELETE')
            input(type: 'hidden', name: 'item_id', value: item_id)
            input(type: 'submit', value: 'Unbook item', class: 'btn btn-info')
          end
        end

        def item_broken(item_id)
          html.form(action: routes.item_issue_path, method: 'POST') do
            input(type: 'hidden', name: 'item_id', value: item_id)
            input(type: 'submit', value: 'Item broken', class: 'btn btn-danger')
          end
        end
      end
    end
  end
end
