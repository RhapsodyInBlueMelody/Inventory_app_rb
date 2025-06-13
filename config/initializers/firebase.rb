# config/initializers/firebase_config.rb (or similar)
require "firebase"
# require "json" # You no longer need to require 'json' here if you're not parsing the key

# Load Firebase environment variables securely
if ENV["FIREBASE_URI"].present? && ENV["FIREBASE_SERVICE_ACCOUNT_JSON"].present?
  begin
    FIREBASE_DATABASE_URL = ENV["FIREBASE_URI"]

    # ----------------------------------------------------------------------
    # THIS IS THE CRITICAL CHANGE:
    # Pass the raw JSON string directly to Firebase::Client.new
    # as per your gem's documentation. DO NOT parse it into a Hash.
    # ----------------------------------------------------------------------
    FIREBASE_CLIENT = Firebase::Client.new(FIREBASE_DATABASE_URL, ENV["FIREBASE_SERVICE_ACCOUNT_JSON"])

    Rails.logger.info "Firebase client initialized successfully."
  rescue => e
    Rails.logger.error "ERROR: Failed to initialize Firebase client: #{e.message}"
    Rails.logger.error "Please ensure FIREBASE_URI and FIREBASE_SERVICE_ACCOUNT_JSON are correct."
    FIREBASE_CLIENT = nil
  end
else
  Rails.logger.warn "Firebase client not initialized: FIREBASE_URI or FIREBASE_SERVICE_ACCOUNT_JSON missing."
  FIREBASE_CLIENT = nil
end

# ... (the firebase_id_token configuration block should remain as you had it,
# ensuring REDIS_URL is used there) ...
