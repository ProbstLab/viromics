#!/usr/bin/ruby -w
require "trollop"
require "nu"

opts=Trollop::options do
    banner <<-EOS

Counts the number reads per position of a scaffold from a sam file. Unmapped reads should have been removed (e.g. by using 'shrinksam' or 'mapped.py'). Only one scaffold per mapping is allowed.
Writes to standard out in tab-delimited fashion. Column 1 = Position, Column 2 = Coverage.

Usage:
        ruby calc_cov_pos.rb [option] > output.txt
where [options] are:
EOS
 	opt :sam, "sam file", :type => :string, :required => true
end

s_file=opts[:sam]

len=0
#get length of scaffold
File.open(s_file).each do |line|
	line.chomp!
	if line.start_with? '@SQ'
		len=line.split("\t")[2].gsub(/LN:/,'').to_i
	end
end

#create hash for nulceotides of scaffold
cov=Hash.new
for i in 0..len-1
	cov[i]=(0).to_i
end

# collect bases per position covered
File.open(s_file).each do |line|
        line.chomp!
        next if line.start_with? '@'
        start = line.split("\t")[3].to_i-1
	ende = start + line.split("\t")[9].length.to_i
	if ende > len-1
		ende = len-1
	end	
	for j in start..ende
		cov[j]=cov[j]+1
	end
end

cov.each do | pos, count|
	puts "#{pos+1}\t#{count}"
end
