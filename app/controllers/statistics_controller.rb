class StatisticsController < ApplicationController
  def index
    render :layout=>'boxed'
  end
  def hours
    @hours=(params[:user] ? Tile.by_user(params[:user]) : Tile).statistic.hours
    respond_to do |format|
      format.svg { render :action=>'hours'}
    end
  end
end
