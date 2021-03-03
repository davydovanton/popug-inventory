module Web
  module Controllers
    module BookItems
      class Destroy
        include Web::Action
        include Import[items: 'repositories.item']

        def call(params)
          item = items.unbook(params[:item_id].to_i, current_account.id)

          # ----------------------------- produce event -----------------------
          event = {
            event_id: SecureRandom.uuid,
            event_version: 1,
            event_time: Time.now.to_s,
            producer: 'inventory_service',
            event_name: 'ItemsStatusChanged',
            data: {
              public_id: item.public_id,
              status: 'unlocked',
              actor_public_id: current_account.public_id
            }
          }
          result = SchemaRegistry.validate_event(event, 'items.status_changed', version: 1)

          if result.success?
            WaterDrop::SyncProducer.call(event.to_json, topic: 'item-statuses')
          end
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
