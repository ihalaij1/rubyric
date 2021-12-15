class AddPeerReviewToExercises < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :peer_review_goal, :integer
    add_column :exercises, :collaborative_mode, :string, :nil => false, :default => ''
  end
end
