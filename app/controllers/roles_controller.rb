class RolesController < ApplicationController

  def index
    unless has_full_tax_powers?(params[:tax_id])
      redirect_to account_path and return
    end

    @tax = Tax.find_by_slug(params[:tax_id]) || Tax.find(params[:tax_id])
    @supporters = @tax.pledgers - @tax.trustees

    @role = Role.new
  end

  def create
    unless has_full_tax_powers?(params[:tax_id])
      redirect_to account_path and return
    end

    @role = Role.new(params[:role])

    if @role.save
      redirect_to :back
    else
      flash[:notice] = @role.errors.full_messages.join(", ")
      redirect_to :back
    end

  end

  def destroy
    unless has_full_tax_powers?(params[:tax_id])
      redirect_to account_path and return
    end

    @role = Role.find(params[:id])
    @role.destroy

    redirect_to :back
  end

end