class Tag < ActiveRecord::Base
  has_many(:tag_instances)
  has_many(:posts, :through => :tag_instances)
end