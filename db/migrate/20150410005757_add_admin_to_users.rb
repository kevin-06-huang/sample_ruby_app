# this migration is generated with the following command:
# $ rails generate migration add_admin_to_users admin:boolean
class AddAdminToUsers < ActiveRecord::Migration
  def change
    # we then added the default: false part manually from listing 9.50;
    # this set the default value for admin to be false, whereas before the
    # default value is nil. This is not strictly necessary, as nil also
    # evaluate to be false in ruby, but it is good practice and also
    # communicate our intents better
    add_column :users, :admin, :boolean, default: false
  end
  # note that after this migration is carried out rails will automatically
  # add the question mark method admin? for checking whether a user is
  # an admin or not
end
