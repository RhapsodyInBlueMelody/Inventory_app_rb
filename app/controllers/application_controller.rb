class ApplicationController < ActionController::Base
  helper_method :current_user # Makes current_user available in views

  private

  def current_user
    # This assumes that after Firebase authentication, you store the user's
    # firebase_uid (or your local user ID) in the session.
    # For example, in your SessionsController#firebase_google_auth, you might do:
    # session[:user_firebase_uid] = firebase_uid
    # And then, in your user model, you have a firebase_uid attribute.

    if session[:user_firebase_uid]
      @current_user ||= User.find_by(firebase_uid: session[:user_firebase_uid])
      # You might also want to re-fetch the user if they've been deleted or updated
      # or implement some kind of token refresh/validation if the session is old.
    end
  rescue ActiveRecord::RecordNotFound
    # If the user stored in the session no longer exists in the DB
    session[:user_firebase_uid] = nil # Clear the invalid session
    nil
  end

  # You would also need a way to sign out, which clears the session
  # def sign_out
  #   session[:user_firebase_uid] = nil
  # end
end
