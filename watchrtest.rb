# # run specs when they change
# watch('spec/.*/.*\.rb') do |match|
#   exec = "rspec -c #{match[0]}"
#   puts exec
#   system(exec)
# end
# 
# # run corresponding specs for tetris libs
# watch('lib/tetris/(.*)\.rb') do |match| 
#   exec = "rspec -c spec/models/#{match[1]}_spec.rb"
#   puts exec
#   system(exec)
# end

# watch tests tagged "current"
watch('.*') do |match|
  exec = "rspec --tag current -c spec"
  puts exec
  system(exec)
end

# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  system("rspec -c spec")
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }