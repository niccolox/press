defmodule Record.US.Congress.Measure do
  @doc """
  class Measure
    def initialize(marker, label, heading, source, submeasures, key)
      @marker = marker
      @label = label
      @heading = heading
      @source = source
      @submeasures = submeasures
      @key = key
    end

    attr_reader :marker, :label, :heading, :submeasures, :key

    def combine(labels: true)
      combined = source.clone
      while place = combined.scan(/\{place \"[^\"]+\"\}/)[0]
        key = place.scan(/\{place \"([^\"]+)\"\}/)[0][0]
        replace = all_submeasures.find {|sm| sm.key == key }
        combined.gsub!(place, (labels ? replace.label+' ' : '') + replace.source)
      end
      (labels ? label+' ' : '') + combined
    end

    def source
      @source.to_s
    end

    def measures(marker)
      all_submeasures.filter {|sm| sm.marker == marker }
    end

    def measure(marker, label)
      measures(marker).find {|x| x.label == label }
    end

    def all_submeasures
      @all_submeasures ||=
        begin
          all = []
          submeasures.each {|sm| all += [sm, sm.all_submeasures].flatten }
          all
        end
    end

    def add_submeasure(measure)
      @submeasures << measure
    end

    def body
      code = source
      places = source.scan(/(\{place +\"([A-H0-9]+)\"\})/)
      places.each do |place, key|
        code = code.gsub(place, submeasures.find {|x| x.key == key }.body)
      end
      code
    end

    def inspect
      "["+marker+" "+label+"\t:"+source.chars.first(80).join.gsub("\n", "\u23ce")+"]"
    end

    def to_s
      "["+marker+" "+label+"\t:"+source.chars.first(80).join.gsub("\n", "\u23ce")+"...]"
    end
  end
  """
end
