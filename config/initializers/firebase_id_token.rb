require "firebase_id_token"
require "redis"

FirebaseIdToken.configure do |config|
  # Replace 'YOUR_FIREBASE_PROJECT_ID' with your actual Firebase Project ID
  # E.g., 'inventory-app-29fc2'
  config.project_ids = [ ENV["FIREBASE_PROJECT_ID"] ] # Read from ENV for security
  # You can also configure Redis if you have a custom Redis setup
  # config.redis = Redis.new(host: 'localhost', port: 6379, db: 0)
end

# Fetch Firebase certificates on application boot if they are not present
# This might take a moment the first time the app starts
FirebaseIdToken::Certificates.request unless FirebaseIdToken::Certificates.present?
