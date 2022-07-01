class User < ApplicationRecord
  has_many :quote
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         def admin? 
          self.is_admin == true
        end
end
