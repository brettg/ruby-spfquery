require 'stringio'
require 'open3'

class Spfquery
  attr_reader :ip, :sender, :helo

  def self.pass?(*args)
    new(*args).pass?
  end

  def initialize(ip, sender, helo=nil)
    @ip = clean(ip)
    @sender = clean(sender)
    @helo = helo
  end

  def clean(str)
    str.gsub(/;.*/, '')
  end

  def pass?
    'pass' == result
  end

  def result
    @result ||= begin
                  if line = output.lines.first
                    line.chomp.downcase
                  else
                    'none'
                  end
                end
  end

  private

  def output
    @output ||= run_spfquery
  end

  def run_spfquery
    args = ['spfquery', "--ip=#{ip}", "--mfrom=#{sender}"]
    args << "--helo=#{helo}"  if helo
    Open3.popen3(*args) do |stdin, stdout, stderr, wait_thr|
      stdout.read
    end
  end
end
