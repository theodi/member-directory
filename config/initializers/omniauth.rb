# Set the `full_host` value in production so that we
# are correctly redirected back to the site after
# authenticating with Google's OAuth
if Rails.env.production?
  OmniAuth.config.full_host = "https://directory.theodi.org"
end

