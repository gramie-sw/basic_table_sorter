require 'spec_helper'

describe 'allow_sort_value' do

  it 'should delegate to allowed_sort_param?' do
    object = Object.new
    object.should_receive(:allowed_sort_param?).once.with(:comments, :index, 'email').and_return(true)
    object.should allow_sort_param(:comments, :index, :email)
  end
end