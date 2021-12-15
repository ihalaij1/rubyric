class CreateReviewRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :review_ratings do |t|
      t.references :review
      t.references :user
      t.integer :rating, null: false, limit: 1

      t.timestamps
    end
    add_index :review_ratings, [:review_id, :user_id], unique: true
  end
end
