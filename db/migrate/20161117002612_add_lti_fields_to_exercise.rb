class AddLtiFieldsToExercise < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :lti_resource_link_id_review, :string
    add_column :exercises, :lti_resource_link_id_feedback, :string
  end
end
