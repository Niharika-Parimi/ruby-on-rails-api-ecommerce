Rails.application.routes.draw do
  get '/tasks/overdue', to: 'tasks#overdue'
  get '/tasks/completed', to: 'tasks#completed'
  get '/tasks/statistics', to: 'tasks#statistics'
  get '/tasks/priority', to:'tasks#priority'
  

  resources :tasks do
   

    resources :users
  end

  get "up" => "rails/health#show", as: :rails_health_check
 
  post '/users', to: 'users#create'
  post '/tasks/:id/assign', to: 'users#assign'
  get   '/users/:id/tasks', to: 'users#alltasks'
  put   '/tasks/:id/progress', to: 'tasks#progress'
  put '/tasks/:id/duedate', to: 'tasks#duedate'
  put '/tasks/:id/todaydate', to: 'tasks#todaydate'
  get '/tasks/status/:status', to: 'tasks#tasksofstatus'
  put '/tasks/:id', to: 'tasks#update'


end
