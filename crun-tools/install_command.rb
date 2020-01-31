# frozen_string_literal: true

# generate install command
class InstallCommand
  def gen(params)
    puts 'echo install command for ' + params.join(',')
  end
end
