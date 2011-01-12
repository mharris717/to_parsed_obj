require File.dirname(__FILE__) + "/../to_parsed_obj"

class Object
  def to_parsed_obj
    ToParsedObj.parse(self)
  end
end
