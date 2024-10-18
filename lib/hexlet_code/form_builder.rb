# frozen_string_literal: true

class FormBuilder
  Element = Struct.new(:tag, :attributes)

  attr_reader :form_body

  def initialize(entity, attributes = {})
    @entity = entity
    action = attributes.fetch(:url, '#')
    method = attributes.fetch(:method, 'post')

    @form_body = {
      inputs: [],
      submit: nil,
      form_options: { action:, method:, class: attributes[:class] }.merge(attributes.except(:url, :method, :class))
    }
  end

  def input(name, attributes = {})
    input_type = attributes.fetch(:as, 'text')

    input_attributes = input_type == :text ? build_textarea_attributes(name, attributes) : build_input_attributes(name, attributes)
    @form_body[:inputs] << input_attributes
  end

  def submit(value = 'Save')
    @form_body[:submit] = { value: value } if @form_body[:inputs].any? || !@form_body[:submit]
  end

  private

  def build_input_attributes(name, attributes)
    raise NoMethodError, "undefined method '#{name}' for #<struct User id=nil, name=nil, job=nil>" unless @entity.respond_to?(name)

    {
      name: name,
      type: 'text',
      value: @entity[name].to_s.strip,
      class: attributes[:class]
    }
  end

  def build_textarea_attributes(name, attributes)
    {
      name: name,
      type: 'textarea',
      value: @entity[name].to_s.strip,
      class: attributes[:class],
      rows: attributes.fetch(:rows, 20),
      cols: attributes.fetch(:cols, 40)
    }
  end
end
