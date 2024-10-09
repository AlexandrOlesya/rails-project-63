# frozen_string_literal: true

require_relative '../lib/hexlet_code'

RSpec.describe 'HexletCode::Tag' do
  context 'Tag' do
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

  context 'Form for' do
    let(:user) { Struct.new(:name, :email).new('Alexalex@example.com') }

    it 'form without attributes' do
      result = HexletCode.form_for user do |f|
      end
      expect(result).to eq("<form action='#' method='post'></form>")
    end

    it 'form without attributes with change method' do
      result = HexletCode.form_for user, method: 'get' do |f|
      end
      expect(result).to eq("<form action='#' method='get'></form>")
    end

    it 'form with attributes' do
      result = HexletCode.form_for user, url: '/users' do |f|
      end
      expect(result).to eq("<form action='/users' method='post'></form>")
    end
  end

  context 'Generated fields' do
    let(:user) { Struct.new(:name, :job, :gender, keyword_init: true).new(name: 'rob', job: 'hexlet', gender: 'm') }

    it 'generate form' do
      result = HexletCode.form_for user do |f|
        f.input :name
        f.input :job, as: :text
      end
      expect(result).to eq(
        "<form action='#' method='post'>" \
          "<label for='name'>Name</label>" \
          "<input name='name' type='text' value='rob'>" \
          "<label for='job'>Job</label>" \
          "<textarea name='job' rows='40' cols='20'>hexlet</textarea>" \
        '</form>'
      )
    end

    it 'generate form with optional parameter' do
      result = HexletCode.form_for user, url: '#' do |f|
        f.input :name, class: 'user-input'
        f.input :job
      end
      expect(result).to eq(
        "<form action='#' method='post'>" \
          "<label for='name'>Name</label>" \
          "<input name='name' type='text' value='rob' class='user-input'>" \
          "<label for='job'>Job</label>" \
          "<input name='job' type='text' value='hexlet'>" \
        '</form>'
      )
    end

    it 'generate form with overridden default parameters' do
      result = HexletCode.form_for user, url: '#' do |f|
        f.input :job, as: :text, rows: 50, cols: 50
      end
      expect(result).to eq(
        "<form action='#' method='post'>" \
          "<label for='job'>Job</label>" \
          "<textarea name='job' rows='50' cols='50'>hexlet</textarea>" \
        '</form>'
      )
    end

    it 'error, if parameter is missing' do
      expect do
        HexletCode.form_for user, url: '/users' do |f|
          f.input :name
          f.input :job, as: :text
          f.input :age
        end
      end.to raise_error(HexletCode::Error,
                         /public_send: undefined method age for <#<struct name="rob", job="hexlet", gender="m">>/)
    end

    it 'generate form with submit' do
      result = HexletCode.form_for user do |f|
        f.input :name
        f.submit
      end
      expect(result).to eq(
        "<form action='#' method='post'>" \
          "<label for='name'>Name</label>" \
          "<input name='name' type='text' value='rob'>" \
          "<input type='submit' value='Save'>" \
        '</form>'
      )
    end

    it 'generate form with submit change text button' do
      result = HexletCode.form_for user do |f|
        f.input :name
        f.submit 'Wow'
      end
      expect(result).to eq(
        "<form action='#' method='post'>" \
          "<label for='name'>Name</label>" \
          "<input name='name' type='text' value='rob'>" \
          "<input type='submit' value='Wow'>" \
        '</form>'
      )
    end
  end
end
