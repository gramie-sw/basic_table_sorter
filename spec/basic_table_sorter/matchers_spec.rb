require 'spec_helper'

describe 'allow_sort_value' do

  it 'should delegate to allowed_sort_param?' do
    object = Object.new
    expect(object).to receive(:allowed_sort_param?).once.with(:comments, :index, 'email').and_return(true)
    expect(object).to allow_sort_param(:comments, :index, :email)
  end
end