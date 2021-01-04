class SessionsController < ApplicationController
  def new 
    @user = User.new 
    render :new 
  end 

  def create 
    #find a user by their username 
    #compare the input password to the pw_digest in the db
    # we are going to use BCrypt 

    @user = User.find_by_credentials( #method in the User model 
      params[:user][:username], #pulling info from params 
      params[:user][:password]
    ) #we chose not to write the helper_method like sessions_params cuz it's short...

    if @user 
      login(@user) #another method we will write 
      redirect_to user_url(@user)
    else 
      render :new 
    end

  end 

  def destroy 
    logout 
    redirect_to new_session_url 
  end
end
