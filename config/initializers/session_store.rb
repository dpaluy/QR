# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_nds_qr_session',
  :secret      => 'ba827a1cb7904e84ef8f2fc22d4b8418abfdc998c4ba6af6c05105ef996e6cc5611ea92840b51914d24d47031cc3fbc0460bd0e7a68609d8c8295ef5817cddc5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
