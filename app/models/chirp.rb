# == Schema Information
#
# Table name: chirps
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Chirp < ApplicationRecord 
  validates :body, presence: true 
  # validates :author_id, presence: true 
  #don't validate the presence of a foreign key if you have a belongs_to
  
  validate :body_too_long #runs custom validation: use the method name 

  def body_too_long 
    if body && body.length > 140 
      errors[:body] << 'TOO LONG!' #gives us an array 
    end
  end 

  belongs_to :author, #naming the association  bananable, but be semantic 
    primary_key: :id, #this is always the case 
    foreign_key: :author_id, #column_name from my own table 
    class_name: :User #the model it's associated with 
  #auto validates presence of foreign key 

  # belongs_to(:author, {primary_key: :id, foreign_key: :author_id, class_name: :User})

  has_many :likes, 
    primary_key: :id, 
    foreign_key: :chirp_id, 
    class_name: :Like 

  has_many :likers, #name we choose 
    through: :likes,
    source: :liker #this is association in the Like model

  #ALL has_many :throughs must be below any associations that they use 
end 
