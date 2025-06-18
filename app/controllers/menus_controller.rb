class MenusController < ApplicationController
  NUTRIENTS = %w[calories protein fat carbs]

  def index
    allowed = %w[name_cont] + NUTRIENTS.flat_map { |nutrient| [ "#{nutrient}_gteq", "#{nutrient}_lteq" ] }
    raw_q = params.fetch(:q, {}).permit(allowed).to_h
    sanitized_q = raw_q.reject { |key, val| val.blank? || (val.to_f.zero? && key.end_with?("_lteq", "_gteq"))}

    @q = Menu.ransack(sanitized_q)
    @menus = @q.result.includes(:chain)

    if params[:sort_target].present?
      target = params[:sort_target].presence_in(NUTRIENTS)
      order  = params[:sort_order].presence_in(%w[asc desc]) || 'asc'
      @menus = @menus.order_by_nutrient(target, order) if target
    end
 
    @menus = @menus.limit(100)
  end
end
