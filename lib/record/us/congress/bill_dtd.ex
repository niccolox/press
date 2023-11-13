defmodule Record.US.Congress.BillDTD do
  @moduledoc """
  require "measure"
  require "nokogiri"
  require_relative './xml'

  module Processor
    module Congress
      class BillDTD < XML
          # metadata dc:title dc:publisher dc:date dc:rights

        def recognized_measures
          %w[
            bill legis-body form preamble
            form congress session legis-num current-chamber action-desc legis-type official-title
            division title subtitle part subpart
            section subsection paragraph subparagraph item subitem quoted-block
          ]
        end

        process_node('quote') {|n| n.replace("\""+n.text+"\"") }
        process_node('toc') {|n| n.replace("\n...\n~~~\n...") }
      end
    end
  end
  """
end
