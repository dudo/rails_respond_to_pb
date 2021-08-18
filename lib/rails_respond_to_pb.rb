# frozen_string_literal: true

require_relative 'rails_respond_to_pb/version'
require_relative 'rails_respond_to_pb/mime_types' if defined?(Rails)
require_relative 'rails_respond_to_pb/railtie' if defined?(Rails)

module RailsRespondToPb
end
