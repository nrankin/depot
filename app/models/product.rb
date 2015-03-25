class Product < ActiveRecord::Base
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true
  validates_length_of :title, minimum: 10, message: "come on, that's too short - 10 characters or more please"
  validates :price, numericality: {greater_than_or_equal_to: 0.01}

  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|jpg|png)\Z}i,
      message: 'must be a URL for a GIF, JPG, or PNG image.'
  }
end
