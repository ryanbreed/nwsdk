require 'spec_helper'

describe Nwsdk::Condition do
  include_context 'conditions'

  context "when initializing" do
    it "can be initialized with no args" do
      expect(empty_condition).to be_a(Nwsdk::Condition)
    end
    it "always has a #start Time property" do
      expect(empty_condition.start).to be_a(Time)
    end
    it "always has a #end Time property" do
      expect(empty_condition.end).to be_a(Time)
    end
    it "has a #time1 property that is the same as start" do
      expect(empty_condition.start).to eq(empty_condition.time1)
    end
    it "has a #time2 property that is the same as end" do
      expect(empty_condition.end).to eq(empty_condition.end)
    end
    it "has a #span property that is the difference between start and end" do
      time_diff=empty_condition.end - empty_condition.start
      expect(time_diff).to eq(empty_condition.span)
    end
  end

  context "when rendering where predicate" do
    it "renders an empty where" do
      rendered=empty_condition.format
      expect(rendered).to eq("time='2015-Aug-24 00:00:00'-'2015-Aug-24 23:59:59'")
    end
    it "renders predicate without time conditions" do
      rendered=service_condition_utc.format(use_time: false)
      expect(rendered).to eq("(service=80)")
    end
  end

  context "when rendering with UTC timestamps" do
    it "renders time conditions" do
      rendered=service_condition_utc.format_time_range
      expect(rendered).to eq("'2015-Aug-24 00:00:00'-'2015-Aug-24 23:59:59'")
    end
    it "renders combined predicate and time conditions" do
      rendered=service_condition_utc.format
      expect(rendered).to eq(
        "(service=80)&&time='2015-Aug-24 00:00:00'-'2015-Aug-24 23:59:59'"
      )
    end

  end
  context "when rendering with local timestamps" do
    it "renders time conditions to UTC" do
      rendered=service_condition_local.format_time_range
      expect(rendered).to eq("'2015-Aug-24 05:00:00'-'2015-Aug-25 04:59:59'")
    end
    it "renders combined predicate and time conditions" do
      rendered=service_condition_local.format
      expect(rendered).to eq(
        "(service=80)&&time='2015-Aug-24 05:00:00'-'2015-Aug-25 04:59:59'"
      )
    end
  end
end
