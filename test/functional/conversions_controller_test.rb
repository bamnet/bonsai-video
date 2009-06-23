require 'test_helper'

class ConversionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conversions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conversion" do
    assert_difference('Conversion.count') do
      post :create, :conversion => { }
    end

    assert_redirected_to conversion_path(assigns(:conversion))
  end

  test "should show conversion" do
    get :show, :id => conversions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => conversions(:one).to_param
    assert_response :success
  end

  test "should update conversion" do
    put :update, :id => conversions(:one).to_param, :conversion => { }
    assert_redirected_to conversion_path(assigns(:conversion))
  end

  test "should destroy conversion" do
    assert_difference('Conversion.count', -1) do
      delete :destroy, :id => conversions(:one).to_param
    end

    assert_redirected_to conversions_path
  end
end
