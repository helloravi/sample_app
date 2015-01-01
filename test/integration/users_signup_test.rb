require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
     post users_path user: {name: "Radhika", email: "foo@invalid",
                            password: "foo", password_confirmation: "bar"}
    end
    assert_template 'users/new'
  end

  test "valid sign up information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path user: {name: "Radhika", email:"sparkx.radhika@gmail.com",
                                          password:"sandeep", password_confirmation: "sandeep"}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token")

    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: "wrong")

    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?


    # assert_template 'users/show'
    # assert_select "div.alert", "You signed up for sample app"
    # assert_not flash.nil?
    # assert is_logged_in?
  end


end
