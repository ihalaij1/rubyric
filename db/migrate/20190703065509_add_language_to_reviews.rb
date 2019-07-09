class AddLanguageToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :language, :string
  end
end
