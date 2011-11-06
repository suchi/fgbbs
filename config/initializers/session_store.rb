# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fgbbs_session',
  :secret      => '0bf635558c3f27fa84571c3d0dc7b05a680eef22d6103e3ea848de7c390278e85ea65791744282743808ba61d4da36695b1e8f10a19b5cc2b5545dbb5aaa72b3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
