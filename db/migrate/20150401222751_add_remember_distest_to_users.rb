# this is added in section 8.4.1; the migration is generated as followed:
# $ rails generate migration add_remember_digest_to_users remember_digest:string
class AddRememberDistestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_digest, :string
  end
end