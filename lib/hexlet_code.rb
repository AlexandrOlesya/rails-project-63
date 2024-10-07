# frozen_string_literal: true

require_relative 'hexlet_code/version'
require 'pry'

# main module for connecting form generator classes
module HexletCode
  class Error < StandardError; end

  autoload :Tag, 'hexlet_code/tag'

  # class generated forms
  class FormBuilder
    def initialize(user)
      @user = user
      @inputs = []
    end

    def input(attribute, options = {})
      type = options.fetch(:as, :textarea)
      attributes = options.except(:as)

      validate_attribute(attribute)

      value = @user[attribute].to_s.strip

      case type
      when :textarea
        add_input(attribute, value, attributes)
      when :text
        add_textarea(attribute, value, attributes)
      else
        raise HexletCode::Error, "Unknown input type: #{type}"
      end
    end

    def build
      @inputs.join
    end

    private

    def validate_attribute(attribute)
      return if @user.respond_to?(attribute)

      raise HexletCode::Error,
            "public_send: undefined method #{attribute} for <#{@user}> (NoMethodError)"
    end

    def add_input(attribute, value, attributes)
      attributes_string = build_attributes_string(attributes)

      @inputs << "<input name='#{attribute}' type='text' value='#{value}'#{attributes_string}>"
    end

    def add_textarea(attribute, value, attributes)
      rows = attributes.fetch(:rows, 40) # по умолчанию 40, если не указано
      cols = attributes.fetch(:cols, 20) # по умолчанию 20, если не указано
      attributes_string = build_attributes_string(attributes.except(:rows, :cols)) # исключаем rows и cols

      @inputs << "<textarea name='#{attribute}' rows='#{rows}' cols='#{cols}'#{attributes_string}>#{value}</textarea>"
    end

    def build_attributes_string(attributes)
      return '' if attributes.empty?

      attributes.map { |key, value| "#{key}='#{value}'" }.join(' ').strip.prepend(' ')
    end
  end

  def self.form_for(user, option = {})
    url = option.fetch(:url, '#')
    form_builder = FormBuilder.new(user)

    yield(form_builder) if block_given?

    "<form action='#{url}' method='post'>#{form_builder.build}</form>"
  end
end
