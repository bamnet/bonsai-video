# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bonsai_session',
  :secret      => '8834fc18fe02cab1400bd2e4ae5fab8861f08fe73b31b1a73340417153b6e5ed7deab5d3888c40f9842ffb085553218ddc35ecd38710e8d903823a56549a4e20'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
