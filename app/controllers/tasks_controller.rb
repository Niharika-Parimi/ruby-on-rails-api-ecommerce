class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ], except: %i[completed statistics priority ]

  def index
    @tasks = Task.all
    render json: { message: 'Successfull', task: @tasks }, status: :ok
  end


  def show
  end


  def new
    @task = Task.new
  end


  def edit
  end


  def create
    @task = Task.new(task_params)

   
      if @task.save
   
        render json: { message: "successfully", task: @task }, status: :ok
      else
        render json: @task.errors, status: :unprocessable_entity 
      end
    
  end


  def update
    
      if @task.update(task_params)
        if @task.saved_change_to_attribute?(:status) && @task.status == "completed"
          @task.completed_date = Date.today
          @task.save
        end
        render json: { message: "successfully", task: @task }, status: :ok
      else
        render json: @task.errors, status: :unprocessable_entity 
      end
    
  end

  def progress
    
    task = Task.find(params[:id])
    
    if task.present?
      task.update(progress: params[:progress])
      render json: { message: 'Successfull', task: task }, status: :ok
    else
      render json: { error: 'Failed to insert userid', errors: task.errors }, status: :unprocessable_entity
    end
  end

 

  def duedate
    task = Task.find_by(id: params[:id])
    
    if task.present?
      task.update(due_date: params[:due_date])
      render json: { message: 'Successfull', task: task }, status: :ok
    else
      render json: { error: 'Failed to insert duedate', errors: task.errors }, status: :unprocessable_entity
    end

  end
 

  def tasksofstatus
    status = params[:status]

    if status.present?
      tasks = Task.where(status: status) 
    else
      tasks = Task.all
    end

    render json: tasks
  end
  

  def overdue
 
     task = Task.where("due_date <?", current_date)

     render json: {task: task}
  end

  def completed
    #http://localhost:3000/tasks/completed?start_date=2024-03-10&end_date=2024-03-15
    start_date = params[:start_date]
    
    end_date = params[:end_date]

    if start_date.present? && end_date.present?
     
      completed_tasks = Task.where(status: "completed")
                            .where("completed_date >= ?", start_date)
                            .where("completed_date <= ?", end_date)
      
      render json: completed_tasks
    else
      render json: { error: "Both startDate and endDate parameters are required" }, status: :unprocessable_entity
    end
  end

  def statistics

    task =Task.all
    total_count = task.count
    completed_count = Task.where(status: "completed").count
    percentage = (completed_count.to_f/total_count.to_f) * 100
    render json: {total_count: total_count,completed_count: completed_count,percentage: percentage }
   

  end
  def priority
   
    medium = Task.where(priority: "medium").order(due_date: :asc)
    low = Task.where(priority: "low").order(due_date: :asc)
    high = Task.where(priority: "high").order(due_date: :asc)

    all_tasks = {
      medium_priority: medium,
      low_priority: low,
      high_priority: high
    }

    render json: all_tasks

  

  end

  def destroy
    @task.destroy
    render json: { message: 'Successfully deleted', task: @task }, status: :ok

  end

  private
   
    def set_task
      @task = Task.find(params[:id])
    end

    require 'date'
    def current_date
      Date.today
    end


    
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :status, :progress, :priority, :due_date, :user_id,:completed_date)
    end
end
