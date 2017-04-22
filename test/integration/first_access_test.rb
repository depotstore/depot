require 'test_helper'

class FirstAccessTest < ActionDispatch::IntegrationTest

# testing for zero users (should be redirected to new_user_url,
# but for a few exception it redirects to different url)
  setup do
    setup_urls #test_helper.rb
    setup_extras #test_helper.rb
  end

  test 'authorization for json and atom' do
    User.delete_all
    @urls.each do |url|
      get "#{url}.json"
      assert_response 401
    end

    @urls_id.each do |url|
      get "#{url}.json"
      assert_response 401
    end

    Product.all.each do |product|
      get "/products/#{product.id}/who_bought.atom"
      assert_response 401
    end

  end

  test 'authorization for html and other formats: admin and login' do
    User.delete_all
    get admin_url
    assert_response :redirect
    assert_redirected_to new_user_url
    assert_redirected_to /users\/new/

    get login_url
    assert_response :redirect
    assert_redirected_to new_user_url
    assert_redirected_to /users\/new/
  end

  test 'authorization for html and other formats: index and new' do
    User.delete_all
    @urls.each do |url|
      get url
      assert_response :redirect
      assert_redirected_to new_user_url
      assert_redirected_to controller: 'users', action: 'new'

      get "#{url}/new"

      unless url == users_url
        assert_response :redirect
        assert_redirected_to new_user_url
        assert_redirected_to /users\/new/
      else
        assert_response :success
        assert_generates "#{url}/new", controller: 'users', action: 'new'
      end
    end

  end

  test 'authorization for html and other formats: show, edit and destroy' do
    User.delete_all
    @urls_id.each do |url|
      get url
      assert_response :redirect
      assert_redirected_to new_user_url
      assert_redirected_to /users\/new/

      get "#{url}/edit"
      assert_response :redirect
      assert_redirected_to new_user_url
      assert_redirected_to /users\/new/

      put url

      if url != "/carts/#{Cart.first.id}" &&
         url != "/carts/#{Cart.second.id}" &&
         url != "/carts/#{Cart.last.id}"

        assert_response :redirect
        assert_redirected_to new_user_url
        assert_redirected_to /users\/new/
      else
        assert_response :redirect
        assert_redirected_to controller: 'carts', action: 'show'
      end

      delete url

      if url != "/carts/#{Cart.first.id}" &&
         url != "/carts/#{Cart.second.id}" &&
         url != "/carts/#{Cart.last.id}"

        assert_response :redirect
        assert_redirected_to new_user_url
        assert_redirected_to /users\/new/
      else
        assert_response :redirect
        assert_redirected_to store_index_url
      end
    end

  end

  test 'authorization for html and other formats: create' do
    User.delete_all
    post products_url, params: {product: @update}
    assert_response :redirect
    assert_redirected_to new_user_url
    assert_redirected_to /users\/new/

    post line_items_url, params: {product_id: products(:ruby).id}
    assert_response :redirect
    assert_redirected_to store_index_url
    assert_redirected_to controller: 'store', action: 'index'

    post carts_url, params: { cart: {  } }
    assert_response :redirect
    assert_redirected_to cart_url(Cart.last)

    post orders_url, params: { order: @tested_order }
    assert_response :redirect
    assert_redirected_to store_index_url
    assert_redirected_to controller: 'store', action: 'index'

    post users_url, params: { user: @user }
    assert_response :redirect
    assert_redirected_to users_url
    assert_redirected_to controller: 'users', action: 'index'

    @user = User.find_by(name: 'sam')
    post login_url, params: {name: @user.name, password: 'secret'}
    assert_redirected_to admin_url
    assert_equal @user.id, session[:user_id]
  end
end
