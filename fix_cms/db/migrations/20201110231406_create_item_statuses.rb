Hanami::Model.migration do
  change do
    create_table :item_fixes do
      primary_key :id

      foreign_key :account_id, :accounts, on_delete: :cascade
      foreign_key :item_id, :items, on_delete: :cascade

      column :status, String, null: false

      column :comment, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
