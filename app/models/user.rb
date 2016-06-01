# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :update_target
  attr_accessor :current_password

  module Roles
    ADMIN = "admin"
    MANAGER = "manager"
    REGULAR = "regular"
  end

  before_save do
    if self.role.nil?
      self.role = "regular"
    end
  end
  belongs_to :section
  belongs_to :katagaki

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

  has_many :qualification_allowances
  has_many :summary_attendances

  has_many :time_lines
  has_many :kintai_headers

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


  validates :current_password, presence: true, on: :update, if: "self.update_target == 'password'"
  validate :authenticate, if: "self.update_target == 'password'"

  def authenticate
    return if self.current_password.blank?

    user = User.find_for_authentication(id: self.id)
    unless user.valid_password?(self.current_password)
      errors.add(:current_password, 'が不正です。')
    end
  end

  validates :password, presence: true, on: :update, if: "self.update_target == 'password'"

  # allow users to update their accounts without passwords
  def update_without_current_password(params, *options)

    if params[:current_password].blank?
      params.delete(:current_password)
    end

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def view_name
    self.family_name + " " + self.first_name
  end

  def get_summary_attendances(nendo, gatudo, section_id)

    sql = "
      select
          a.id
        , a.employee_no
        , a.family_name || a.first_name as name
        , (select count(pattern) from attendances where attendances.user_id = a.id and trim(pattern) is not null and year = :year and month = :month group by user_id) as kinmu
        , (select count(byouketu) from attendances where attendances.user_id = a.id and year = :year and month = :month and byouketu is true group by user_id) as byouketu
        , (select count(kekkin) from attendances where attendances.user_id = a.id and year = :year and month = :month and kekkin is true group by user_id) as kekkin
        , (select count(hankekkin) from attendances where attendances.user_id = a.id and year = :year and month = :month and hankekkin is true group by user_id) as hankekkin
        , (select count(tikoku) from attendances where attendances.user_id = a.id and year = :year and month = :month and tikoku is true group by user_id) as tikoku
        , (select count(soutai) from attendances where attendances.user_id = a.id and year = :year and month = :month and soutai is true group by user_id) as soutai
        , (select count(gaisyutu) from attendances where attendances.user_id = a.id and year = :year and month = :month and gaisyutu is true group by user_id) as gaisyutu
        , (select count(tokkyuu) from attendances where attendances.user_id = a.id and year = :year and month = :month and tokkyuu is true group by user_id) as tokkyuu
        , (select count(furikyuu) from attendances where attendances.user_id = a.id and year = :year and month = :month and furikyuu is true group by user_id) as furikyuu
        , (select count(yuukyuu) from attendances where attendances.user_id = a.id and year = :year and month = :month and yuukyuu is true group by user_id) as yuukyuu
        , (select count(syuttyou) from attendances where attendances.user_id = a.id and year = :year and month = :month and syuttyou is true group by user_id) as syuttyou
        , (select count(hankyuu) from attendances where attendances.user_id = a.id and year = :year and month = :month and hankyuu is true group by user_id) as hankyuu
        , b.over_time + c.over_time as over_time
        , b.holiday_time + c.holiday_time as holiday_time
        , b.midnight_time + c.midnight_time as midnight_time
        , b.break_time + c.break_time as break_time
        , b.kouzyo_time + c.kouzyo_time as kouzyo_time
        , b.work_time + c.work_time as work_time
        , d.previous_m
        , d.present_m
        , d.vacation
        , d.half_holiday
        , d.note
      from
          users a
          left join
      	( select
                user_id
              , sum(over_time) as over_time
      		, sum(holiday_time) as holiday_time
      		, sum(midnight_time) as midnight_time
      		, sum(break_time) as break_time
      		, sum(kouzyo_time) as kouzyo_time
      		, sum(work_time) as work_time
            from
      	      attendances
            where
                year = :year
            and month = :month
            group by
      	      user_id
          ) b
      	on a.id = b.user_id

      	left join
          ( select
                user_id
              , sum(over_time) as over_time
      		, sum(holiday_time) as holiday_time
      		, sum(midnight_time) as midnight_time
      		, sum(break_time) as break_time
      		, sum(kouzyo_time) as kouzyo_time
      		, sum(work_time) as work_time
            from
      	      attendance_others
            where
                year = :year
            and month = :month
            group by
      	      user_id
          ) c
          on a.id = c.user_id

      	left join
          ( select
                user_id
              , previous_m
      		, present_m
      		, vacation
      		, half_holiday
      		, note
            from
      	      summary_attendances
            where
                year = :year
            and month = :month
          ) d
          on a.id = d.user_id
        "
    unless section_id.blank?
      sql += " where a.section_id = :section_id"
    end

    sql += " order by a.katagaki_id, a.employee_no"

    User.find_by_sql([sql, {year: nendo, month: gatudo, section_id: section_id}])
  end
end
