# frozen_string_literal: true

require_relative 'hexlet_code/version'

# main module for connecting form generator classes
module HexletCode
  class Error < StandardError; end

  autoload :Tag, 'hexlet_code/tag'
end
