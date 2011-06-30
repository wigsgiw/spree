class UserRegistrationsController < Devise::RegistrationsController
  include SpreeBase
  include Spree::ActionCallbackHooks
  
  helper :users, 'spree/base'

  ssl_required
  after_filter :associate_user, :only => :create
  before_filter :check_permissions, :only => [:edit, :update]
  skip_before_filter :require_no_authentication

  # GET /resource/sign_up
  def new
    invoke_callbacks(:new_action, :before)
    super
  end

  # POST /resource/sign_up
  def create
    invoke_callbacks(:create, :before)
    @user = build_resource(params[:user])
    if resource.save
      set_flash_message(:notice, :signed_up)
      ActiveSupport::Notifications.instrument('spree.user.signup', default_notification_payload.merge(:user => @user))
      fire_event('spree.user.signup', :user => @user)
      invoke_callbacks(:create, :after)
      sign_in_and_redirect(:user, @user)
    else
      clean_up_passwords(resource)
      invoke_callbacks(:create, :fail)
      render_with_scope(:new)
    end
  end

  # GET /resource/edit
  def edit
    invoke_callbacks(:edit, :before)
    super
  end

  # PUT /resource
  def update
    invoke_callbacks(:update, :before)
    super
  end

  # DELETE /resource
  def destroy
    invoke_callbacks(:destroy, :before)
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  def check_permissions
    authorize!(:create, resource)
  end

  def associate_user
    return unless current_user and current_order
    current_order.associate_user!(current_user)
    session[:guest_token] = nil
  end

end
