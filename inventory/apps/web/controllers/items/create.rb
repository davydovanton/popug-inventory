module Web
  module Controllers
    module Items
      class Create
        include Web::Action
        include Import[items: 'repositories.item']

        def call(params)
          item = items.create(
            title: params[:item][:title],
            description: params[:item][:description],
            public_id: SecureRandom.uuid,
            status: 'free'
          )

          # ----------------------------- produce event -----------------------
          event = {
            event_id: SecureRandom.uuid,
            event_version: 1,
            event_time: Time.now.to_s,
            producer: 'inventory_service',
            event_name: 'ItemsCreated',
            data: {
              public_id: item.public_id,
              title: item.title,
              description: item.description
            }
          }
          result = SchemaRegistry.validate_event(event, 'items.created', version: 1)

          if result.success?
            WaterDrop::SyncProducer.call(event.to_json, topic: 'items-stream')
          end
          # --------------------------------------------------------------------

          redirect_to routes.root_path
        end
      end
    end
  end
end
