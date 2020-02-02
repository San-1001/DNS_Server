def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

def resolve(dns_records, lookup_chain, domain)
    if !dns_records[domain]
      lookup_chain+=["The domain name does not exist"]
    elsif dns_records[domain].key?("CNAME")
      lookup_chain+=[dns_records[domain]["CNAME"]]
      lookup_chain=resolve(dns_records, lookup_chain, dns_records[domain]["CNAME"])
    else
        lookup_chain += [dns_records[domain]["A"]]
        lookup_chain
    end
end
def parse_dns(dns_raw)
  domains={}
  dns_raw.each do |y|
    if y[0]!='#' && !(y.empty?)
        splitArr=y.strip.split(", ")
        domains[splitArr[1]] = { splitArr[0] => splitArr[2] }
    end
  end
  domains
end


# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
