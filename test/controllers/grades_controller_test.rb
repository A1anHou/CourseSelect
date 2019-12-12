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
    params={
        :grade => {
            :grade => 3,
            :normal_grade => 2
        },
    }
    grade.update_attributes!({:grade => params[:grade][:grade], :normal_grade => params[:grade][:normal_grade]})
    assert grade.save
   end
end
