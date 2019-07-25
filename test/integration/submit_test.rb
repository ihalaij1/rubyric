require 'test_helper'

class SubmitTest < ActionDispatch::IntegrationTest
  fixtures :all

#   test "Submit" do
#     exercise_id = exercises(:solo_exercise).id
#
#     # Login as student1
#     get_via_redirect submit_url(exercise_id)
#     assert_equal new_session_path, path
#     post_via_redirect session_path, :studentnumber => '00001', :password => 'student1'
#
#     # Submit
#     assert_equal submit_path(exercise_id), path
#
#
#
#   end
#
#
#   test "Submit group exercise" do
#     exercise_id = exercises(:group_exercise).id
#
#     # Login as student1
#     get_via_redirect submit_url(exercise_id)
#     assert_equal new_session_path, path
#     post_via_redirect session_path, :studentnumber => '00001', :password => 'student1'
#
#     # Create group
#     assert_equal new_group_path(:exercise => exercise_id), path
#     post_via_redirect groups_path, {:group => {:exercise_id => exercise_id}, :exercise => exercise_id, 'studentnumber[0]' => '00001', 'studentnumber[1]' => '00002', 'email[0]' => 'student1@example.com', 'email[1]' => 'student2@example.com'}
#
#     # Submit
#     assert_equal submit_path(exercise_id), path
#
#     # Logout
#
#     # Login as student2
#
#     # Submit
#
#
#   end

  def setup
    @instance = course_instances(:lti_instance)
    @exercise = exercises(:lti_exercise)
    @student1 = users(:lti_student1)
    @student2 = users(:lti_student2)
    @student3 = users(:lti_student3)
  end

  test "should be able to submit through A+" do
    group1 = [{'user'=> @student1.lti_user_id, 'email'=> @student1.email, 'name'=> 'Student 1'},
              {'user'=> @student3.lti_user_id, 'email'=> @student3.email, 'name'=> 'Student 3'}].to_json
    group2 = [{'user'=> @student1.lti_user_id, 'email'=> @student1.email, 'name'=> 'Student 1'},
              {'user'=> @student2.lti_user_id, 'email'=> @student2.email, 'name'=> 'Student 2'}].to_json

    assert_no_difference 'Group.count',          "If group already exist, should not create a new group" do
      assert_difference 'Submission.count', 1,   "Should be able to submit" do
        post "/aplus/#{@exercise.id}", params: { exercise:             @exercise,              resource_link_id: @exercise.lti_resource_link_id,
                                                 oauth_consumer_key:   @instance.lti_consumer, context_id:       @instance.lti_context_id,
                                                 custom_group_members: group1,                 user_id:          @student1.lti_user_id }
      end
    end
    assert_equal [@student1.id, @student3.id].sort, Submission.last.group.group_members.map{|m| m.user_id}.sort,  "Group should have right members"
    assert_equal @exercise, Submission.last.exercise,                                                   "Submission should be in right exercise"

    assert_difference 'Group.count', 1,          "If group does not exist should create a new one" do
      assert_difference 'Submission.count', 1,   "Should be able to submit" do
        post "/aplus/#{@exercise.id}", params: { exercise:             @exercise,              resource_link_id: @exercise.lti_resource_link_id,
                                                 oauth_consumer_key:   @instance.lti_consumer, context_id:       @instance.lti_context_id,
                                                 custom_group_members: group2,                 user_id:          @student1.lti_user_id }
      end
    end
    assert_equal [@student1.id, @student2.id].sort, Submission.last.group.group_members.map{|m| m.user_id}.sort,  "Group should have right members"
    assert_equal @exercise, Submission.last.exercise,                                                   "Submission should be in right exercise"
    assert_equal [@student1.id, @student2.id].sort, Group.last.group_members.map{|m| m.user_id}.sort,             "Group should have right members"
  end

end
