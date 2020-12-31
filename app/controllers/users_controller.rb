class UsersController < ApplicationController

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
      # redirect_to "/users/#{user.id}"
      redirect_to user_url(@user)
      # render json: user
    else
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
    params.require(:user).permit(:email,:political_affiliation,:age,:username) #=> {email: jfdkajf, political_affiliation: fjkdlaj
                                                                                    # age: 12421, username: jfdksaj}
  end
end
