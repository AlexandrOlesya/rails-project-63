# frozen_string_literal: true

require_relative 'hexlet_code/version'

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
      type = options.fetch(:as, :input)
      attributes = options.except(:as)

      validate_attribute(attribute)

      value = @user[attribute].to_s.strip

      case type
      when :input
        add_input(attribute, value, attributes)
      when :text
        add_textarea(attribute, value, attributes)
      else
        raise HexletCode::Error, "Unknown input type: #{type}"
      end
    end

    def submit(value = 'Save')
      @inputs << "<input type='submit' value='#{value}'>"
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
      body = attribute.to_s.capitalize
      label = "<label for='#{attribute}'>#{body}</label>"
      input = "<input name='#{attribute}' type='text' value='#{value}'#{attributes_string}>"

      @inputs << label + input
    end

    def add_textarea(attribute, value, attributes)
      rows = attributes.fetch(:rows, 40)
      cols = attributes.fetch(:cols, 20)
      attributes_string = build_attributes_string(attributes.except(:rows, :cols))

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
