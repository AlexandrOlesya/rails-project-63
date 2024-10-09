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

      @user.inspect
      raise NoMethodError, "undefined method '#{attribute}' for #<struct User id=nil, name=nil, job=nil>"
    end

    def generate_label(attribute)
      value = attribute.to_s.capitalize
      "<label for='#{attribute}'>#{value}</label>"
    end

    def add_input(attribute, value, attributes)
      attributes_string = build_attributes_string(attributes)
      label = generate_label(attribute)
      input = "<input name='#{attribute}' type='text' value='#{value}'#{attributes_string}>"

      @inputs << (label + input)
    end

    def add_textarea(attribute, value, attributes)
      rows = attributes.fetch(:rows, 40)
      cols = attributes.fetch(:cols, 20)
      attributes_string = build_attributes_string(attributes.except(:rows, :cols))
      label = generate_label(attribute)
      textaria = "<textarea name='#{attribute}' rows='#{rows}' cols='#{cols}'#{attributes_string}>#{value}</textarea>"

      @inputs << (label + textaria)
    end

    def build_attributes_string(attributes)
      return '' if attributes.empty?

      attributes.map { |key, value| "#{key}='#{value}'" }.join(' ').strip.prepend(' ')
    end
  end

  def self.form_for(user, option = {})
    url = option.fetch(:url, '#')
    method = option.fetch(:method, 'post')
    css_class = option.fetch(:class, nil)
    form_builder = FormBuilder.new(user)

    yield(form_builder) if block_given?

    attributes = []
    attributes << "class='#{css_class}'" if css_class
    attributes_str = attributes.empty? ? '' : " #{attributes.join(' ')}"

    "<form action='#{url}' method='#{method}'#{attributes_str}>#{form_builder.build}</form>"
  end
end
