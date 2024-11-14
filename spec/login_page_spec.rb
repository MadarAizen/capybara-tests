require 'capybara'
require 'rspec'
require_relative 'spec/spec_helper'

# rspec login_page_spec.rb

RSpec.describe 'Login, Cart, Parameterized', type: :feature do
  before do
    visit 'https://www.saucedemo.com'
  end

  let(:password) { 'secret_sauce' }
  let(:valid_user) { 'standard_user' }
  let(:invalid_user) { 'alex_2014' }

  context 'Login' do
    it 'successfull login' do
      fill_in 'user-name', with: valid_user
      fill_in 'password', with: password
      click_button 'Login'

      expect(page).to have_current_path('https://www.saucedemo.com/inventory.html', url: true)
    end

    it 'shows an error message for invalid credentials' do
      fill_in 'user-name', with: invalid_user
      fill_in 'password', with: password
      click_button 'Login'

      expect(page).to have_content('Epic sadface: Username and password do not match any user in this service')
    end
  end

  context 'Cart' do

    it 'adds items to the cart and verifies the cart count' do
      fill_in 'user-name', with: valid_user
      fill_in 'password', with: password
      click_button 'Login'

      find_button('Add to cart', match: :first).click
      find_button('Add to cart', match: :first).click

      expect(page).to have_css('.shopping_cart_badge', text: '2')
    end
  end

  context 'Parameterized Login Tests' do
    [{ username: 'standard_user', expected_success: true },{ username: 'locked_out_user', expected_success: false }
    ].each do |test_case|
      it "checks login for user #{test_case[:username]}" do
        fill_in 'user-name', with: test_case[:username]
        fill_in 'password', with: password
        click_button 'Login'

        if test_case[:expected_success]
          expect(page).to have_current_path('https://www.saucedemo.com/inventory.html', url: true)
        else
          expect(page).to have_content('Epic sadface: Sorry, this user has been locked out.')
        end

      end
    end
  end
end


