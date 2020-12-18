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
#

#bundle exec annotate --models 
  #gives us a copy of the schema for the corresponding model 

#model names will be the singular version of the table name 
#no require_relative: RAILS does things for us 
#don't require things 

#ApplicationRecord gives us getters and setters for each column; we don't need to write them 

class User < ApplicationRecord 
  #validations give us nice and readable errors messages e.g. fake_ryan.errors.full_messages 
  validates :username, :email, presence: true, uniqueness: true 
  validates :age, :political_affiliation, presence: true 

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


  #ActiveRecord finder methods 




  #Write a query to look for all the users between the ages of 10-20


  #Find all the users not younger than the age of 11
  #HINT: where not


  #Find all the instructors from a list and order by ascending
end 
