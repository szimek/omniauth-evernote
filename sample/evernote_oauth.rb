require 'rubygems'
require 'sinatra'
require 'json'
require 'omniauth'
require 'omniauth-evernote'

class SinatraApp < Sinatra::Base
  configure do
    set :sessions, true
    set :inline_templates, true
  end
  use OmniAuth::Builder do
    provider :evernote, 'Your API Key', 'Your Consumer Secret'
  end

  get '/' do
    erb "<h1>Login with evernote</h1><a href='/auth/evernote' class='btn btn-primary'>Login</a>"
  end

  get '/auth/:provider/callback' do
    erb "<h1>#{params[:provider]}</h1>
         <pre>#{JSON.pretty_generate(request.env['omniauth.auth'])}</pre>
	 <a href='/logout' class='btn'>Logout</a>"
  end

  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>
	 <a href='/' class='btn'>Start over</a>"
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end

SinatraApp.run! if __FILE__ == $0

__END__

@@ layout
<html>
  <head>
    <link href='http://twitter.github.com/bootstrap/assets/css/bootstrap.css' rel='stylesheet' />
  </head>
  <body>
    <div class='container'>
      <div class='content'>
        <%= yield %>
      </div>
    </div>
  </body>
</html>
