# frozen_string_literal: true

require_relative './respond_to_pb'

module RailsRespondToPb
  class Railtie < Rails::Railtie
    initializer 'respond_to_pb' do |app|
      app.middleware.use(RespondToRpc)
    end
  end
end
