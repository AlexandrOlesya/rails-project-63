# frozen_string_literal: true

require_relative 'hexlet_code/version'
require 'pry'

# main module for connecting form generator classes
module HexletCode
  class Error < StandardError; end

  autoload :Tag, 'hexlet_code/tag'

  def self.form_for(user, option = {})
    url = option.fetch(:url, '#')

    yield(user) if block_given?

    "<form action='#{url}' method='post'></form>"
  end
end
