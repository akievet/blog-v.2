class Post < ActiveRecord::Base
  has_many :users
  has_many :tags
  has_many :comments
  has_many :images

  def author
    user= User.find(self.user_id)
    first= user.first_name
    last= user.last_name
    "#{first} #{last}"
  end

  def tags_to_s
    tag_a= self.tags.map {|tag| tag.word}
    tag_a.join(", ")
  end
end