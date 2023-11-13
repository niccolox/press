defmodule Record.US.Congress do
  @angles (~w[ index titles text summaries subjects
    relatedBills cosponsors committees amendments actions ]a
    |> Enum.reduce(%{ :text => :textVersions }, fn x, sum ->
      Map.update(sum, x, x, & &1)
    end))

  def sessions do
    (System.get_env("MEASURE_ADDRESS") <> "/session/*")
    |> Path.wildcard
    |> Enum.map(&Path.basename/1)
    |> Enum.map(&String.to_integer/1)
  end

  def bills_in session do
    (System.get_env("MEASURE_ADDRESS") <> "/session/#{session}/bill/*")
    |> Path.wildcard
    |> Enum.map(&Path.basename/1)
    |> Enum.map(& String.split(&1, "."))
    |> Enum.reduce(%{}, fn [bill, clock], sum ->
      Map.update(sum, "/session/#{session}/bill/#{bill}", clock, &(if &1 < clock, do: clock, else: &1))
    end) |> Map.to_list
    |> Enum.map(& &1 |> Tuple.to_list |> Enum.join("."))
  end

  def read record do
    @angles |> Map.keys |> Enum.map(fn angle ->
      nodes = (System.get_env("MEASURE_ADDRESS") <> record <> "/#{angle}.*.json"
      ) |> Path.wildcard |> Enum.sort

      { angle,
        nodes |> Enum.map(fn node ->
          (File.read(node) |> elem(1) |> Jason.decode! |> Map.drop(~w[request pagination]))[@angles[angle] |> Atom.to_string]
        end) |> merge
      }
    end)
  end

  defp merge([]), do: []
  defp merge([a]), do: a
  defp merge([a,b]) when is_list(a) when is_list(b), do: a ++ b
  defp merge([a,b]), do: DeepMerge.deep_merge(a, b)
  defp merge([a,b | remainder]), do: merge(List.flatten([merge([a, b])]) ++ remainder)

  @moduledoc"""
  require 'record/us/congress'
  index = nil
  index = Record::US::Congress.index_session 118, 'HR'

  require 'record/us/congress'
  record = Record::US::Congress.load_place '118hr1'; nil
  require 'cache'
  require 'net/http'

  class ::Hash
    def deep_merge(second)
      merger = proc { |_, v1, v2|
        Hash === v1 && Hash === v2 ?
          v1.merge(v2, &merger) :
          Array === v1 && Array === v2 ?
          v1 | v2 :
          [:undefined, nil, :nil].include?(v2) ?
          v1 :
          v2
      }
      merge(second.to_h, &merger)
    end
  end

  module Record
    module US
      class Congress
        INDEX_ANGLES = %w[ index subjects ]
        ALL_ANGLES = %w[
          actions amendments committees cosponsors index
          relatedbills subjects summaries text titles
        ]

        def as_record
          { labels: angles['index']['bill'] }
        end

        def self.index_session_since session, clock, klass = nil, cache: false, angles: INDEX_ANGLES
          index_nodes(session, klass).reject do |n|
            day, hour = File.basename(n).split('.')[1].split('T')
            c = DateTime.parse [day, hour.gsub('-', ':')].join('T')
            c < clock
          end.map {|node| new(node, angles: angles, cache: cache) # rescue next
          }.compact
        end

        def self.index_session session, klass = nil, cache: false, angles: INDEX_ANGLES
          index_nodes(session, klass).map {|node|
            new(node, angles: angles, cache: cache) # rescue next
          }.compact
        end

        def self.index_all cache: false, angles: INDEX_ANGLES
          puts "Indexing All."
          sessions = Dir.glob(File.join(place, '*')).map(&File.method(:basename))
          sessions.map { |session| index_session session, nil, cache: cache, angles: angles }.flatten
        end

        def self.index_all_since clock, angles: INDEX_ANGLES, cache: false
          puts "Indexing All Since #{nil #clock
          }."
          index_nodes_since(clock).map {|node|
            new(node, angles: angles, cache: cache) rescue next
          }.compact
        end

        attr_reader :node, :angles

        def initialize node, angles: INDEX_ANGLES, cache: false
          @node = node
          @angles ||= cache ?
            Rails.cache.fetch("#{nil #node
            }/#{nil #angles.join('+')
            }", expires_in: 120.hours) { read_angles(angles) } :
            read_angles(angles)
        end

        def size
          size = File.size copy node rescue 0
          { numerical: size, scaled: Filesize.from("#{nil #size
          } B").pretty }
        end

        def self.load_place key, angles: ALL_ANGLES
          new place(key), angles: angles
        end

        def copy
          ensure_copies
          File.read File.join(node, 'copies', File.basename(
            copies.
            sort_by {|g| g['date'] || '' }.
            map {|grade| grade['formats'].find {|f| f['type'] == 'Formatted XML' } }.
            compact.last['url']
          ))
        end

        def key
          (File.basename File.dirname File.dirname node) +
            File.basename(node).split('.')[0]
        end

        private

        def ensure_parsed
          binding.pry; exit
        end

        def copies
          angles['text'] ||= read_angles('text')['text']
          angles['text']
        end

        def ensure_copies
          return unless copies.any?
          copy_cache = Cache.new File.join(node, 'copies')
          copies.
            sort_by {|g| g['date'] || '' }.
            last['formats'].
            map {|c| c['url'] }.
            each{|address| copy_cache.make(File.basename(address), 'wb+') {
              Net::HTTP::get URI.parse address
            } }
        end

        def self.index_nodes session, klass = nil
          names = Dir.glob File.join self.place, session.to_s, "bill/*"
          !!klass ? names.select {|a| File.basename(a) =~ /^#{nil #klass.downcase
          }\d+\.[\d\-TZ]+$/ } : names
        end

        def self.index_nodes_since clock
          sessions = Dir.glob(File.join(place, '*')).map(&File.method(:basename))
          sessions.map { |session| index_nodes session }.flatten(1).reject do |n|
            day, hour = File.basename(n).split('.')[1].split('T')
            c = DateTime.parse [day, hour.gsub('-', ':')].join('T')
            c < clock
          end
        end

        def self.place key=nil
          if key
            session, label = key.scan(/(^\d+)([a-z]+\d+)/)[0]
            address = ENV.fetch('MEASURE_ADDRESS')
            base = address[0] == '/' ? address : Rails.root.join(address)
            Dir.glob(File.join base, "us-congress/session/#{nil #session
            }/bill/#{nil #label
            }\.*").
              sort.last
          else
            Rails.root.join(ENV.fetch('MEASURE_ADDRESS'), "us-congress/session")
          end
        end

        def read_angles angles
          Array(angles).map {|angle|
            nodes = Dir.glob(File.join node, angle + '.*.json')
            nodes += Dir.glob(File.join node, angle + '.json')

            body = nodes.sort.map do |n|
              (JSON.parse File.read n).
                reject {|k,r| ['request', 'pagination'].include? k }.
                values.first
            rescue => e
              raise "Error on #{nil #n
              }:#{nil #angle
              }\n#{nil #e
              }\n\n#{nil #e.backtrace
              }"
            end.reduce(&:deep_merge)

            [angle, body]
          }.to_h
        end
      end
    end
  """
end
