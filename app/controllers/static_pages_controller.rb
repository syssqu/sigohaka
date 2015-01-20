class StaticPagesController < ApplicationController
  
  before_action :authenticate_user!
  
  def home
    @time_lines = current_user.time_lines.order("created_at DESC")
  end

  def help
  end

  def about
  end
end
