class AddExamProportionToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :exam_proportion, :integer
  end
end
