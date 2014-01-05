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
    let(:contents) { response[2].inject("") { |contents, fragment| contents + fragment } }

    shared_examples_for "a rack logs response" do
      it 'returns a rack response' do
        expect(response[0]).to be_a Fixnum
        expect(response[1]).to be_a Hash
        expect(response[1].keys).to include 'Content-Type'
        expect(response[2].respond_to? :each).to be true
      end

      it 'limits itself to the last n lines' do
        expect(contents).to_not match "Ignored"
      end
    end

    context "for all files" do
      let(:response) { viewer.call({}) }

      it_should_behave_like "a rack logs response"

      it 'returns the contents of all the logs' do
        expect(contents).to match "log/my_log\.doge\n\n"
        expect(contents).to match "Much log, such information"
        expect(contents).to match "log/other_log\.doge\n\n"
        expect(contents).to match "Other log, such information"
      end
    end

    context "for a file" do
      let(:response) { viewer.call({ 'PATH_INFO' => '/my_log.doge' }) }

      it_should_behave_like "a rack logs response"

      it 'returns the contents the specific log' do
        expect(contents).to match "log/my_log\.doge\n\n"
        expect(contents).to match "Much log, such information"
      end
      it 'ignores other contents' do
        expect(contents).to_not match "log/other_log\.doge\n\n"
        expect(contents).to_not match "Other log, such information"
      end
    end

    context "for a forbidden file" do
      let(:response) { viewer.call({ 'PATH_INFO' => '/../tmp/secret_file.txt' }) }

      it 'returns a 404 rack response' do
        expect(response[0]).to eq 404
        expect(response[1]).to be_a Hash
        expect(response[1].keys).to include 'Content-Type'
        expect(response[2]).to eq ['No Such File']
      end
    end
  end
end
