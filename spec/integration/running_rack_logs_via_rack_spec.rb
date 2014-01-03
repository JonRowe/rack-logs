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
end
