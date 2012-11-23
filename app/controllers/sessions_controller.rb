class SessionsController < ApplicationController
  
  def new
    redirect_to user_path(cookies[:user]) if cookies[:user]
  end
  
  def create
    if user = User.first(:name => params[:name]) || User.create(:name => params[:name])
      cookies[:user] = { :value => user.name, :expires => 10.years.from_now }
      redirect_to user_path(user.name)
    else
      render :action => "new"
    end
  end
  
  def destroy
    cookies.delete(:user)
    redirect_to home_path
  end
  I am chang  
end
