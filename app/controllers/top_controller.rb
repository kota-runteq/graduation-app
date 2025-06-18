class TopController < ApplicationController
  def index
    @menus   = @q.result
  end
end
