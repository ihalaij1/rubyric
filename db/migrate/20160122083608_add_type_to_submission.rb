class AddTypeToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :type, :string
    add_column :submissions, :aplus_feedback_url, :string
    Submission.update_all(:type => 'Submission')
  end
end
