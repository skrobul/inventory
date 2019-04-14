# frozen_string_literal: true

class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV.fetch('INVENTORY_USERNAME'),
                               password: ENV.fetch('INVENTORY_PASSWORD')
end
