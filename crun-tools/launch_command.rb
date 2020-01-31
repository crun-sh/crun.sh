# frozen_string_literal: true

# generate launch command
class LaunchCommand
  def gen(params)
    prog = Program.new(params[0])
    if prog.exist?
      puts prog.single_launch_command(params[1..-1])
    else
      puts "echo App not found: '#{prog.name}'"
    end
  end
end
