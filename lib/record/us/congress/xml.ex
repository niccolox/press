defmodule Record.US.Congress.XML do
  @moduledoc"""
  require "processor/congress"
  require "record/us/congress"
  record = Record::US::Congress.load_place('118hr1'); nil
  processed = Processor::Congress.parse record.copy; nil
  puts processed.measures(:item).map(&:combine).join("\n\n")

  require 'measure'

  module Processor
    module Congress
      class XML
        attr_reader :source, :xml

        def initialize source, xml=nil
          @source = source
          @xml = xml || Nokogiri::XML(source)
        end

        def self.process_node(markers, &proc)
          @@processors ||= {}
          Array(markers).each {|marker| @@processors[marker] = proc }
        end

        def process
          path_cache = {}
          xml.traverse {|node| path_cache[node.path] = node }
          order = path_cache.keys.sort.reverse - ['?']

          measure_lookup = {}
          order.each do |path|
            node = path_cache.fetch(path)

            begin
              next if node.path == '/'
              procedure = @@processors[node.name]
              procedure ||= @@processors[nil] unless recognized_measures.include? node.name
              procedure.(node, path, self) and next if procedure
              next unless recognized_measures.include? node.name

              measure = process_measure(node, path)
              submeasures = node.text.scan(/\{place +\"([^\"]+)\"\}/).flatten
              submeasures.each { |sm_key| measure.add_submeasure(measure_lookup[sm_key]) }
              node.replace("{place \""+measure.key+"\"}") unless node.name == self.primary_node
              measure_lookup[measure.key] ||= measure if measure.class == Measure
            rescue => e
              binding.pry
            end
          end
          measure_lookup['/' + self.primary_node]
        end

        private

        def primary_node
          recognized_measures.first
        end

        def process_measure(node, path)
          label = node.search("enum")[0]
          heading = node.search("header")[0]

          label.replace('') rescue nil
          heading.replace('') rescue nil

          Measure.new(
            node.name.to_sym,
            (label.text rescue nil),
            (heading.text rescue nil),
            node.text,
            [],
            path,
          )
        end
      end
    end
  end
  """
end
