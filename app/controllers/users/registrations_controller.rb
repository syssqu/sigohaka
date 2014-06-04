class Users::RegistrationsController < Devise::RegistrationsController
  def cancel
    super
  end
 
  def create
    super
  end
 
  def destroy
    super
  end

  def new
    super
    # @sections = Section.all.sort_by{|e| e[:name]}
  end

  def edit
    super
  end

  def update
    super
  end
end
