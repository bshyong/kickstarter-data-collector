gem 'kickstarter', :git => 'git@github.com:likeachild/kickstarter.git'
require 'kickstarter'
require 'csv'

class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end

while($filename.nil?)
  puts "Enter a filename, no extension needed (output will be stored as a CSV)"
  $filename = gets.chomp!
end

while($category.nil?)
  puts "Which category are you interested in?"
  Kickstarter::Categories.to_a.each_with_index do |c, i|
    puts "#{i} - #{c[1]}"
  end
  $category = gets.chomp!
  if $category.is_i?
    $category = Kickstarter::Categories.to_a[$category.to_i][0]
  else
    puts "You must enter an Integer!  Try again."
    $category = nil
  end
end

while($type.nil?)
  puts "Which type are you interested in?"
  Kickstarter::Type.to_a.each_with_index do |c, i|
    puts "#{i} - #{c[1]}"
  end
  $type = gets.chomp!
  if $type.is_i?
    $type = Kickstarter::Type.to_a[$type.to_i][0]
  else
    puts "You must enter an Integer!  Try again."
    $type = nil
  end
end

output = File.new("#{$filename}.csv", "a+")

starting_page = 1
count = 0
output.puts(CSV.generate_line(["Name", "Description", "Pledge amount", "Pledge goal", "Pledge Percentage", "Project URL"]))

while true
  projects = Kickstarter.by_category($category, :page => starting_page, :type => $type)
  break if projects.length == 0
  projects.each do |p|
    count +=1
    puts "processing... #{p.name}"
    output.puts(CSV.generate_line([p.name, p.description.gsub(/\s+/, ' ').strip, p.pledge_amount, p.pledge_amount/(p.pledge_percent/100),p.pledge_percent, p.url]))
  end
  starting_page += 1
end

puts "#{count} projects collected"
output.close