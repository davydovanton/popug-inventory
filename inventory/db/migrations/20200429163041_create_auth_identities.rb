# frozen_string_literal: true

Hanami::Model.migration do
  change do
    extension :pg_enum

    create_enum(:auth_identity_providers, %w[auth])

    create_table :auth_identities do
      primary_key :id
      foreign_key :account_id, :accounts, on_delete: :cascade

      column :uid,                 String
      column :provider,            String, null: false
      column :login,               String, null: false
      column :token,               String
      column :password_hash,       String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
