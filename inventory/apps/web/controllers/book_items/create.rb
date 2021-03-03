module Web
  module Controllers
    module BookItems
      class Create
        include Web::Action
        include Import[items: 'repositories.item']

        def call(params)
          item = items.book(params[:item_id].to_i, current_account.id)

          # ----------------------------- produce event -----------------------
          event = {
            event_name: 'ItemsStatusChanged',
            data: {
              public_id: item.public_id,
              status: 'locked',
              actor_public_id: current_account.public_id
            }
          }
          WaterDrop::SyncProducer.call(event.to_json, topic: 'item-statuses')
          # --------------------------------------------------------------------

          redirect_to routes.root_path
        end

        private

        def verify_csrf_token?
          false
        end
      end
    end
  end
end
