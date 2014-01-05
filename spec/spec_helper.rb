# required by .rspec

module Support
  def support_path path
    File.join File.expand_path('../support', __FILE__), path
  end
end

RSpec.configure do |c|
  c.include Support
end
