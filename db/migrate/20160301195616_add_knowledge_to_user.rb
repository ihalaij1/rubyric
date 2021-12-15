class AddKnowledgeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :knowledge, :text
  end
end
