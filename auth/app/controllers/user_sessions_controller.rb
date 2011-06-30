class UserSessionsController < Devise::SessionsController
  include SpreeBase
  include Spree::ActionCallbackHooks
  
  helper :users, 'spree/base'

  include Spree::CurrentOrder

  after_filter :associate_user, :only => :create

  ssl_required :new, :create, :destroy, :update
  ssl_allowed :login_bar

  # GET /resource/sign_in
  def new
    invoke_callbacks(:new_action, :before)
    super
  end

  def create
    invoke_callbacks(:create, :before)

    authenticate_user!

    if user_signed_in?
      invoke_callbacks(:create, :after)

      respond_to do |format|
        format.html {
          flash[:notice] = I18n.t("logged_in_succesfully")
          redirect_back_or_default(products_path)
        }
        format.js {
          user = resource.record
          render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
        }
      end
    else
      flash[:error] = I18n.t("devise.failure.invalid")
      invoke_callbacks(:create, :fail)
      render :new
    end
  end

  def destroy
    invoke_callbacks(:destroy, :before)

    session.clear
    super
  end

  def nav_bar
    render :partial => "shared/nav_bar"
  end

  private

  def associate_user
    return unless current_user and current_order
    current_order.associate_user!(current_user)
    session[:guest_token] = nil
  end

  def accurate_title
    I18n.t(:log_in)
  end

end
