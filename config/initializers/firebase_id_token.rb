require "firebase_id_token"
require "redis" # You'll need this if FirebaseIdToken uses Redis for caching

FirebaseIdToken.configure do |config|
  # Replace 'YOUR_FIREBASE_PROJECT_ID' with your actual Firebase Project ID
  # E.g., 'inventory-app-29fc2'
  config.project_ids = [ ENV["FIREBASE_PROJECT_ID"] ] # Read from ENV for security

  # Ensure Redis is configured if FirebaseIdToken uses it for caching certificates
  # Railway will provide REDIS_URL if you add a Redis service
  if ENV["REDIS_URL"].present?
    config.redis = Redis.new(url: ENV["REDIS_URL"])
  else
    # Fallback or error if Redis URL not present (e.g., for local testing without Redis)
    # You might want to log a warning here in development if Redis is optional.
    Rails.logger.warn "REDIS_URL not set, FirebaseIdToken might not cache certificates."
  end
end

# ----------------------------------------------------------------------
# THIS IS THE CRITICAL CHANGE:
# Move the certificate request to run AFTER the application is fully initialized.
# This prevents it from running during the 'assets:precompile' build step.
# ----------------------------------------------------------------------
Rails.application.config.after_initialize do
  Rails.logger.info "Attempting to request Firebase ID Token certificates..."
  begin
    FirebaseIdToken::Certificates.request unless FirebaseIdToken::Certificates.present?
    Rails.logger.info "Firebase ID Token certificates are present."
  rescue => e
    Rails.logger.error "Failed to request Firebase ID Token certificates: #{e.message}"
    # You might want to re-raise if this is a critical error,
    # or log and proceed if the app can function without them for a bit.
  end
end
