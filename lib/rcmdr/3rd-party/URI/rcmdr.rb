# frozen_string_literal: true

# https://rubyapi.org/3.1/o/uri
module URI
  # This allows URI to recognize our rcmdr scheme when forumating
  # paths that include the rcmdr "protocol", for example:
  # rcmdr://<app domain>/<path 1>/<path 2>/etc.
  class RCMDR < Generic
    DEFAULT_PORT = 0
  end
  register_scheme 'RCMDR', RCMDR
end
