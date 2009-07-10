class TweetController < ApplicationController
  
  before_filter :login_required

  def index
  end

  def update
	if params[:msg].nil? 
		program = Program.find(params[:program_id])
		message = "I am watching cool program '#{program.name}'"	
	else
		message = params[:msg]
	end
    @tweet = current_user.twitter.post('/statuses/update.json', :status => message) 
	if 	@tweet.nil?
		flash[:error] = "Error updating Twitter!"
	else
		flash[:notice] = "Tweeting successfully:\n #{@tweet.text}"
	end
	redirect_back_or_default "/advanced"
  end

end
