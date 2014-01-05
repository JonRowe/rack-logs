require 'rack/logs/viewer'

describe 'Rack::Logs::Viewer' do
  let(:config) do
    instance_double "Rack::Logs::Config", lines: 5, pattern: '*.doge',
      log_dir: support_path('fixtures/log')
  end

  describe '#initialize' do
    it 'takes a configuration' do
      Rack::Logs::Viewer.new config
    end
  end

  describe '#call env' do
    let(:viewer)   { Rack::Logs::Viewer.new config }
    let(:response) { viewer.call({}) }
    let(:contents) { response[2].inject("") { |contents, fragment| contents + fragment } }

    it 'returns a rack response' do
      expect(response[0]).to be_a Fixnum
      expect(response[1]).to be_a Hash
      expect(response[1].keys).to include 'Content-Type'
      expect(response[2].respond_to? :each).to be true
    end
    it 'returns the contents of the logs' do
      expect(contents).to match "log/my_log\.doge\n\n"
      expect(contents).to match "Much log, such information"
    end
    it 'limits itself to the last n lines' do
      expect(contents).to_not match "Ignored"
    end
  end
end
