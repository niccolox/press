defmodule Cache do
  @moduledoc"""
  def initialize address
    @base = address
  end

  attr_reader :base

  def sub address
    Cache.new File.join(base, address)
  end

  def node address
    File.join base, address
  end

  def scan query='*'
    Dir.glob node query
  end

  def place address
    File.dirname node address
  end

  def has address
    File.exist? node address
  end

  def prepare address=''
    # puts "Preparing #{nil #address
    }; making #{nil #place address
    }" unless File.exists? place address
    FileUtils.mkdir_p place address unless File.exist? place address
  end

  def make address, opcions=nil
    if has address
      read address
    else
      prepare address
      yield.tap {|blob|
        n = opcions.nil? ?
          File.new(node(address), 'w') :
          File.new(node(address), opcions)
        n.write blob
      }
    end
  end

  def read address
    File.read node address
  rescue => e
    puts e
    nil
  end

  def check address
    unless has address
      prepare address
      yield
    end
  end
  """
end
