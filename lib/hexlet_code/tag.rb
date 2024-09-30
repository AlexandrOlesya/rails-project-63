# frozen_string_literal: true

module HexletCode
  # class tag returns generated tag
  class Tag
    def self.build(tag, attrs = {})
      content = block_given? ? yield : nil
      attributes = attrs.map { |k, v| "#{k}='#{v}'" }.join(' ')

      if content
        attributes.empty? ? "<#{tag}>#{content}</#{tag}>" : "<#{tag} #{attributes}>#{content}</#{tag}>"
      else
        "<#{tag}#{attributes.empty? ? '' : " #{attributes}"}>"
      end
    end
  end
end
