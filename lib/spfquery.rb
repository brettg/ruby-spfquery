require 'stringio'

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
    @result ||= output.lines.first.chomp.downcase
  end

  private

  def output
    @output ||= run_spfquery
  end

  def run_spfquery
    `spfquery --ip=#{ip} --sender=#{sender} #{" --helo=#{helo}" if helo} 2>/dev/null`
  end
end
