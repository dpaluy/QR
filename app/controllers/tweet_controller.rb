class TweetController < ApplicationController
  
  before_filter :login_required

  def index
	store_location
  end

  def update
	if params[:msg].nil? 
		program = Program.find(params[:program_id])
		message = "I am watching a great program: '#{program.name}'"	
	else
		message = params[:msg]
	end
    @tweet = current_user.twitter.post('/statuses/update.json', :status => message) 
	if 	@tweet.nil?
		flash[:error] = "Error updating Twitter!"
	else
		flash[:notice] = "Twitter updated successfully: #{message}"
	end
	back_addr = (params[:program_id].blank?)? "/" : "adv/#{params[:program_id]}"
	redirect_back_or_default back_addr
  end

end
