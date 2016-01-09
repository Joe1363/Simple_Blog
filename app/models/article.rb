class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  def self.search(search)
    where("author || title ILIKE ?", "%#{search}%")
  end
end
