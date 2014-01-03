require 'rack/test'
require 'rack/logs'

describe 'running `Rack::Logs` via `Rack::Builder`', type: :integration do
  include Rack::Test::Methods

  context 'running with defaults' do
    let(:app) { Rack::Builder.app { run Rack::Logs } }

    before { get '/' }

    example 'returns a 200 response code' do
      expect(last_response).to be_ok
    end
    example 'returns no logs because there are no files' do
      expect(last_response.body).to eq ''
    end
  end

  context 'given a log in a configured directory' do
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
      get '/'
    end

    example 'returns a 200 response code' do
      expect(last_response).to be_ok
    end

    example 'accessing the log returns log contents' do
      expect(last_response.body).to match 'LOG ENTRY 1234'
    end
  end
end
