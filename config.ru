require File.join(File.dirname(__FILE__), 'lib/lib')

use Rack::Static,
    :urls => ["/assets"],
    :root => "public"

use Gorilla::SocketBackend
run Gorilla::App