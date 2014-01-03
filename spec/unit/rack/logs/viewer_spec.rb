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
    let(:contents) { response[2].inject("") { |contents, fragment| contents + fragment } }

    before do
      FakeFS.activate!
      FileUtils.mkdir_p('./tmp')
      File.open('./tmp/not_log.txt','w') { |file| file.write 'Nothing to see here' }
      File.open('./tmp/my_log.doge','w') do |file|
        file.write "Ignored"
        4.times do
          file.write $/
        end
        file.write "Much log, such information"
      end
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
      expect(contents).to match "## tmp/my_log\.doge\n\n"
      expect(contents).to match "Much log, such information"
    end
    it 'limits itself to the last n lines' do
      expect(contents).to_not match "Ignored"
    end
  end
end
