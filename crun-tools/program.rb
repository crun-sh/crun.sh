# frozen_string_literal: true

require 'yaml'
require 'open-uri'

# General tools
class Program
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def image
    metadata['image']
  end

  def metadata
    @metadata ||= YAML.safe_load(raw_metadata)
  end

  def launch_command(params)
    <<~COMMAND
      if [[ "$(docker images -q #{image} 2> /dev/null)" == "" ]]; then
        NEW_IMAGE=yes
        docker pull #{image} 2>&1 1>/dev/null
      fi

      docker run --rm #{image} #{params.join(' ')}

      if [ -n "$NEW_IMAGE" ]; then
        docker rmi #{image} 2>&1 1>/dev/null
      fi
    COMMAND
  end

  def exist?
    !raw_metadata.nil?
  end

  def raw_metadata
    @raw_metadata ||= read_metadata
  end

  def read_metadata
    root = 'https://raw.githubusercontent.com/crun-sh/library/master'

    begin
      URI.parse("#{root}/apps/#{@name}/info.yml").open do |f|
        return f.read
      end
    rescue OpenURI::HTTPError => _e
      nil
    end
  end
end
