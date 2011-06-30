class Spree::BaseController < ActionController::Base
  include SpreeBase
  include SpreeRespondWith
  include Spree::ActionCallbackHooks
end
