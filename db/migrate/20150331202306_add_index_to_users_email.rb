# this migration is generated with the following:
# $ rails generate migration add_index_to_users_email
class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    # added from listing 6.28 to enforce uniqueness at database level
    # the index doesnt enforce the uniqueness of the email address
    # at the database level, but by enforcing the uniqueness of index
    # we can ensure, along with the uniqueness enforced at activemodel
    # level that emails when stored and persisted in database are unique
    add_index :users, :email, unique: true
  end
end
