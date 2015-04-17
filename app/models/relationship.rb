# this model is generated with the following command:
# $ rails generate model Relationship follower_id:integer followed_id:integer
class Relationship < ActiveRecord::Base
  # listing 12.3; note the existence of two virtual attribute
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # listing 12.5; validation for presence
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
