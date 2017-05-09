class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize
  before_action :set_i18_locale_from_params

  protected

  def authorize
    if request.format == Mime[:json] || request.format == Mime[:atom]
      user = authenticate_or_request_with_http_basic do |u, p|
        User.find_by_name(u).try(:authenticate, p)
      end
    else
        if User.count.zero?
          redirect_to new_user_url
        elsif User.find_by(id: session[:user_id]).nil?
            redirect_to login_url, notice: 'Please log in'
        end
    end

  end

  def set_i18_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end

  end

end
