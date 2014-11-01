class Post < ActiveRecord::Base
  has_many :users
  has_many :tag_instances
  has_many(:tags, :through => :tag_instances)
  has_many :comments
  has_many :images

  def author
    user= User.find(self.user_id)
    first= user.first_name
    last= user.last_name
    "#{first} #{last}"
  end

end