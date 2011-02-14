def growl(options = {})
  options[:name] ||= 'RubyTest'
  system("growlnotify --message \"#{options[:message]}\" --image ~/Library/#{options[:name]}/#{options[:image]}.png --name #{options[:name]}")
end

# watch tests tagged "current"
watch('.*') do |match|
  exec_string = "rspec --tag current spec"
  puts exec_string
  output = `#{exec_string}`
  puts output
  match = output.match(/(\d+)\sfailures?/)
  failures = (match) ? match[1].to_i : 0
  if failures > 0
    growl :message => "#{failures} Failures :(", :image => "fail"
  else
    growl :message => "Yeah, all green! :)", :image => "ok"
  end
end

# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  system("rspec -c spec")
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }