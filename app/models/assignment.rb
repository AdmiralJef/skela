class Assignment < ActiveRecord::Base
  include Resourceful

  belongs_to :course
end
