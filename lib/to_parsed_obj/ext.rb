require File.dirname(__FILE__) + "/../to_parsed_obj"
ToParsedObj.add_basic!

class Object
  def to_parsed_obj
    ToParsedObj.parse(self)
  end
end
