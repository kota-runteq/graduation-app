class ChainsController < ApplicationController
  def index
    @q = Chain.ransack(params[:q])
    @chains = @q.result.includes(:chain_category).order("chain_categories.name ASC, chains.name ASC")
  end

  NUTRIENTS = Menu::NUTRIENTS.freeze

  def show
    @chain = Chain.find(params[:id])
    @q = @chain.menus.ransack(params[:q])
    @menus = @q.result.includes(:menu_nutrients)
 
    if params[:sort_target].present?
      target = params[:sort_target].presence_in(NUTRIENTS)
      order = params[:sort_order].presence_in(%w[asc desc]) || 'asc'
      @menus = @menus.order_by_nutrient(target, order) if target
    else
      @menus = @menus.order(:name)
    end
  end
end
