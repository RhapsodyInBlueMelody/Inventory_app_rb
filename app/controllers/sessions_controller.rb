require "firebase_id_token" # Add this line at the top

class SessionsController < ApplicationController
  def firebase_google_auth
    # ... (your existing Firebase ID Token verification logic) ...

    if firebase_uid && email
      user = User.find_or_create_by(firebase_uid: firebase_uid) do |u|
        u.email = email
        u.name = name
        u.avatar_url = avatar_url
      end

      if user.persisted?
        session[:user_firebase_uid] = user.firebase_uid # <-- THIS IS KEY
        # You might also want to redirect to a dashboard after successful login
        head :ok # Or render a success message / redirect
      else
        # Handle user creation/finding error
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid Firebase ID Token" }, status: :unauthorized
    end
  end
end
