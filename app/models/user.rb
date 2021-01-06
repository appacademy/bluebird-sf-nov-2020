# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  email                 :string           not null
#  username              :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  political_affiliation :string           not null
#  age                   :integer          not null
#  password_digest       :string           not null
#  session_token         :string           not null
#

#bundle exec annotate --models 
  #gives us a copy of the schema for the corresponding model 

#model names will be the singular version of the table name 
#no require_relative: RAILS does things for us 
#don't require things 

#ApplicationRecord gives us getters and setters for each column; we don't need to write them 

class User < ApplicationRecord 
  #validations give us nice and readable errors messages e.g. fake_ryan.errors.full_messages 
  validates :email, :session_token, presence: true, uniqueness: true 
  validates :age, :political_affiliation, :password_digest, presence: true 
  validates :password, length: { minimum: 6 }, allow_nil: true 
  validates :username, uniqueness: true, presence: true
  #not a column in the db 
  #length check for when we sign up a user
  #other times, allow pw to be nil 

  after_initialize :ensure_session_token 
  #rails method(e.g. after User.new)     runs this method 
  #before_validation will also work 

  attr_reader :password #a reader is not provided, we have to make it 

  def self.find_by_credentials(username, pw)
    user = User.find_by(username: username)

    if user && user.is_password?(pw) #helper method we will write 
      user 
      #if the username is found and passwords match
    else 
      nil
    end
  end

  def is_password?(pw) #not recursion 
    BCrypt::Password.new(self.password_digest).is_password?(pw)
    #create a new instance using digest from db  this is_pw? is BCrypt's method 
    #returns a boolean
  end

  def password=(password) #we are overwriting the setter
    # debugger
    self.password_digest = BCrypt::Password.create(password)
    #column in db          result of bcrypt hash with salt 
    #we use the user's input password once to create the password_digest

    @password = password 
    #creating the instance varialbe when we sign up the user 
    #this is for the validation/length 
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64 
    #assigns it             random string generated 
  end

  def reset_session_token! 
    self.session_token = SecureRandom::urlsafe_base64 
    # we want to change the session_token 
    self.save! #we want to fail LOUDLY

    self.session_token #we want to return this value via the getter method 
  end

  has_many :chirps, #pick good names 
    primary_key: :id, 
    foreign_key: :author_id, #from the other class 
    class_name: 'Chirp' #symbol or string 

  has_many :likes, 
    primary_key: :id, 
    foreign_key: :liker_id,
    class_name: :Like 

  has_many :liked_chirps, #find liked chirps 
    through: :likes, 
    source: :chirp 
  #through and source go through associations 


  #ActiveRecord finder methods allows you  to find one instance of things.  Returns first record that it  finds
  # User.first 
  # User.last
  # User.find(5) #User.find(<id>) takes in a id key as an argument and will raise error message if not found
  # User.find_by(username: "charlos_gets_buckets") #User.find_by(key(column): <value>) and returns nil if not found

  # # all data return will be a ruby object if it is found

  # #Write a query to look for all the users between the ages of 10-20
  # User.where("age >= 10 AND age <= 20")
  # User.where("age >= (?) AND  age <= (?)",10,20)
  # User.where(age: 10..20)
  # User.where(age: 10...21)

  # #Find all the users not younger than the age of 11
  # #HINT: where not
  # User.where.not("age < 11")

  # #Find all the instructors from a list and order by ascending
  # instructors = ["hawaiian_shirts_ftw","will_climb_rocks","give_me_wine"]
  # User.where(username: instructors)
  # User.where("username in (?)",instructors)
  
end 
