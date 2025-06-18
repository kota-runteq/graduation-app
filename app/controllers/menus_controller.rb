class MenusController < ApplicationController
  NUTRIENTS = %w[calories protein fat carbs]

  def index
    allowed = %w[name_cont] + NUTRIENTS.flat_map { |nutrient| [ "#{nutrient}_gteq", "#{nutrient}_lteq" ] }
    raw_q = params.fetch(:q, {}).permit(allowed).to_h
    sanitized_q = raw_q.reject { |key, val| val.blank? || (val.to_f.zero? && key.end_with?("_lteq", "_gteq")) }

    @q = Menu.ransack(sanitized_q)
    @menus = @q.result.includes(:chain)

    if params[:sort_target].present?
      target = params[:sort_target].presence_in(NUTRIENTS)
      order  = params[:sort_order].presence_in(%w[asc desc]) || "asc"
      @menus = @menus.order_by_nutrient(target, order) if target
    end

    @menus = @menus.limit(100)
  end

  def show
    @menu = Menu.find(params[:id])
    nutrients_map = @menu.menu_nutrients.includes(:nutrient).index_by { |mn| mn.nutrient.key }
    @calories = nutrients_map["calories"]&.amount
    @protein = nutrients_map["protein"]&.amount
    @fat = nutrients_map["fat"]&.amount
    @carbs = nutrients_map["carbs"]&.amount

    @protein_kcal = @protein * 4
    @fat_kcal = @fat * 9
    @carbs_kcal = @calories - (@protein_kcal + @fat_kcal)
    # 計算で炭水化物の有するエネルギーを他の情報から計算している都合上、
    # 元データの精度や食物繊維の量によってはマイナスになるかもしれないので、
    # もしマイナスになったら、0にする
    @carbs_kcal = 0 if @carbs_kcal.negative?

    total_kcal = @protein_kcal + @fat_kcal + @carbs_kcal
    @protein_pct = (@protein_kcal / total_kcal * 100).round(1)
    @fat_pct = (@fat_kcal     / total_kcal * 100).round(1)
    @carbs_pct = (@carbs_kcal   / total_kcal * 100).round(1)
  end
end
