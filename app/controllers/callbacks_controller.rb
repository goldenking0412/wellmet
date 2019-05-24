class CallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = @user.id
    old_user = User.where(id: @user.id,provider: @user.provider,uid: @user.uid,policy: "true").last
    if old_user
      sign_in_and_redirect @user
    else
      sign_in :user, @user
      redirect_to "#!/users/#{session[:user_id]}", event: :authentication
    end
  end

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = @user.id
    old_user = User.where(id: @user.id,provider: @user.provider,uid: @user.uid,policy: "true").last
    p old_user
    if old_user
      sign_in_and_redirect @user
    else
      sign_in :user, @user
      redirect_to "#!/users/#{session[:user_id]}", event: :authentication
    end
  end
end
