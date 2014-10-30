require 'test_helper'

class CoupenTypesControllerTest < ActionController::TestCase
  setup do
    @coupen_type = coupen_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:coupen_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create coupen_type" do
    assert_difference('CoupenType.count') do
      post :create, coupen_type: { name: @coupen_type.name }
    end

    assert_redirected_to coupen_type_path(assigns(:coupen_type))
  end

  test "should show coupen_type" do
    get :show, id: @coupen_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @coupen_type
    assert_response :success
  end

  test "should update coupen_type" do
    patch :update, id: @coupen_type, coupen_type: { name: @coupen_type.name }
    assert_redirected_to coupen_type_path(assigns(:coupen_type))
  end

  test "should destroy coupen_type" do
    assert_difference('CoupenType.count', -1) do
      delete :destroy, id: @coupen_type
    end

    assert_redirected_to coupen_types_path
  end
end
