# this is automatically generated with the following command:
# $ rails generate model Micropost content:text user:references
class Micropost < ActiveRecord::Base
  belongs_to :user
  # added from listing 11.16
  default_scope -> { order(created_at: :desc) }
  # added from listing 11.4 to validate the presence of a user_id
  validates :user_id, presence: true
  # added from listing 11.7
  validates :content, presence:true, length: { maximum: 140 }
end
