module ProgramsHelper
	def highlight(status)
		if status
			return "GREEN"
		else
			return "RED"
		end
    end
end
