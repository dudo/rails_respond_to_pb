# frozen_string_literal: true

class TwirpHandler
  # class UnknownRpcError < StandardError; end

  def initialize(controller:)
    @controller = controller
  end

  # The req argument is the input request message, already serialized.
  # The env argument is the Twirp environment with data related to the request (e.g. env[:output_class]),
  #   and other fields that could have been set from before-hooks (e.g. env[:user_id] from authentication).
  # The returned value is expected to be the response message (or its attributes), or a Twirp::Error.

  %i[new create show index edit update destroy].each do |action_name|
    define_method action_name do |req, env|
      dispatch action_name, req, env
    end
  end

  def method_missing(method_name, *arguments, &_block)
    dispatch method_name, arguments[0], arguments[1]
  end

  def respond_to_missing?(method_name, _include_private = false)
    @controller.method_defined? method_name
  end

  private

  def dispatch(action, req, env)
    request = ActionDispatch::Request.new(env.delete(:rack_env))
    req.to_h.each do |key, value|
      request.params[key] = value
    end
    response = ActionDispatch::Response.new
    @controller.dispatch(action, request, response)
    env[:output_class].decode(response.body)
  end
end
