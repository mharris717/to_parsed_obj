require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'to_parsed_obj/ext'

TP = ToParsedObj

describe "ToParsedObj" do
  before do
    TP::Parsers.instance!
    TP.add_basic!
  end
 
  mit "should leave empty alone" do
    "".to_parsed_obj.should == ""
  end
  mit "should leave random string alone" do
    str = "fgdfgerger"
    str.to_parsed_obj.should == str
  end
  mit 'should convert int' do
    "123".should parse_to(123)
  end
  mit "should convert float" do
    "2.3".should parse_to(2.3)
  end
  mit "should not parse multiple dots to float" do
    "1.2.3".should parse_to("1.2.3")
  end
  mit "should parse date" do
    "4/1/2010".should parse_to(Date.new(2010,1,4) )
  end
  mit "should parse time with hours and minutes" do
    "4/1/2010 12:30".should parse_to(Time.local(2010,4,1,12,30) )
  end
  mit "should parse time with seconds" do
    "4/1/2010 12:30:01".should parse_to(Time.local(2010,4,1,12,30,1) )
  end
  mit 'should parse time inspect with seconds' do
    t = Time.local(2010,4,1,12,30,1)
    t.inspect.should parse_to(t)
  end
  mit 'should parse time inspect with no hours' do
    t = Time.local(2010,4,1)
    t.inspect.should parse_to(t)
  end
end
