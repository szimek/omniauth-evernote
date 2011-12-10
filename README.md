# Omniauth Evernote

This is OmniAuth strategy for authenticating to Evernote.

## Usage

By default the strategy uses `http://www.evernote.com` site. In development you'll want to use `https://sandbox.evernote.com` instead. To do it you'll
need to pass `site` option:

```ruby
use OmniAuth::Builder do
 provider :evernote, ENV['EVERNOTE_KEY'], ENV['EVERNOTE_SECRET'], :client_options => { :site => 'https://sandbox.evernote.com' }
end
```