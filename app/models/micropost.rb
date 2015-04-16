# this is automatically generated with the following command:
# $ rails generate model Micropost content:text user:references
class Micropost < ActiveRecord::Base
  belongs_to :user
  # added from listing 11.16
  default_scope -> { order(created_at: :desc) }
  # added from listing 11.56
  # mount_uploader is a method which takes as argument a symbol
  # representing attribute, class name of the generated uploader
  mount_uploader :picture, PictureUploader
  # added from listing 11.4 to validate the presence of a user_id
  validates :user_id, presence: true
  # added from listing 11.7
  validates :content, presence:true, length: { maximum: 140 }
  # added from listing 11.61, note that validate vs validates, which is a
  # predefined method; here validate is a custom validation. This custom
  # validation arranges to call the method corresponding to the given
  # symbol
  validate :picture_size
  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "must be under 5 mb.")
      end
    end
end
