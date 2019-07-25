class AddReviewersSeeAllSubmissionsToExercises < ActiveRecord::Migration[5.0]
  def change
    add_column :exercises, :reviewers_see_all_submissions, :boolean, default: false
  end
end
