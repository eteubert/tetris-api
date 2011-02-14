# watch all tests
watch('.*') do |match|
  system("rspec -c spec")
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }