class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  helper_method :current_user, :logged_in?
  #gives us access to these controller methods in our views 

  def login(user)
    #assign session_token and give it as a cookie to the client's browser 
    session[:session_token] = user.reset_session_token! #a method 
    #putting a key-value pair into the session hash 
    #session hash is only available in controllers and views 
  end

  def current_user 
    #look for a user 
    @current_user ||= User.find_by(session_token: session[:session_token])
    #create instance var     find user using the session_token that matches the session's session_token 
  end

  def logged_in?
    !!current_user #the method, not the instance variable 
    #the ! changes the ruby object into a boolean value 
    #!! will change it back into its truthy/falsey value 
  end

  def logout 
    current_user.reset_session_token! if logged_in? 
    #changes the session_token in the db for that user 
    session[:session_token] = nil #clearing the cookie 
    @current_user = nil #extra precaution 
  end

  def require_logged_in 
    redirect_to new_session_url unless logged_in? 
    #will be used to protect some routes 
  end
end
