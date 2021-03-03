Hanami::Model.migration do
  change do
    create_enum(:item_statuses_list, %w[new fixed broken])

    create_table :items do
      primary_key :id

      column :owner_public_id, String

      column :public_id,       String, null: false
      column :title,           String, null: false

      column :break_count, Integer, null: false, default: 0

      column :status, 'item_statuses_list', null: false

      column :meta, :jsonb, default: '{}'

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
