class ApplicationController < ActionController::Base

  # Enables protection from cross-site request forgery attacks.
  protect_from_forgery with: :exception

end
