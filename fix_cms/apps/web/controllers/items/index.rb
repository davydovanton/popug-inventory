module Web
  module Controllers
    module Items
      class Index
        include Web::Action
        include Import[items: 'repositories.item']

        expose :items

        def call(params)
          @items = items.all_for_fix
        end
      end
    end
  end
end
