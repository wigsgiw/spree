class UserPasswordsController < Devise::PasswordsController
  include SpreeBase
  include Spree::ActionCallbackHooks
  helper :users, 'spree/base'

  def new
    invoke_callbacks(:new_action, :before)
    super
  end

  def create
    invoke_callbacks(:create, :before)
    super
  end

  def edit
    invoke_callbacks(:edit, :before)
    super
  end

  def update
    invoke_callbacks(:update, :before)
    super
  end
end
