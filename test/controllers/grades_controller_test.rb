require 'test_helper'

class GradesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

=begin
  test "index" do
    #@user = User.new(user_params)
    @course = Course.new
    @user = User.new
    if @course.save||@user.save
      assert_nil( User)
      assert_nil( Course )
    else
      assert_not_nil( User)
      assert_not_nil( Course)
    end
   end
=end

  test "grade update?" do

    grade=Grade.new
    assert grade.save
    #assert_redirected_to grades_path
   end
end
