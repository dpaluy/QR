class ProgramsController < ResourceController::Base

	def show
		@program = Program.find(params[:id])

		respond_to do |format|
                format.html  # do nothing, allow Rails to render index.rhtml
                format.xml   { render :xml => @program.to_xml }
        end
	end
end
