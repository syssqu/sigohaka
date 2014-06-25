# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  module Roles
    ADMIN = "admin"
    MANAGER = "manager"
    REGULAR = "regular"
  end

  belongs_to :section
  
  has_many :projects
  has_many :licenses
  has_many :kinmu_patterns
  has_many :attendances
  has_many :attendance_others
  has_many :transportation_expresses
  has_many :vacation_requests

  has_many :commutes
  has_many :reasons

  has_many :business_reports
  has_many :housing_allowances


  validates :family_name, presence: true, length: { maximum: 20}
  validates :first_name, presence: true, length: { maximum: 20}
  validates :kana_family_name,  presence: true, length: { maximum: 20 }
  validates :kana_first_name, presence: true, length: { maximum: 20 }

  validates :section_id,  presence: true
  
  validates :gender,  presence: true
  # validates :birth_year, presence: true
  # validates :birth_month, presence: true
  # validates :birth_day, presence: true
  # validates :birth_day, presence: true

  # メールアドレス
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true,
  #                   confirmation: false,
  #                   length: { maximum: 90 },
  #                   format:   { with: VALID_EMAIL_REGEX },
  #                   uniqueness: true

  # allow users to update their accounts without passwords
  def update_without_current_password(params, *options)
    params.delete(:current_password)
 
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
 
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

end
