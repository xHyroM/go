require "xml"

class Object
  def to_xml : String
    String.build do |str|
      to_xml str
    end
  end

  def to_xml(io : IO) : Nil
    XML.build(io) do |xml|
      to_xml(xml)
    end
  end
end

class Array
  def to_xml(xml : XML::Builder) : Nil
    xml.element("resources") do
      each &.to_xml(xml)
    end
  end
end

struct NamedTuple
  def to_xml(xml : XML::Builder)
    xml.element(self["name"]) do
      {% for key in T.keys %}
        xml.element({{key.stringify}}) { xml.text self[{{ key.symbolize }}] }
      {% end %}
    end
  end
end
