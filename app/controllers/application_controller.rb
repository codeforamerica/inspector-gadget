class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # Options are `:exception` and `:null_session`
  protect_from_forgery with: :null_session
end
