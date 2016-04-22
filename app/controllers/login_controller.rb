class LoginController < ApplicationController

  skip_before_filter :redirect_if_not_logged_in
  skip_before_filter :set_courses

  def new_session

  end

  def create_session
    user = User.find_by_username params[:username]
    if user && user.authenticate(params[:password])
      if current_user && current_user.guest
        user.absorb_data(current_user)
      #   gives user all of current_user's data
      #   then destroys current_user
      end
      session[:user_id] = user.id
      session[:course] = user.courses.first.id if user.courses.present?
      redirect_to courses_path
    end
  end

  def destroy_session
    session[:user_id] = nil
    session[:course] = nil
    @courses = Course.where(user_id: nil)
    redirect_to login_new_session_path
  end

  def signup
    @user = User.new
  end

  def create_guest_account

  end

end
