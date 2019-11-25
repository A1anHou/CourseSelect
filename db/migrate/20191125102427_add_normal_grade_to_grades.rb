class AddNormalGradeToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :normal_grade, :integer
  end
end
