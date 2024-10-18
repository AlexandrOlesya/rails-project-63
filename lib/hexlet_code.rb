# frozen_string_literal: true

require_relative 'hexlet_code/version'

# main module for connecting form generator classes
module HexletCode
  class Error < StandardError; end

  autoload :Tag, 'hexlet_code/tag'
  autoload :FormBuilder, 'hexlet_code/form_builder'
  autoload :FormRender, 'hexlet_code/form_render'

  def self.form_for(entity, attributes = {})
    builded_form = FormBuilder.new(entity, attributes)
    yield(builded_form) if block_given?
    FormRender.render_html(builded_form.form_body)
  end
end
