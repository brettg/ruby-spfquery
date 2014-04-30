require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/spfquery'

# Will change if outlook.com's SPF DNS record changes.
VALID_OUTLOOK_IP = '65.54.190.100'

describe Spfquery do
  describe 'being created' do
    it 'accepts an ip and a sender' do
      ip = '1.1.1.1'
      sender = 'abc@example.org'
      sq = Spfquery.new(ip, sender)
      sq.ip.must_equal(ip)
      sq.sender.must_equal(sender)
    end
    it 'optionallys also accepts a helo' do
      helo = 'abc.example.org'
      sq = Spfquery.new('', '', helo)
      sq.helo.must_equal(helo)
    end
  end

  describe '.pass?' do
    it 'should create an instance and return true if it is a pass' do
      Spfquery.pass?('1.1.1.1', 'abc@probably-wont-have-spf.org').must_equal false
      Spfquery.pass?(VALID_OUTLOOK_IP, 'abc@example.org', 'outlook.com').must_equal true
    end
  end

  describe '#result' do
    it 'handles none' do
      Spfquery.new('1.1.1.1', 'abc@probably-wont-have-spf.org').result.must_equal 'none'
    end
    it 'handles softfail' do
      Spfquery.new('1.1.1.1', 'abc@gmail.com').result.must_equal 'softfail'
    end
    it 'handles fail' do
      Spfquery.new('1.1.1.1', 'abc@example.org').result.must_equal 'fail'
    end
    it 'handles pass' do
      Spfquery.new(VALID_OUTLOOK_IP, 'abc@outlook.com').result.must_equal 'pass'
      Spfquery.new(VALID_OUTLOOK_IP, 'abc@example.org', 'outlook.com').result.must_equal 'pass'
    end

    it 'should not allow shell injection' do
      Spfquery.new(';say "this cannot be good";', 'abc').result.must_equal 'none'
      Spfquery.new('1.1.1.1', ';echo pass').result.must_equal 'none'
    end
  end

  describe '#pass?' do
    %w{neutral fail none something}.each do |non_pass|
      it "should be false for #{non_pass} result" do
        sq = Spfquery.new('', '')
        sq.instance_eval { @output = non_pass }
        sq.pass?.must_equal false
      end
    end
    it 'should be false for a pass result' do
      sq = Spfquery.new('', '')
      sq.instance_eval { @output = 'pass' }
      sq.pass?.must_equal true
    end
  end
end


