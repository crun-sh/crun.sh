# frozen_string_literal: true

# generate remove command
class RemoveCommand
  def gen(params)
    name = params[0]
    puts <<~UNINSTALLER
      if [[ ":$PATH:" == *":$HOME/.crun/apps:"* ]]; then
        rm -f $HOME/.crun/apps/#{name}
      else
        rm -f #{name}
      fi
      echo "Removed the app '#{name}'."
      echo "You can still run previously installed versions"
      echo "by running '#{name}-x.x.x'"
    UNINSTALLER
  end
end
