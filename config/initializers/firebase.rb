require "firebase"
require "json" # Needed to parse the JSON string from the environment variable

# Load Firebase environment variables securely
if ENV["FIREBASE_URI"].present? && ENV["FIREBASE_SERVICE_ACCOUNT_JSON"].present?
  begin
    FIREBASE_DATABASE_URL = ENV["FIREBASE_URI"]
    FIREBASE_SERVICE_ACCOUNT_KEY = JSON.parse(ENV["FIREBASE_SERVICE_ACCOUNT_JSON"])

    FIREBASE_CLIENT = Firebase::Client.new(FIREBASE_DATABASE_URL, FIREBASE_SERVICE_ACCOUNT_KEY)
    Rails.logger.info "Firebase client initialized successfully."
  rescue JSON::ParserError => e
    Rails.logger.error "ERROR: Failed to parse FIREBASE_SERVICE_ACCOUNT_JSON: #{e.message}"
    Rails.logger.error "Please ensure the JSON variable on Railway is correctly formatted."
    # If parsing fails, FIREBASE_CLIENT will not be initialized
    FIREBASE_CLIENT = nil
  rescue => e
    Rails.logger.error "ERROR: Failed to initialize Firebase client: #{e.message}"
    FIREBASE_CLIENT = nil
  end
else
  Rails.logger.warn "Firebase client not initialized: FIREBASE_URI or FIREBASE_SERVICE_ACCOUNT_JSON missing."
  FIREBASE_CLIENT = nil
end

# Optional: You may want to ensure this Firebase client is available globally or through a helper
# For example, if you access it via `FirebaseClient.instance`
# You might define a helper method in application_controller.rb or a module:
# module FirebaseHelper
#   def firebase_client
#     FIREBASE_CLIENT
#   end
# end
# include FirebaseHelper in controllers where needed
