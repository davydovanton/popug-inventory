module Web
  module Controllers
    module ItemIssues
      class Create
        include Web::Action
        include Import[items: 'repositories.item']

        def call(params)
          item = items.broken(params[:item_id].to_i, current_account.id)

          # ----------------------------- produce event -----------------------
          event = {
            event_name: 'ItemsBroken',
            data: {
              public_id: item.public_id,
              requester_public_id: current_account.public_id
            }
          }

          WaterDrop::SyncProducer.call(event.to_json, topic: 'broken-items')
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
