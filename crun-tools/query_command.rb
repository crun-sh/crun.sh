# frozen_string_literal: true

# generate query command
class QueryCommand
  def gen(params)
    name = params[0]
    prog = Program.new(name)
    if prog.exist?
      puts "echo #{name} versions available:"
      prog.versions.each do |x|
        if x == prog.latest_version
          puts "echo #{x} \\<- latest"
        else
          puts "echo #{x}"
        end
      end
    else
      puts "echo The app #{name} does not exist"
    end
  end
end
