# frozen_string_literal: true

require_relative './respond_to_pb'

module RailsRespondToPb
  class Railtie < Rails::Railtie
    initializer 'respond_to_pb.use_middleware' do |app|
      app.middleware.use(RespondToPb)
    end

    initializer 'respond_to_pb.controller_include' do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.include ActionController::MimeResponds
      end
    end

    initializer 'respond_to_pb.require_pb' do
      Dir["#{Rails.root}/lib/**/*_twirp.rb"].sort.each { |file| require file }
    end
  end
end
