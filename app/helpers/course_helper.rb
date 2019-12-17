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

end
