class ChainsController < ApplicationController
  def index
    @q = Chain.ransack(params[:q])
    @chains = @q.result.includes(:chain_category).order('chain_categories.name ASC, chains.name ASC')
  end

  def show
    @chain = Chain.find(params[:id])
    @q  = @chain.menus.ransack(params[:q])
    @menus = @q.result.order(:name)
  end
end
