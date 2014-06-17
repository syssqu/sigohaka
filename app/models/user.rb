# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  module Roles
    ADMIN = "admin"
    MANAGER = "register"
    GENERAL = "lyrics_viewer"
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
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    confirmation: true,
                    length: { maximum: 90 },
                    format:   { with: VALID_EMAIL_REGEX },
                    uniqueness: false

end
