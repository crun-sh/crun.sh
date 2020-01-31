# frozen_string_literal: true

require_relative 'program'
require_relative 'install_command'
require_relative 'launch_command'
require_relative 'remove_command'
require_relative 'update_command'
require_relative 'query_command'

# This program generates commands for use with crun

command = ARGV[0] || ' '
command_class = command[0].upcase + command[1..-1].downcase + 'Command'

begin
  command_class_const = instance_eval(command_class)

  params = ARGV[1..-1]

  command_class_const.new.gen(params) if defined?(command_class_const)
rescue NameError => e
  puts "echo Unknown command: '#{command}'"
  p "echo #{e}"
end
