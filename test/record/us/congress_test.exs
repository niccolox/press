defmodule Record.US.CongressTest do
  use ExUnit.Case, async: true
  alias Record.US.Congress

  setup do System.put_env("MEASURE_ADDRESS",
    Application.app_dir(:assembled, "priv/record.sample/us-congress")) end

  describe "sessions" do
    test "only picks up sessions recorded in cache" do
      assert Congress.sessions == [118]
    end
  end

  describe "bills_in/1" do
    test "only indexes most recent copy of each bill" do
      recs = Congress.bills_in(118)
      assert recs == ["/session/118/bill/hr82.2023-11-09T08-15-26Z"]
    end
  end

  describe "read/1" do
    test "combines pages inside each of the record's angles" do
      (Congress.read("/session/118/bill/hr82.2023-10-05T07-15-26Z")[:cosponsors]
      |> length == 296) |> assert

      (Congress.read("/session/118/bill/hr82.2023-11-09T08-15-26Z")[:cosponsors]
      |> length == 300) |> assert
    end

    test "Assumes ambiguous record based on recency" do
      (Congress.read("/session/118/bill/hr82.*")[:cosponsors]
      |> length == 300) |> assert
    end
  end
end
