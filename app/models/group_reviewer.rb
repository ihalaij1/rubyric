# Join model that assigns a reviewer (user) to a group
class GroupReviewer < ApplicationRecord
  belongs_to :group
  belongs_to :user
end
