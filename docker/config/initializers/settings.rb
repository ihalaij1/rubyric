# sets the upload root, relative to the RAILS_ROOT
SUBMISSIONS_PATH = "/data/rubyric/submissions"
FEEDBACK_PATH = "/data/rubyric/feedback"
PDF_CACHE_PATH = "/data/rubyric/pdf_cache"
TMP_PATH = "/tmp"

# Where to send error reports. Set to nil to disable.
ERRORS_EMAIL = "admin@rubyric.local"

# Sender address of invitation mails, etc.
RUBYRIC_EMAIL = "rubyric@rubyric.local"

# Host is used for links in emails
RUBYRIC_HOST = "rubyric"

# Redirect to SSL
FORCE_SSL = false

THUMBNAIL_MAX_WIDTH = 256
THUMBNAIL_MAX_HEIGHT = 256
THUMBNAIL_DEFAULT_SIZE = 128

ACCEPTED_EMAIL_SOURCES = ['localhost', '127.0.0.1']

def get_aplus_ip_addresses(domain)
  require "resolv"
  plus_ip = Resolv.getaddress(domain)
  ips = ['127.0.0.1']
  if !plus_ip.empty?
    ips.push(plus_ip)
  end
  ips
end

# In the Docker Compose local setup, the A+ (frontend server) container
# should have the (internal) domain name "plus".
APLUS_IP_WHITELIST = get_aplus_ip_addresses("plus")

# Uncomment to execute delayed jobs immediately, instead of in a background process
# Delayed::Worker.delay_jobs = false

# ActionMailer::Base.smtp_settings = {
#   address: 'localhost'
#   enable_starttls_auto: false
# }

OAUTH_CREDS = {"foo" => "bar", "rubyric" => "rubyric", "test" => "secret", "testing" => "supersecret"}
