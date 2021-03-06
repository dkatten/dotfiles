Pry.config.theme = 'solarized'
  
prompt = "ruby-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
Pry.config.prompt = [
proc { |obj, nest_level, _| "#{prompt} (#{obj}):#{nest_level} > " },
     proc { |obj, nest_level, _| "#{prompt} (#{obj}):#{nest_level} * " }
     ]

# Default Command Set, add custom methods here:
     default_command_set = Pry::CommandSet.new do
     command 'copy', 'Copy to clipboard' do |str|
     str = "#{_pry_.input_array[-1]}#=> #{_pry_.last_result}\n" unless str
     IO.popen('pbcopy', 'r+') { |io| io.puts str }
     output.puts "-- Copy to clipboard --\n#{str}"
     end
     end

# https://github.com/michaeldv/awesome_print/
# $ gem install awesome_print
     begin
     require 'awesome_print'
     Pry.config.print = proc { |output, value| output.puts value.ai(:indent => 2) }
     rescue LoadError => e
     warn "[WARN] #{e}"
     puts '$ gem install awesome_print'
     end

# Launch Pry with access to the entire Rails stack.
  rails = File.join(Dir.getwd, 'config', 'environment.rb')
  if File.exist?(rails) && ENV['SKIP_RAILS'].nil?
  require rails
  case Rails.version.to_i
  when 2
  require 'console_app'
  require 'console_with_helpers'
  when 3
  require 'rails/console/app'
  require 'rails/console/helpers'
  extend Rails::ConsoleMethods if Rails.version.to_f >= 3.2
  else
  warn '[WARN] cannot load Rails console commands'
  end
  end

Pry.config.commands.import(default_command_set)
