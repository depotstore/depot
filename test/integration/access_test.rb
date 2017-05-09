require 'test_helper'

class AccessTest < ActionDispatch::IntegrationTest
  # testing for at least one user (should be redirected to login_url,
  # but for a few exception it redirects to different url)
  setup do
    setup_urls
    setup_extras
    @urls_id << "/users/#{User.first.id}" << "/users/#{User.last.id}"
  end

  test 'authorization for json and atom' do
    #authorization for json and atom on login
    login_as User.first

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

    #authorization for json and atom on logout
    logout # defined in test_helper.rb

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

  test 'authorization for html and other formats: admin' do
    logout
    get admin_url
    assert_response :redirect
    assert_redirected_to login_url
    assert_redirected_to controller: 'sessions', action: 'new'
  end

  test 'authorization for html and other formats: index and new' do
    logout
    @urls.each do |url|
      get url
      assert_response :redirect
      assert_redirected_to login_url
      assert_redirected_to controller: 'sessions', action: 'new'

      get "#{url}/new"

      if url == orders_url
        assert_response :redirect
        assert_redirected_to store_index_url
      else
        assert_response :redirect
        assert_redirected_to login_url
        assert_redirected_to controller: 'sessions', action: 'new'
      end
    end

  end

  test 'authorization for html and other formats: show, edit and destroy' do
    logout
    @urls_id.each do |url|
      get url
      assert_response :redirect
      assert_redirected_to login_url
      assert_redirected_to /login/

      get "#{url}/edit"
      assert_response :redirect
      assert_redirected_to login_url
      assert_redirected_to /login/

      put url

      if url != "/carts/#{Cart.first.id}" &&
         url != "/carts/#{Cart.second.id}" &&
         url != "/carts/#{Cart.last.id}"

        assert_response :redirect
        assert_redirected_to login_url
        assert_redirected_to /login/
      else
        assert_response :redirect
        assert_redirected_to controller: 'carts', action: 'show'
      end

      delete url

      if url != "/carts/#{Cart.first.id}" &&
         url != "/carts/#{Cart.second.id}" &&
         url != "/carts/#{Cart.last.id}"

        assert_response :redirect
        assert_redirected_to login_url
        assert_redirected_to /login/
      else
        assert_response :redirect
        assert_redirected_to store_index_url
      end

    end

  end

  test 'authorization for html and other formats: create' do
    logout
    post products_url, params: {product: @update}
    assert_response :redirect
    assert_redirected_to login_url
    assert_redirected_to controller: 'sessions', action: 'new'

    post line_items_url, params: {product_id: products(:ruby).id}
    assert_response :redirect
    assert_redirected_to store_index_url
    assert_redirected_to controller: 'store', action: 'index'

    post line_items_url, params: {product_id: products(:ruby).id}
    assert_response :redirect
    assert_redirected_to store_index_url
    assert_redirected_to controller: 'store', action: 'index'

    post carts_url, params: { cart: {  } }
    assert_response :redirect
    assert_redirected_to cart_url(Cart.last)

    post orders_url, params: { order: @tested_order}
    assert_response :redirect
    assert_redirected_to store_index_url
    assert_redirected_to controller: 'store', action: 'index'

    post users_url, params: { user: @user }
    assert_response :redirect
    assert_redirected_to login_url
    assert_redirected_to controller: 'sessions', action: 'new'

  end
end
