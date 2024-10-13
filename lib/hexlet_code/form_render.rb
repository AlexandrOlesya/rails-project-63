# frozen_string_literal: true

module HexletCode
  class FormRender
    def self.render_html(form_structure)
      form_structure.map do |element|
        render_element(element)
      end.join
    end

    def self.render_element(element)
      case element[:tag]
      when 'input'
        "<input #{attributes_to_s(element)}>"
      when 'textarea'
        "<textarea #{attributes_to_s(element)}>#{element[:value]}</textarea>"
      when 'label'
        "<label for='#{element[:for]}'>#{element[:content]}</label>"
      else
        raise HexletCode::Error, "Unknown tag: #{element[:tag]}"
      end
    end

    def self.attributes_to_s(attributes)
      attributes.except(:tag, :value).map { |k, v| "#{k}='#{v}'" }.join(' ')
    end
  end
end
