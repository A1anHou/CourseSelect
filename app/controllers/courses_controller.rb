class CoursesController < ApplicationController
  include CourseHelper

  before_action :student_logged_in, only: [:select, :quit, :list]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update, :open, :close]#add open by qiao
  before_action :logged_in, only: :index

  #-------------------------for teachers----------------------

  def new
    @course=Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses<<@course
      redirect_to courses_path, flash: {success: '新课程申请成功'}
    else
      flash[:warning] = '信息填写有误,请重试'
      render 'new'
    end
  end

  def edit
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash={:info => '更新成功'}
    else
      flash={:warning => '更新失败'}
    end
    redirect_to courses_path, flash: flash
  end

  def open
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end

  def close
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  #-------------------------for students----------------------

  def list
    #-------QiaoCode--------
    @courses = Course.where(:open=>true).paginate(page: params[:page], per_page: 4)
    @course = @courses-current_user.courses
    tmp=[]
    @course.each do |course|
      if course.open==true
        tmp<<course
      end
    end
    @course=tmp
  end

  def select
    @course=Course.find_by_id(params[:id])
    if @course.student_num >= @course.limit_num
      flash={:warning => "选课失败: 限选#{@course.limit_num}/已选#{@course.student_num}"}
    else
      # schedule = Array.new(7){ Array.new(11, 0)}
      current_course_weekday=get_weekday(@course.course_time)
      courses=current_user.courses
      flag=0
      courses.each do |c|
        course_weekday=get_weekday(c.course_time)
        #如果周几相同
        if course_weekday.to_i==current_course_weekday.to_i
          current_course_time=get_course_time(@course.course_time)
          course_time=get_course_time(c.course_time)
          #如果节数冲突
          if current_course_time[0].to_i<=course_time[1].to_i and current_course_time[1].to_i>=course_time[0].to_i
            course_week=get_course_week(c.course_week)
            current_course_week=get_course_week(@course.course_week)
            #如果周数冲突
            for i in 0...20
              if current_course_week[i] == 1 and course_week[i] == 1
                flag=1
                flash={:warning => "选课失败: 课程时间冲突，冲突课程#{c.name}"}
                break
              end
            end
          end
        end
      end
      if flag==0
        current_user.courses<<@course
        @course.update_attributes(:student_num => @course.student_num+1)
        flash={:success => "成功选择课程: #{@course.name}"}
      end
    end
    redirect_to courses_path, flash: flash
  end

  def quit
    @course=Course.find_by_id(params[:id])
    current_user.courses.delete(@course)
    @course.update_attributes(:student_num => @course.student_num-1)
    flash={:success => "成功退选课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end


  #-------------------------for both teachers and students----------------------

  def index
    @course=current_user.teaching_courses.paginate(page: params[:page], per_page: 4) if teacher_logged_in?
    if student_logged_in?
      @course=current_user.courses.paginate(page: params[:page], per_page: 4)
      @sum = 0
      courses = current_user.courses
      courses.each do |c|
        @sum+=c.credit.split('/')[1].to_i
      end
    end
  end


  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
                                   :credit, :limit_num, :class_room, :course_time, :course_week,
                                   :exam_proportion)
  end


end
