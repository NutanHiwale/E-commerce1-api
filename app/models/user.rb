# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :orders
  VALID_EMAIL_REGEX = /[A-Za-z0-9_.]*[@][a-z]+[.][a-z]+/
  validates :email, presence: { accept: true, message: "Email should be present" },
                    uniqueness: { accept: true, message: "Email should be unique" },
                    format: { with: VALID_EMAIL_REGEX }
  VALID_MOBILE_REGEX = /[0-9]{10}/
  validates :mobile_no, presence: true,
                        format: { with: VALID_MOBILE_REGEX }
  validates :pincode, presence: true
  validates :city, presence: true 
end
