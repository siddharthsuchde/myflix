require 'spec_helper'

feature 'Signing in' do
  scenario 'with correct credentials' do
    sidd = Fabricate(:user)
    sign_in(sidd)
    expect(page).to have_content sidd.full_name
  end

  
end