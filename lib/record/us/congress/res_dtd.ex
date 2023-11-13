defmodule Record.US.Congress.ResDTD do
  @moduledoc"""
  require "measure"
  require "nokogiri"
  require_relative './xml'

  module Processor
    module Congress
      class ResDTD < XML
        def recognized_measures
          # metadata dc:title dc:publisher dc:date dc:rights
          %w[
            resolution resolution-body
            form congress session legis-num current-chamber action-desc legis-type official-title
            preamble whereas
            division title subtitle part subpart
            section subsection paragraph subparagraph item subitem quoted-block
          ]
        end
      end
    end
  end
  """
end
