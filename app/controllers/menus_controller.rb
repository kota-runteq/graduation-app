class TopController < ApplicationController
  def index
    @q = Menu.ransack(params[:q])
  end
end

class MenusController < ApplicationController
  NUTRIENTS = %w[calories protein fat carbs]

  def index
    raw_q = params.fetch(:q, {}).permit! .to_h

    sanitized_q = raw_q.reject do |key, val|
      val.blank? ||
      (val.to_f.zero? && key.ends_with?("_lteq", "_gteq"))
    end

    @q = Menu.ransack(sanitized_q)
    @menus = @q.result(distinct: true).order(:name)
  end
end
