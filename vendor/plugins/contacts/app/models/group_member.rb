class GroupMember < ActiveRecord::Base
  unloadable
  belongs_to    :user
  belongs_to    :group
  
end
