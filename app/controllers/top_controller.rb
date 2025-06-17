class TopController < ApplicationController
  def index
    @q = Menu.ransack(params[:q])
  end
end
