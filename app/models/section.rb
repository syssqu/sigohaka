class Section < ActiveRecord::Base
  has_many :users
  validates :code, presence: true
end
