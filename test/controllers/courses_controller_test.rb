require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:peng)
    get sessions_login_path
    post sessions_login_path(params: {session: {email: @user.email, password: 'password'}})

    @course=Course.create(id: 1, course_code: "091M4001H", name: "计算机体系结构", course_type: "专业核心课", credit: "60/3.0", limit_num: 2, course_week: "第2-20周", course_time: "周一(9-11)", class_room: "教1-107", teaching_type: "课堂讲授为主", exam_type: "闭卷笔试", exam_proportion: 60)
    @course.student_num=@course.limit_num
    @course.save
  end

  test 'select course' do
    s="选课失败: 限选#{@course.limit_num}/已选#{@course.student_num}"
    get "/courses/1/select"
    assert_redirected_to courses_url
    assert_match s, flash[:warning]
  end

end
