require 'test_helper'

class EducationTypesControllerTest < ActionController::TestCase
  setup do
    @education_type = education_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:education_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create education_type" do
    assert_difference('EducationType.count') do
      post :create, education_type: { amount: @education_type.amount, name: @education_type.name }
    end

    assert_redirected_to education_type_path(assigns(:education_type))
  end

  test "should show education_type" do
    get :show, id: @education_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @education_type
    assert_response :success
  end

  test "should update education_type" do
    patch :update, id: @education_type, education_type: { amount: @education_type.amount, name: @education_type.name }
    assert_redirected_to education_type_path(assigns(:education_type))
  end

  test "should destroy education_type" do
    assert_difference('EducationType.count', -1) do
      delete :destroy, id: @education_type
    end

    assert_redirected_to education_types_path
  end
end
