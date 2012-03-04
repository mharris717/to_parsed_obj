require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'to_parsed_obj/ext'

TP = ToParsedObj

class Foo
  include FromHash
  attr_accessor :bar
end

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
  mit "should convert negative int" do
    "-2".should parse_to(-2)
  end
  mit "should convert negative float" do
    "-2.3".should parse_to(-2.3)
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
  mit "should parse time with single digit hour and minutes" do
    "4/1/2010 2:30".should parse_to(Time.local(2010,4,1,2,30) )
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
  mit "should pass unknown object through" do
    f = Foo.new
    f.should parse_to(f)
  end
  mit "should use class parser" do
    TP.add :matcher => Foo do |obj|
      obj.bar * 2
    end
    f = Foo.new(:bar => 12)
    f.should parse_to(24)
  end
  mit 'one time' do
    require 'date'
    "TODAY".to_parsed_obj.should == 'TODAY'
    "TODAY".to_parsed_obj('TODAY' => lambda { Date.today }).should == Date.today
  end
end
