class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title, limit: 50
      t.string :description, limit: 50
      t.date :dueDate
      t.string :status, limit: 50
      t.string :progress, limit: 50
      t.string :priority, limit: 50
      t.date :created_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
