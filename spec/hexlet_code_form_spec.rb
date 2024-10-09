# frozen_string_literal: true

require_relative '../lib/hexlet_code'

RSpec.describe 'Form' do
  let(:user) { Struct.new(:name, :email).new('Alexalex@example.com') }

  it 'form without attributes' do
    result = HexletCode.form_for user
    expect(result).to eq("<form action='#' method='post'></form>")
  end

  it 'form without attributes with change method' do
    result = HexletCode.form_for user, method: 'get'
    expect(result).to eq("<form action='#' method='get'></form>")
  end

  it 'form without attributes with change method and optional params' do
    result = HexletCode.form_for user, method: 'get', class: 'hexlet-form'
    expect(result).to eq("<form action='#' method='get' class='hexlet-form'></form>")
  end

  it 'form with attributes' do
    result = HexletCode.form_for user, url: '/users'
    expect(result).to eq("<form action='/users' method='post'></form>")
  end
end
