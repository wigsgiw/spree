class Admin::PromotionActionsController < Admin::BaseController
  def create
    @calculators = Promotion::Actions::CreateAdjustment.calculators
    @promotion = Promotion.find(params[:promotion_id])
    @promotion_action = params[:promotion_action][:type].constantize.new(params[:promotion_action])
    @promotion_action.promotion = @promotion
 
    invoke_callbacks(:create, :before)

    if @promotion_action.save
      flash[:notice] = I18n.t(:successfully_created, :resource => I18n.t(:promotion_action))
      invoke_callbacks(:create, :after)
    else
      invoke_callbacks(:create, :fail)
    end
    respond_to do |format|
      format.html { redirect_to edit_admin_promotion_path(@promotion)}
      format.js   { render :layout => false }
    end
  end

  def destroy
    @promotion = Promotion.find(params[:promotion_id])
    @promotion_action = @promotion.promotion_actions.find(params[:id])

    invoke_callbacks(:destroy, :before)
    if @promotion_action.destroy
      flash[:notice] = I18n.t(:successfully_removed, :resource => I18n.t(:promotion_action))
      invoke_callbacks(:destroy, :after)
    else
      invoke_callbacks(:destroy, :fail)
    end
    respond_to do |format|
      format.html { redirect_to edit_admin_promotion_path(@promotion)}
      format.js   { render :layout => false }
    end
  end
end

