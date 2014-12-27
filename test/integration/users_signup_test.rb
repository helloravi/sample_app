require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
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
      post_via_redirect users_path user: {name: "Radhika", email:"sparkx.radhika@gmail.com",
                                          password:"sandeep", password_confirmation: "sandeep"}
    end
    assert_template 'users/show'
    assert_select "div.alert", "You signed up for sample app"
    assert_not flash.nil?
  end

end
