# frozen_string_literal: true

class FormBuilder
  Element = Struct.new(:tag, :attributes)

  attr_reader :form_body

  def initialize(entity)
    @entity = entity
    @form_body = []
  end

  def input(attribute, as: :input, **options)
    validate_attribute(attribute)
    value = @entity[attribute].to_s.strip

    case as
    when :input
      add_input(attribute, value, **options)
    when :text
      add_textarea(attribute, value, **options)
    else
      raise HexletCode::Error, "Unknown input type: #{as}"
    end
  end

  def submit(value = 'Save')
    @form_body << Element.new('input', { type: 'submit', value: value })
  end

  def build
    @form_body.map { |element| generate_html(element) }.join
  end

  private

  def generate_html(element)
    case element.tag
    when 'label'
      "<label for='#{element.attributes[:for]}'>#{element.attributes[:content]}</label>"
    when 'input'
      build_input_html(element)
    when 'textarea'
      build_textarea_html(element)
    else
      raise HexletCode::Error, "Unknown tag type: #{element.tag}"
    end
  end

  def build_input_html(element)
    attributes = build_attributes_string(element.attributes.except(:tag))
    "<input #{attributes}>"
  end

  def build_textarea_html(element)
    name = element.attributes[:name]
    rows = element.attributes[:rows]
    cols = element.attributes[:cols]
    value = element.attributes[:value]
    "<textarea name='#{name}' rows='#{rows}' cols='#{cols}'>#{value}</textarea>"
  end

  def validate_attribute(attribute)
    return if @entity.respond_to?(attribute)

    raise NoMethodError, "undefined method '#{attribute}' for #<struct User id=nil, name=nil, job=nil>"
  end

  def add_input(attribute, value, **options)
    add_label(attribute)
    @form_body << Element.new('input', { name: attribute, type: 'text', value: value, **options })
  end

  def add_textarea(attribute, value, **options)
    add_label(attribute)
    @form_body << Element.new('textarea', { name: attribute, value: value,
                                             rows: options.fetch(:rows, 40),
                                             cols: options.fetch(:cols, 20) })
  end

  def entity_class
    "#<#{@entity.class} #{attributes_representation}>"
  end

  def attributes_representation
    @entity.members.map { |member| "#{member}=#{@entity[member]}" }.join(', ')
  end

  def add_label(attribute)
    label = generate_label(attribute)
    @form_body << Element.new('label', { for: attribute, content: label })
  end

  def generate_label(attribute)
    attribute.to_s.capitalize
  end

  def build_attributes_string(attributes)
    attributes.map { |key, value| "#{key}='#{value}'" }.join(' ')
  end
end
