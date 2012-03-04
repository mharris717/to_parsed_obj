require 'mharris_ext'
module ToParsedObj
  def self.method_missing(sym,*args,&b)
    Parsers.instance.send(sym,*args,&b)
  end
  class SingleParser
    include FromHash
    attr_accessor :matcher, :convertor, :match_obj
    def match?(obj,m=matcher)
      self.match_obj = if m.kind_of?(Regexp)
        m.match(obj.to_s.strip)
      elsif m.respond_to?(:call)
        m.call(obj)
      elsif m.kind_of?(Array)
        m.all? { |x| match?(obj,x) }
      elsif m.kind_of?(Class)
        obj.kind_of?(m)
      else
        m == obj
      end
      !!match_obj
    end
    def parse(obj)
      if convertor.kind_of?(Symbol) || convertor.kind_of?(String)
        obj.send(convertor)
      elsif convertor.kind_of?(Class)
        convertor.new(obj)
      elsif convertor.respond_to?(:call)
        if convertor.arity == 1
          convertor.call(obj)
        elsif convertor.arity == 0
          convertor.call
        else
          convertor.call(obj,self)
        end
      else
        "dunno how to convert"
      end
    end
  end
  class Parsers
    include FromHash
    fattr(:parsers) { [] }
    def each_parser(one_time,&b)
      one_time.each do |m,c|
        parser = ToParsedObj::SingleParser.new(:matcher => m, :convertor => c)
        yield(parser)
      end
      parsers.each(&b)
    end
    def parse(obj,one_time={})
      each_parser(one_time) do |parser|
        return parser.parse(obj) if parser.match?(obj)
      end
      obj
    end
    def add(ops,&b)
      ops[:convertor] ||= b if block_given?
      self.parsers << ToParsedObj::SingleParser.new(ops)
    end
    def add_basic!
      require 'date'
      add(:matcher => /^-?[0-9]+$/, :convertor => :to_i)
      add(:matcher => [/^-?[0-9\.]+$/,/^[^\.]*\.[^\.]*$/], :convertor => :to_f)
      add(:matcher => /^\d+[\/\\]\d+[\/\\]\d+$/) { |str| Date.parse(str) }
      
      add(:matcher => /^(\d+[\/\\]\d+[\/\\]\d+\s+\d+(?::\d+){1,99})/) do |str,single|
        m = single.match_obj[1].scan(/\d+/).map { |x| x.to_i }
        arr = [2,0,1].map { |i| m[i] }
        arr += m[3..-1].map { |x| x }
        Time.local(*arr)
      end
      
      add(:matcher => /^(\d+-\d+-\d+\s+\d+(?::\d+){1,99})\s+\-\d+$/) do |str,single|
        m = single.match_obj[1].scan(/\d+/).map { |x| x.to_i }
        Time.local(*m)
      end
    end
    class << self
      fattr(:instance) { new }
    end
  end
end

