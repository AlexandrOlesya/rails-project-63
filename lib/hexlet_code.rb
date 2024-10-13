# frozen_string_literal: true

require_relative 'hexlet_code/version'

# main module for connecting form generator classes
module HexletCode
  class Error < StandardError; end

  autoload :Tag, 'hexlet_code/tag'
  autoload :FormBuilder, 'hexlet_code/form_builder'
  autoload :FormRender, 'hexlet_code/form_render'

  def self.form_for(entity, options = {})
    url = options.fetch(:url, '#')
    method = options.fetch(:method, 'post')
    css_class = options.fetch(:class, nil)

    form_builder = FormBuilder.new(entity)

    yield(form_builder) if block_given?

    attributes = []
    attributes << "class='#{css_class}'" if css_class
    attributes_str = attributes.empty? ? '' : " #{attributes.join(' ')}"

    "<form action='#{url}' method='#{method}'#{attributes_str}>#{form_builder.build}</form>"
  end
end
