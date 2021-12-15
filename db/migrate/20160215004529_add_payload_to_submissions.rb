class AddPayloadToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :payload, :text
    add_column :exercises, :submission_type, :string
    
    Exercise.update_all(submission_type: 'file')
  end
end
