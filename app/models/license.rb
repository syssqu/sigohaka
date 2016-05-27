class License < ActiveRecord::Base
  belongs_to :user

  validates :code, presence: true, length: { maximum: 20}
end
