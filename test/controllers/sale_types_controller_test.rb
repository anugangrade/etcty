require 'test_helper'

class SaleTypesControllerTest < ActionController::TestCase
  setup do
    @sale_type = sale_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sale_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale_type" do
    assert_difference('SaleType.count') do
      post :create, sale_type: { amount: @sale_type.amount, name: @sale_type.name }
    end

    assert_redirected_to sale_type_path(assigns(:sale_type))
  end

  test "should show sale_type" do
    get :show, id: @sale_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sale_type
    assert_response :success
  end

  test "should update sale_type" do
    patch :update, id: @sale_type, sale_type: { amount: @sale_type.amount, name: @sale_type.name }
    assert_redirected_to sale_type_path(assigns(:sale_type))
  end

  test "should destroy sale_type" do
    assert_difference('SaleType.count', -1) do
      delete :destroy, id: @sale_type
    end

    assert_redirected_to sale_types_path
  end
end
