

module RyanFunctions

def password?
  redirect to('/') if session[:access_token_google] == nil
end

end
