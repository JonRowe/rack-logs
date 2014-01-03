require 'rack/logs/config'

describe 'Rack::Logs::Config' do
  let(:config) { Rack::Logs::Config.new }

  describe '#log_dir' do
    it 'defaults to *.log' do
      expect(config.log_dir).to eq './log'
    end
    it 'is configurable' do
      config.log_dir = './tmp'
      expect(config.log_dir).to eq './tmp'
    end
  end

  describe '#pattern' do
    it 'defaults to *.log' do
      expect(config.pattern).to eq '*.log'
    end
    it 'is configurable' do
      config.pattern = '*.doge'
      expect(config.pattern).to eq '*.doge'
    end
  end

  describe '#lines' do
    it 'defaults to 200' do
      expect(config.lines).to eq 200
    end
    it 'is configurable' do
      config.lines = 300
      expect(config.lines).to eq 300
    end
  end
end
