class UsersController < ApplicationController
  before_action :require_logged_in, only: [:index, :show]

  def new 
    @user = User.new
    render :new
  end


  def index 
    @users = User.all
    # render json: users
    render :index
  end

  def show 
    @user = User.find(params[:id])
    render :show
    # render json: user
  end

  def edit 
    # /users/:id/edit
    @user = User.find(params[:id])
    render :edit
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      #login user if save successful 
      # redirect_to "/users/#{user.id}"
      login(@user) #from applicationcontroller 
      redirect_to user_url(@user) # status code: 300 redirect
      # redirect_to users_url # status code: 300 redirect, but to the wrong url
      # render :show # status code: 200 OK
      # render json: user
    else
      #if unsuccessful, render :new 
      #use AR for errors
      # flash[:errors] = @user.errors.full_messages #only use flash with a redirect- persists for one extra cycle
      flash.now[:errors] = @user.errors.full_messages
      #flash.now-> for this cycle only 
      #:errors is banana-able -> just make sure it matches in application.html.erb
      render :new

      # render json: user.errors.full_messages, status: 422
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      # redirect_to "/users/#{user.id}"
      # redirect_to user_url(user.id)
      redirect_to user_url(@user)
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])

    user.destroy

    render json: user
  end

  private 

  def user_params
    params.require(:user).permit(:email,:political_affiliation,:age,:username, :password) #=> {email: jfdkajf, political_affiliation: fjkdlaj
                                                                                    # age: 12421, username: jfdksaj}
  end
end
