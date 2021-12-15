class AddPeerReviewTimingToExercises < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :peer_review_timing, :string
  end
end
