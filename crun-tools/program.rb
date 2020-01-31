# frozen_string_literal: true

require 'yaml'
require 'open-uri'

# General tools
class Program
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def latest_version
    versions.max
  end

  def version
    latest_version
  end

  def versions
    metadata['versions'].keys
  end

  def image
    metadata['versions'][latest_version]['image']
  end

  def metadata
    @metadata ||= YAML.safe_load(raw_metadata)
  end

  def requires_term?
    metadata['require']&.is_a?(Array) &&
      metadata['require']&.include?('terminal')
  end

  def launch_command(params)
    term = ''
    term = '-ti' if requires_term?

    <<~COMMAND
      docker run --rm #{term} #{image} #{params.join(' ')}
    COMMAND
  end

  def single_launch_command(params)
    <<~COMMAND
      if [[ "$(docker images -q #{image} 2> /dev/null)" == "" ]]; then
        NEW_IMAGE=yes
        docker pull #{image} 2>&1 1>/dev/null
      fi

      #{launch_command(params)}

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
