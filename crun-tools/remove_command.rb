# frozen_string_literal: true

# generate remove command
class RemoveCommand
  def gen(params)
    puts 'echo run the remove command on ' + params.join(',')
  end
end
