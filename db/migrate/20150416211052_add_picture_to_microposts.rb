# this migration is added with the following command:
# rails generate migration add_picture_to_microposts picture:string
class AddPictureToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :picture, :string
  end
end
