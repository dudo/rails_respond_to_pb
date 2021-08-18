# frozen_string_literal: true

require_relative 'rails_respond_to_pb/version'

if defined?(Rails)
  require_relative 'rails_respond_to_pb/mime_types'
  require_relative 'rails_respond_to_pb/railtie'
end

module RailsRespondToPb
end
