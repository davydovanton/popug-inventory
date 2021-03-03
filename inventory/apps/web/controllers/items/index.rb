module Web
  module Controllers
    module Items
      class Index
        include Web::Action
        include Import[items: 'repositories.item']

        expose :items, :my_items

        def call(params)
          @my_items = items.booked_for_account(current_account.id)
          @items = items.all_for_account(current_account.id)
        end
      end
    end
  end
end
