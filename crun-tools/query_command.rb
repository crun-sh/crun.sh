# frozen_string_literal: true

# generate query command
class QueryCommand
  def gen(params)
    name = params[0]
    prog = Program.new(name)
    if prog.exist?
      puts "echo #{name} versions available:"
      prog.versions.each do |ver|
        puts gen_display(prog, ver)
      end
    else
      puts "echo The app #{name} does not exist"
    end
  end

  def gen_display(prog, ver)
    latest = ''
    latest = ' <- latest' if ver == prog.latest_version
    <<~DISPLAY
      printf "#{ver}#{latest}"

      if [ -f $HOME/.crun/versions/#{prog.name} ]; then
        if [ "#{ver}" == $(cat $HOME/.crun/versions/#{prog.name}) ]
          then
            printf " <- installed"
        fi
      fi
      echo
    DISPLAY
  end
end
