require 'test_helper'

class ReviewsControlllerTest < ActionDispatch::IntegrationTest
  
  fixtures :all
  
  def setup
    @review1 = reviews(:review)          # review done by assistant1 for group1
    @review2 = reviews(:second_review)   # review done by teacher1 for group1
    @review3 = reviews(:third_review)    # review done by teacher1 for group2
    @review4 = reviews(:fourth_review)   # review done by teacher1 for group3 in another course instance
    @review5 = reviews(:fifth_review)    # review done by teacher1 for group2 at 
                                         # exercise which allows reviewers to see all submissions
  end

  context "when logged in as a teacher of the course" do
    setup do
      post session_path, params: { session: { email: 'teacher1@example.com', password: 'teacher1'} }
    end

    should "be able to view review" do
      get review_path(@review1)
      assert_response :success
      get review_path(@review2)
      assert_response :success
    end

    should "be able to access edit review" do
      get edit_review_path(@review1)
      assert_response :success
      get edit_review_path(@review2)
      assert_response :success
    end

    should "be able to update review" do
      # Update own review
      patch review_path(@review2), params: { review: { grade:    "4",
                                                       feedback: "Great!" } }
      assert_equal_attributes Review.find(@review2.id), { grade: "4", feedback: "Great!" }
      # Update someone else's review
      patch review_path(@review1), params: { review: { grade:    "3",
                                                       feedback: "Good work!" } }
      assert_equal_attributes Review.find(@review1.id), { grade: "3", feedback: "Good work!" }
    end

    should "be able to invalidate review through update" do
      # Invalidate own review
      patch review_path(@review2), params: { review: { status: "invalidated" } }
      assert_equal_attributes Review.find(@review2.id), { status: "invalidated" }
      # Invalidate someone else's review
      patch review_path(@review1), params: { review: { status: "invalidated" } }
      assert_equal_attributes Review.find(@review1.id), { status: "invalidated" }
    end

    should "be able to invalidate review" do
      # Invalidate own review
      get invalidate_review_path(@review2)
      assert_equal_attributes Review.find(@review2.id), { status: "invalidated" }
      # Invalidate someone else's review
      get invalidate_review_path(@review1)
      assert_equal_attributes Review.find(@review1.id), { status: "invalidated" }
    end
  end
  
  context "when logged in as a assistant" do
    setup do
      post session_path, params: { session: { email: 'assistant1@example.com', password: 'assistant1'} }
    end

    should "be able to view own review" do
      get review_path(@review1)
      assert_response :success
    end
    
    should "be able to view someone else's review if exercise allows reviwers to see all submissions" do
      get review_path(@review5)
      assert_response :success
    end

    should "not be able to view someone else's review" do
      get review_path(@review2)
      assert_forbidden
      get review_path(@review3)
      assert_forbidden
      get review_path(@review4)
      assert_forbidden
    end

    should "be able to access edit review for group they are reviewer of" do
      get edit_review_path(@review1)
      assert_response :success
    end

    should "not be able to access edit review for group they are not reviewer of" do
      get edit_review_path(@review3)
      assert_forbidden
    end

    should "not be able to access edit review done by somebody else" do
      get edit_review_path(@review2)
      assert_forbidden
      get edit_review_path(@review5)
      assert_forbidden
    end

    should "be able to update own review" do
      patch review_path(@review1), params: { review: { grade:    "1",
                                                       feedback: "Terrible!" } }
      assert_equal_attributes Review.find(@review1.id), { grade: "1", feedback: "Terrible!" }
    end

    should "not be able to update someone else's review" do
      review_grade = @review2.grade
      review_feedback = @review2.feedback
      patch review_path(@review2), params: { review: { grade:    "1",
                                                       feedback: "Terrible!" } }
      assert_equal_attributes Review.find(@review2.id), { grade: review_grade, feedback: review_feedback }
      
      review_grade2 = @review5.grade
      review_feedback2 = @review5.feedback
      patch review_path(@review5), params: { review: { grade:    "1",
                                                       feedback: "Terrible!" } }
      assert_equal_attributes Review.find(@review5.id), { grade: review_grade2, feedback: review_feedback2 }
    end

    should "be able to invalidate review through update" do
      # Invalidate own review
      patch review_path(@review1), params: { review: { status: "invalidated" } }
      assert_equal Review.find(@review1.id).status, "invalidated"
    end

    should "be able to invalidate own review" do
      # Invalidate own review
      get invalidate_review_path(@review1)
      assert_equal Review.find(@review1.id).status, "invalidated"
    end

    should "not be able to invalidate someone else's review" do
      # Invalidate someone else's review
      get invalidate_review_path(@review2)
      assert_not_equal Review.find(@review2.id).status, "invalidated"
      get invalidate_review_path(@review5)
      assert_not_equal Review.find(@review5.id).status, "invalidated"
    end
    
  end

  context "when logged in as a student" do
    setup do
      post session_path, params: { session: { email: 'student1@example.com', password: 'student1'} }
    end

    should "be able to view review of own submission" do
      get review_path(@review1)
      assert_response :success
    end

    should "not be able to view review of someone else's submission" do
      get review_path(@review3)
      assert_forbidden
    end

    should "not be able to access edit review" do
      get edit_review_path(@review1)
      assert_forbidden
      get edit_review_path(@review2)
      assert_forbidden
    end

    should "not be able to update review" do
      review_grade = @review1.grade
      review_feedback = @review1.feedback
      patch review_path(@review1), params: { review: { grade:    "5",
                                                       feedback: "Awesome!" } }
      assert_equal_attributes Review.find(@review1.id), { grade: review_grade, feedback: review_feedback }
    end

    should "not be able to invalidate review through update" do
      patch review_path(@review1), params: { review: { status: "invalidated" } }
      assert_not_equal Review.find(@review1.id).status, "invalidated"
    end

    should "not be able to invalidate review" do
      # Invalidate own review
      get invalidate_review_path(@review1)
      assert_not_equal Review.find(@review1.id).status, "invalidated"
      # Invalidate someone else's review
      get invalidate_review_path(@review3)
      assert_not_equal Review.find(@review3.id).status, "invalidated"
    end
    
  end

end
