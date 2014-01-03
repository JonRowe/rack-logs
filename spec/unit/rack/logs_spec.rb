require 'rack/logs'

describe 'Rack::Logs' do
  before do
    stub_const "Rack::Logs::Config", Class.new
    stub_const "Rack::Logs::Viewer", (Class.new do
      def initialize config
        @config = config
      end
      attr_reader :config
    end)
  end

  describe '.configure' do
    let(:viewer) { Rack::Logs.configure { } }

    it 'takes a block that yields configuration' do
      config = nil
      Rack::Logs.configure { |object| config = object }
      expect(config).to be_a Rack::Logs::Config
    end
    it 'creates a Rack::Logs::Viewer with the config' do
      expect(viewer.config).to be_an_instance_of Rack::Logs::Config
    end
    it 'returns a Rack::Logs::Viewer' do
      expect(viewer).to be_a Rack::Logs::Viewer
    end
  end

  describe '.call' do
    let(:viewer_response) { double }
    let(:viewer) { instance_double "Rack::Logs::Viewer" }
    let(:env) { double }

    before do
      allow(Rack::Logs::Viewer).to receive(:new).and_return(viewer)
      allow(viewer).to receive(:call).and_return(viewer_response)
    end

    it 'creates a default Rack::Logs::Config' do
      expect(Rack::Logs::Config).to receive(:new).once
      Rack::Logs.call env
    end
    it 'creates a Rack::Logs::Viewer' do
      expect(Rack::Logs::Viewer).to receive(:new).once
      Rack::Logs.call env
    end
    it 'delegates to Rack::Logs::Viewer' do
      expect(viewer).to receive(:call).with env
      expect(Rack::Logs.call env).to eq viewer_response
    end
  end
end
