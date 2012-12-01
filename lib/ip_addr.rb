class IpAddr
  def self.str2int string_ip
    string_ip.split('.').collect(&:to_i).pack('C*').unpack('N').first
  end

  def self.int2str int_ip
    tmp = int_ip.to_i
    parts = []

    3.times do |i|
      tmp = tmp / 256.0
      parts << (256 * (tmp - tmp.to_i)).to_i
    end

    parts << tmp.to_i
    parts.reverse.join('.')
  end

  def self.to_int ip
    if ip.kind_of?(String)
      str2int(ip)
    elsif ip.kind_of?(Fixnum)
      ip
    end
  end
end
