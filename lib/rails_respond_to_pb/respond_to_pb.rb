# frozen_string_literal: true

require_relative './twirp_handler'

class RespondToPb
  def initialize(app)
    @app = app
  end

  def call(env)
    _, @resource, @action = env['PATH_INFO'].split('/')

    if env['CONTENT_TYPE'] == Twirp::Encoding::PROTO
      env['HTTP_ACCEPT'] = Twirp::Encoding::PROTO
      service.call(env)
    else
      @app.call(env)
    end
  end

  private

  def handler
    TwirpHandler.new(controller: controller_class)
  end

  def service
    service_class.new(handler).tap do |svc|
      svc.before do |rack_env, rpc_env|
        rpc_env[:rack_env] = rack_env
      end
    end
  end

  def service_class
    "#{@resource}Service".constantize
  end

  def controller_class
    "#{@resource}Controller".constantize
  end
end
