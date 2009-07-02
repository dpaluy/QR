class AuthorizeController < ApplicationController

  def index
    redirect_to :action => :new
  end

  def new
	program_id = params[:id]
	key = params[:key]
		
	if (program_id && key)
		program = Program.find(program_id)
		unless program.nil?
			if program.key == key
				program.enable = true
				if program.save!
					flash[:notice] = "Thank you for purchasing #{program.name}"
					redirect_to :action => :thanks
				else
					flash[:error] = "Error enabling the program #{program.name}. Try again!"
				end
			else
				flash[:error] = "Wrong Key"
			end
		else
			flash[:error] = "Unrecognized program"
		end
	else
		flash[:error] = "Please provide authorization paramters"
	end
  end

  def thanks
  end

end
