# frozen_string_literal: true

# generate update command
class UpdateCommand < InstallCommand
  def gen(params)
    name = params[0]

    if File.exist?("#{ENV['HOME']}/.crun/apps/#{name}")
      super(params)
    else
      gen_not_installed(name)
    end
  end

  def gen_not_installed(name)
    prog = Program.new(name)
    if prog.exist?
      puts "echo The app '#{name}' is not installed"
      puts "echo Install it using 'crun -i #{name}'"
    else
      puts "echo The app '#{name}' does not exist"
    end
  end
end
