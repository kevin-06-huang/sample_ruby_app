# this is generated with the rails generate model command, check out
# micropost.rb
class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :microposts, :users
    # this is added in listing 11.1; the reason is to add an index so
    # that these can be arranged, and to turn this into a multi-key
    # association
    add_index :microposts, [:user_id, :created_at]
  end
end
