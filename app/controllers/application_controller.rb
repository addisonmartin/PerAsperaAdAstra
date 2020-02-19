class ApplicationController < ActionController::Base

  # Enables protection from cross-site request forgery attacks.
  protect_from_forgery with: :exception

  # Enables pagination in all controllers.
  include Pagy::Backend

end
