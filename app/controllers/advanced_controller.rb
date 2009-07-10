class AdvancedController < ApplicationController

  def index
    @program = nil
	if params[:id]
		@program = Program.find(params[:id])
	else
		flash.now[:error] = "Please specify program id"
	end
  end

  def tweet
    if (!params[:program_id].nil? && program = Program.find(params[:program_id]))
		begin
			httpauth = Twitter::HTTPAuth.new('NDSTI', "samara#78")
			base = Twitter::Base.new(httpauth)
			base.update("I am watching very interesting program '#{program.name}'")
			falsh[:notice] = "Twitter updated successfuly!"
		rescue
			flash[:error] = "Error updating Twitter!"
		end
	else
		flash[:error] = "Please specify program id to Tweet"
	end
    redirect_to :back
  end

end
