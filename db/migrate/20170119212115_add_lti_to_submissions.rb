class AddLtiToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :lti_launch_params, :text
    add_column :reviews, :lti_launch_params, :text
  end
end
