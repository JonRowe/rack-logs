require 'fakefs/safe'
require 'rack/logs/viewer'

describe 'Rack::Logs::Viewer' do
  let(:config) { instance_double "Rack::Logs::Config", pattern: '*.doge', log_dir: './tmp', lines: 5 }

  describe '#initialize' do
    it 'takes a configuration' do
      Rack::Logs::Viewer.new config
    end
  end

  describe '#call env' do
    let(:viewer)   { Rack::Logs::Viewer.new config }
    let(:response) { viewer.call({}) }

    before do
      FakeFS.activate!
      FileUtils.mkdir_p('./tmp')
      File.open('./tmp/not_log.txt','w') { |file| file.write 'Nothing to see here' }
      File.open('./tmp/my_log.doge','w') { |file| file.write 'Much log, such information' }
    end
    after do
      FakeFS.deactivate!
    end

    it 'returns a rack response' do
      expect(response[0]).to be_a Fixnum
      expect(response[1]).to be_a Hash
      expect(response[1].keys).to include 'Content-Type'
      expect(response[2].respond_to? :each).to be true
    end
    it 'returns the contents of the logs' do
      contents = ""
      response[2].each do |fragment|
        contents << fragment
      end
      expect(contents).to match %r%## tmp/my_log\.doge\n\n.*Much log, such information%
    end
  end
end
