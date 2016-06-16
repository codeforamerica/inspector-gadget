class ApplicationController < ActionController::Base
  # TODO: Reactivate this
  # Causing severe problems when the form is iframed
  # And at the moment, it's not the weakest security link anyway
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
end
