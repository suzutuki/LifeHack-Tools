class SportsController < ApplicationController
  def create
  end

  def destroy
  end

  def index
    @user = current_user
    @graphdays =  @user.sports.order(sport_day: "DESC").limit(6).reverse
    @dayline = Array.new
    @graphdays.each do |graphday|
      @dayline.push(graphday.sport_day.strftime('%m/%d').to_s)
    end
    @graphtimes =  @user.sports.order(sport_day: "DESC").limit(6).reverse
    @timeline = Array.new
    @graphtimes.each do |graphtime|
      @timeline.push(graphtime.sport_time)
    end
  end

  def edit
  end

  def show
  end

  def new
  end
end
