require 'rack/test'
require 'rack/logs'

describe 'accessing an individual log', type: :integration do
  include Rack::Test::Methods

  let(:app) do
    log_dir = support_path('fixtures/log')
    Rack::Builder.app do
      logs = Rack::Logs.configure do |config|
        config.log_dir = log_dir
      end
      run logs
    end
  end

  before do
    get '/my_log_file.log'
  end

  example 'returns a 200 response code' do
    expect(last_response).to be_ok
  end

  example 'accessing the log returns only the specific log contents' do
    expect(last_response.body).to     match 'LOG ENTRY 1234'
    expect(last_response.body).to_not match 'LOG ENTRY 5678'
  end

  example 'cross path traversal is prevented' do
    get "/../tmp/secret_file.txt"
    expect(last_response.status).to be 404
  end
end
