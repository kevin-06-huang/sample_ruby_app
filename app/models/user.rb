# this is generated with the following command
# $ rails generate model User name:string email:string
class User < ActiveRecord::Base
  # added in 8.4.1 from listing 8.32, this line simply instantiate and set
  # the remember_token to be accessible from outside the class
  attr_accessor :remember_token
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
  
  # also, allow_blank: true is added in listing 9.10, to allow for a blank
  # password field when user is editing information and doesn't want to
  # change his password. has_secure_password automatically enforces
  # the presence of a password when a new account is created so no empty
  # password will be allowed in the user signup process
  validates :password, length: { minimum: 6 }, allow_blank: true
  
  # this is a class method for computing the password_digest from bcrypt
  # there are several places where this method can be placed, but since
  # later on we'll be reusing this method in the user model, this suggest
  # that we place the method here in User model, and since we won't
  # necessarily have access to a user object when we're using this method
  # we have to make it a class method
  # added from listing 8.18, returns the hash digest of the given string
  # and set the cost to be low for testing but normal for production
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  # added in 8.4.1 from listing 8.31, we simply added a method for making
  # tokens for use in remember_digest. similar to the digest method above,
  # because we would like to use the method without a user object, we make
  # this a class method as well
  # returns a random token
  def User.new_token
    # this is a method from the SecureRandom module in the Ruby standard
    # library that returns a random string of length 22 composed of the
    # characters A-Z, a-z, 0-9, and "-" and "_"
    SecureRandom.urlsafe_base64
  end
  # remembers a user in the database for use in persistent sessions
  def remember
    # the self is there to ensure assignment sets the user's remember_token
    # as its instance variable, instead of creating a local variable called
    # remember_token
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    
  end
  # from 8.4.2, listing 8.33; this is simply a method similar to the
  # authenticate method in bcrypt, which compare the password_digest in
  # database and as generated to authenticate user
  # returns true if the given token 
  def authenticated?(remember_token)
    #listing 8.45, updating authenticated? to handle a nil remember digest
    return false if remember_digest.nil?
    
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  # added in 8.4.3, from listing 8.38, this undo the remember method so
  # user can be forgotten and therefore logout; specifically it sets the
  # password_digest value to nil
  def forget
    update_attribute(:remember_digest, nil)
  end
end
