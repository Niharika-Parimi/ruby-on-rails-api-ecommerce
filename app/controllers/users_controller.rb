class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]


  def index
    @users = User.all
  end

  def show
    
  end

  
  def new
    @user = User.new
  end

  
  def edit
  end

 
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
       
        format.json { render :show, status: :created, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def assign

    user = User.find_by(id: params[:user_id])
    task = Task.find_by(id: params[:id])
    if user.present? && task.present?
      task.update(user_id: params[:user_id])
      render json: { message: 'Successfully', task: task }, status: :ok
    else
      render json: { error: 'Failed', errors: task.errors }, status: :unprocessable_entity
    end
  end

  def alltasks

    task = Task.where(user_id: params[:id])
    if task.present? 
      render json: { message: 'Found all tasks of user successfully', task: task }, status: :ok
    else
      render json: { error: 'Failed to find tasks', errors: task.errors }, status: :unprocessable_entity
    end

  end
  
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

 
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    
    def set_user
      @user = User.find(params[:id])
    end

    
    def user_params
      params.require(:user).permit(:name)
    end
end
