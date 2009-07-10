class AdvancedController < ApplicationController

  def index
    @program = nil
	if params[:id]
		@program = Program.find(params[:id])
	else
		flash.now[:error] = "Please specify program id"
	end
  end

end
