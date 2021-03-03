# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :accounts do
      primary_key :id

      column :public_id,  String
      column :full_name,  String
      column :email,      String
      column :role,       String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
