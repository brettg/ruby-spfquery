require 'stringio'
require 'open3'

class Spfquery
  attr_reader :ip, :sender, :helo

  def self.pass?(*args)
    new(*args).pass?
  end

  def initialize(ip, sender, helo=nil)
    @ip = ip
    @sender = sender
    @helo = helo
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
    args = ['spfquery', "--ip=#{ip}", "--sender=#{sender}"]
    args << "--helo=#{helo}"  if helo
    Open3.popen3(*args) do |stdin, stdout, stderr, wait_thr|
      stdout.read
    end
  end
end
