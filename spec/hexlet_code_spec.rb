# frozen_string_literal: true

require_relative '../lib/hexlet_code'

RSpec.describe 'HexletCode::Tag' do
  it 'builds a simple tag with content' do
    result = HexletCode::Tag.build('div', class: 'container') { 'Hello, World!' }
    expect(result).to eq("<div class='container'>Hello, World!</div>")
  end

  it 'builds a self-closing tag without content' do
    result = HexletCode::Tag.build('img', src: 'image.png')
    expect(result).to eq("<img src='image.png'>")
  end

  it 'builds a tag without attributes' do
    result = HexletCode::Tag.build('p') { 'Test' }
    expect(result).to eq('<p>Test</p>')
  end
end
