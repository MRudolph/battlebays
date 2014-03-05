# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test1_session',
  :secret      => 'e12ecca36df5e4a4058a5378cab4ca1e20f3078fa0636624105b8afc65fe10e0c0d0558383a80f43e9eb8e33e615ae4df4365fd996dcb234d89d9c78da6fbae7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
