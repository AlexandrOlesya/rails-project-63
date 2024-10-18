# frozen_string_literal: true

module HexletCode
  class FormRender
    def self.render_html(form_structure)
      form_options = form_structure[:form_options]
      inputs = render_inputs(form_structure[:inputs])
      submit = render_submit(form_structure[:submit]) if form_structure[:submit]

      "<form #{render_form_attributes(form_options)}>#{inputs}#{submit}</form>"
    end

    def self.render_inputs(inputs)
      inputs.map { |input| render_input(input) }.join
    end

    def self.render_form_attributes(form_options)
      attributes = []
      attributes << "action='#{form_options[:action]}'"
      attributes << "method='#{form_options[:method]}'"
      attributes << "class='#{form_options[:class]}'" if form_options[:class]
      attributes.join(' ')
    end

    def self.render_input(input)
      label = render_label(input[:name])

      if input[:type] == 'textarea'
        textarea_html = render_textarea(input)
        "#{label}#{textarea_html}"
      else
        input_html = render_input_field(input)
        "#{label}#{input_html}"
      end
    end

    def self.render_input_field(input)
      class_attr = input[:class] ? "class='#{input[:class]}'" : ''
      "<input name='#{input[:name]}' type='#{input[:type]}' value='#{input[:value]}' #{class_attr}>"
    end

    def self.render_textarea(input)
      class_attr = input[:class] ? "class='#{input[:class]}'" : ''
      rows = input[:rows]
      cols = input[:cols]
      value = input[:value]
      attributes = "name='#{input[:name]}' rows='#{rows}' cols='#{cols}' #{class_attr}".strip
      "<textarea #{attributes}>#{value}</textarea>"
    end

    def self.render_label(name)
      "<label for='#{name}'>#{name.capitalize}</label>"
    end

    def self.render_submit(submit)
      "<input type='submit' value='#{submit[:value]}'>"
    end
  end
end
