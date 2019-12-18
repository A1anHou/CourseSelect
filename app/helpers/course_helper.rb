module CourseHelper
  def switch_week(week)
    case week
    when "周一"
      return 0
    when "周二"
      return 1
    when "周三"
      return 2
    when "周四"
      return 3
    when "周五"
      return 4
    when "周六"
      return 5
    when "周日"
      return 6
    when "周天"
      return 6
    else
      return -1
    end
  end

  def delete_chinese(str)
    return str.gsub(/[\u4e00-\u9fa5]/, '')
  end

  def get_course_time(course_time)
    return delete_chinese(course_time).delete('()').split('-')
  end

  def get_course_week(course_week)
    course_week = delete_chinese(course_week)
    str_array = course_week.split(',')
    result = Array.new(20, 0)
    str_array.each do |a|
      a_temp = a.split('-')
      for i in (a_temp[0].to_i-1)...a_temp[1].to_i
        result[i] = 1
      end
    end
    #return delete_chinese(course_week).split('-')
    return result
  end

  def get_weekday(course_time)
    return switch_week(course_time.split('(')[0]).to_i
  end

  def if_conflict(course, courses)
    if course.student_num >= course.limit_num
      return "选课失败: 限选#{course.limit_num}/已选#{course.student_num}"
    else
      current_course_weekday=get_weekday(course.course_time)
      flag=0
      courses.each do |c|
        course_weekday=get_weekday(c.course_time)
        #如果周几相同
        if course_weekday.to_i==current_course_weekday.to_i
          current_course_time=get_course_time(course.course_time)
          course_time=get_course_time(c.course_time)
          #如果节数冲突
          if current_course_time[0].to_i<=course_time[1].to_i and current_course_time[1].to_i>=course_time[0].to_i
            course_week=get_course_week(c.course_week)
            current_course_week=get_course_week(course.course_week)
            #如果周数冲突
            for i in 0...20
              if current_course_week[i] == 1 and course_week[i] == 1
                flag=1
                return "选课失败: 课程时间冲突，冲突课程：#{c.name}"
                break
              end
            end
          end
        end
      end
      if flag==0
        return 1
      end
    end
  end

  def sum_credit(courses)
    sum = 0
    courses.each do |c|
      sum += c.credit.split('/')[1].to_i
    end
    return sum
  end

end