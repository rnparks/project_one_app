

module RyanFunctions

  def self.password?
    redirect to('/') if session[:access_token_google] == nil
  end

end

