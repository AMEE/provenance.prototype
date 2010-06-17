# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_provenance-web_session',
  :secret      => 'c3806a6d92462d6e7f032d581a952be27473680653310b098b810e72004f67c105d9bc46605086a464ceb60dee74653dd480f9e3d8d8e68862137dd86f996ca0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
