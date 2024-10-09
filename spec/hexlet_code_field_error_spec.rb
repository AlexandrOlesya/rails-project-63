# frozen_string_literal: true

require_relative '../lib/hexlet_code'

RSpec.describe 'Field error' do
  let(:user) { Struct.new(:name, :job, :gender, keyword_init: true).new(name: 'rob', job: 'hexlet', gender: 'm') }

  it 'raises NoMethodError if parameter is missing' do
    expect do
      HexletCode.form_for(user, url: '/users') do |f|
        f.input :name
        f.input :job, as: :text
        f.input :age
      end
    end.to raise_error(NoMethodError, "undefined method 'age' for #<struct User id=nil, name=nil, job=nil>")
  end
end
