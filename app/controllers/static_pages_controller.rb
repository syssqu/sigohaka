class StaticPagesController < ApplicationController
  
  before_action :authenticate_user!
  
  def home
    @time_lines = current_user.time_lines
  end

  def help
  end

  def about
  end
end
