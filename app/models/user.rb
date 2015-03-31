# this is generated with the following command
# $ rails generate model User name:string email:string
class User < ActiveRecord::Base
  # we pust this line in at listing 6.31, ensures email uniqueness before
  # save (again?)
  before_save { self.email = email.downcase }
  # this line is put in in section 6.8 to validates for the presence
  # of a name
  
  # this allow user.valid? to be used, and also, to look at the full
  # error message, use user.errors.full_messages
  
# validates :name, presence: true
  # this is the same as validates(:name, presence: true)
# validates :email, presence: true
  # these lines are added in listing 6.16 to validate the length of name
  # and email attribute, to replace the previous two lines
  validates :name, presence: true, length: { maximum: 50 }
  # added from listing 6.21 to validate the format of an email address
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # last line also checks for uniqueness of the email entry in database
  validates :email, presence: true, length: { maximum: 255 },
                                    format: { with: VALID_EMAIL_REGEX },
                                    uniqueness: { case_sensitive: false }
                                  # uniqueness: true
  # last line alters it so that case-insensitive uniqueness is enforced
  
  # listing 6.28: we added a migration to the model and typed this in:
  # $ rails generate migration add_index_to_users_email
  # this uses a rails method add_index to add an index to the email
  # column of the users table
  # we then execute a migration with the following command:
  # $ bundle exec rake db:migrate
  # the index also prevents a full-table scan (very costly) when finding
  # users by email address
  
  # as per 6.3.1, this line is added to enable password functionality
  # the only requirement for has_secure_password, a predefined rails
  # method, to work, is the addition of an attribute called
  # password_digest to the corresponding User model; to add that we
  # use the following line:
  # rails generate migration add_password_digest_to_users
  # password_digest:string
  has_secure_password
  
  # and finally, checking for length of the password, per listing 6.39
  validates :password, length: { minimum: 6 }
end
