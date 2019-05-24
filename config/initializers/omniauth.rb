Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "688628925276-vllebn9f6dd280tomj4aa9sv03p49opa.apps.googleusercontent.com", "SJY16I82GbofvUcqdquURGgJ", {
    name: 'google',
    scope: 'email, profile, plus.me, http://gdata.youtube.com',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 50
  }
end