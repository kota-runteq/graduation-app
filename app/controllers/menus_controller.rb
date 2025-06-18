class TopController < ApplicationController
  def index
    @q = Menu.ransack(params[:q])
  end
end

class MenusController < ApplicationController
  NUTRIENTS = %w[calories protein fat carbs]

  def index
    allowed = %w[name_cont] + NUTRIENTS.flat_map { |nutrient| [ "#{nutrient}_gteq", "#{nutrient}_lteq" ] }

    raw_q = params.fetch(:q, {}).permit(allowed).to_h

    sanitized_q = raw_q.reject { |key, val|
      val.blank? || (val.to_f.zero? && key.end_with?("_lteq", "_gteq"))
    }

    @q = Menu.ransack(params[:q])
    @menus = @q.result(distinct: true).includes(:chain).limit(100)
  end
end
