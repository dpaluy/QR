class AdvancedController < ApplicationController

  def index
    @program = nil
	if params[:id]
		@program = Program.find(params[:id])
		flash[:notice] = "You are watching #{@program.name}" unless @program.nil?
	else
		flash[:error] = "Please specify program id"
	end
  end

  def tweet
  end

end
