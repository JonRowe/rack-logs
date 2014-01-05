require 'rack/test'
require 'rack/logs'

describe 'accessing an individual log', type: :integration do
  include Rack::Test::Methods

  let(:app) do
    Rack::Builder.app do
      logs = Rack::Logs.configure do |config|
        config.log_dir = './tmp'
      end
      run logs
    end
  end

  before do
    File.open('./tmp/my_log_file.log','w') do |f|
      f.write "LOG ENTRY 1234"
    end
    File.open('./tmp/other_file.log','w') do |f|
      f.write "LOG ENTRY 5678"
    end
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
