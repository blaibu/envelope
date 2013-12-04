class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    gon.environment = Rails.env
    gon.clientApplication = {
        version: 'someversion',
        tag: 'testtag'
    }
    gon.hostConfig = {
        protocol: 'http://'
    }
  end

end
