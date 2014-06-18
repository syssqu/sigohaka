class Attendance < ActiveRecord::Base
  belongs_to :user

  attr_accessor :nen_gatudo
end
