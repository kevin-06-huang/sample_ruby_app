# this migration is generated with the following code:
# $ rails generate migration add_activation_to_users
# activation_digest:string activated:boolean activated_at:datetime

class AddActivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_digest, :string
    # we added the default false manually, again because we want to set the
    # default value for activated to be false
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
  end
end
