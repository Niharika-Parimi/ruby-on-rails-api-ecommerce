class AddCompletedDateToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :completed_date, :date
  end
end
