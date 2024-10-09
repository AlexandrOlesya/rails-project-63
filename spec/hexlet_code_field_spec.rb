# frozen_string_literal: true

require_relative '../lib/hexlet_code'

RSpec.describe 'Field' do
  let(:user) { Struct.new(:name, :job, :gender, keyword_init: true).new(name: 'rob', job: 'hexlet', gender: 'm') }

  it 'generate form' do
    result = HexletCode.form_for user do |f|
      f.input :name, class: 'user-input'
      f.input :job, as: :text, rows: 50, cols: 50
    end
    expect(result).to eq(
      "<form action='#' method='post'>" \
      "<label for='name'>Name</label>" \
      "<input name='name' type='text' value='rob' class='user-input'>" \
      "<label for='job'>Job</label>" \
      "<textarea name='job' rows='50' cols='50'>hexlet</textarea>" \
      '</form>'
    )
  end

  it 'raises NoMethodError if parameter is missing' do
    expect do
      HexletCode.form_for(user, url: '/users') do |f|
        f.input :name
        f.input :job, as: :text
        f.input :age
      end
    end.to raise_error(NoMethodError, "undefined method 'age' for #<struct User id=nil, name=nil, job=nil>")
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

  it 'submit and change method' do
    result = HexletCode.form_for user, url: '/profile', method: 'get', &:submit
    expect(result).to eq(
      "<form action='/profile' method='get'>" \
      "<input type='submit' value='Save'>" \
      '</form>'
    )
  end
end
