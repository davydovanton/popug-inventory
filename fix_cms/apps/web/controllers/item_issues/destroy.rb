module Web
  module Controllers
    module ItemIssues
      class Destroy
        include Web::Action
        include Import[items: 'repositories.item']

        def call(params)
          item = items.fix(params[:item_id].to_i, current_account.id)

          # ----------------------------- produce event -----------------------
          event = {
            event_id: SecureRandom.uuid,
            event_version: 1,
            event_time: Time.now.to_s,
            producer: 'fix_cms_service',
            event_name: 'ItemsFixed',
            data: {
              public_id: item.public_id,
              repairman_public_id: current_account.public_id
            }
          }
          result = SchemaRegistry.validate_event(event, 'items.fixed', version: 1)

          if result.success?
            WaterDrop::SyncProducer.call(event.to_json, topic: 'fixed-items')
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
