class InvitationsController < ApplicationController
  
  before_filter :require_user
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new(strong_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      redirect_to new_invitation_path
      flash[:success] = "You have successfully invited #{@invitation.recipient_name}."
    else
      render :new
      flash[:error] = "Invitation Not Sent. Please Enter All Missing Fields"
    end
  end
  
  private
  
  def strong_params
    params.require(:invitation).permit(:inviter_id, :recipient_name, :recipient_email, :message)
  end
  
  
end