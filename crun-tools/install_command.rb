# frozen_string_literal: true

# generate install command
class InstallCommand
  def gen(params)
    prog = Program.new(params[0])

    if params[0] == 'crun'
      puts install_crun

    elsif prog.exist?
      puts install_prog(prog)

    else
      puts "echo App not found: '#{prog.name}'"
    end
  end

  def install_prog(prog)
    <<~INSTALLER
      cat <<PROGRAM > #{prog.name}
        #{prog.launch_command([])}
      PROGRAM

      #{install_message(prog.name, prog.version)}
    INSTALLER
  end

  def install_crun
    <<~INSTALLER
      cat <<PROGRAM > crun
        #{File.read('/data/crun.sh').gsub('\\', '\\\\').gsub('$', '\$')}
      PROGRAM

      #{install_message('crun', current_version)}
    INSTALLER
  end

  def current_version
    File.read('/data/VERSION').chomp
  end

  def install_message(name, version)
    <<~COMMAND
      chmod +x #{name}
      mkdir -p $HOME/.crun/apps
      mkdir -p $HOME/.crun/versions
      echo #{version} > $HOME/.crun/versions/#{name}

      if [[ ":$PATH:" == *":$HOME/.crun/apps:"* ]]; then
        CLI="#{name}"
        cp #{name} $HOME/.crun/apps/#{name}-#{version}
        mv #{name} $HOME/.crun/apps
        echo '#{name}' version #{version} has been installed!
      else
        echo "Your \\$PATH is missing ~/.crun/apps."
        echo "To be able to install crun apps"
        echo "add the following line to ~/.profile:"
        echo ""
        echo "  export PATH=\\"\\$HOME/.crun/apps:\\$PATH\\"" # Add crun app path
        echo ""
        echo '#{name}' version #{version} has been placed
        echo in your current directory. If you wish to use it globally
        echo as this user, follow the above instructions.
        echo ""
        CLI="./#{name}"
      fi

      echo "To run, type"
      echo ""
      echo "  $CLI"
      echo ""
    COMMAND
  end
end
