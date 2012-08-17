# parse xml files

class SokobanLoader

  def copyright
    @copyright
  end
 
  def file_name
    @file_name
  end

  def content
    @content
  end

  def title
    @title
  end

  def email
    @email
  end

  def url
    @url
  end

  def description
    @description
  end

  def levels
    @levels
  end

  def parse(file_name, content)
    @file_name = file_name
    @content = content
    parse_xml
  end

  def parse_xml
    require 'rexml/document'
    doc = REXML::Document.new(content)
    doc.root.each_element do |element|
      @title = element.text       if element.name == 'Title' 
      @description = element.text if element.name == 'Description'
      @email = element.text       if element.name == 'Email'
      @url = element.text         if element.name == 'Url'
      parse_level_collection(element) if element.name == 'LevelCollection'
    end
  end

  def parse_level_collection(element)
    @copyright = element.attributes['Copyright']
    @levels = []
    element.each_element do |element|
      if element.name == 'Level'
        level = parse_level(element)
        @levels << level
      end
    end
  end

  def parse_level(element)
    level = {}
    level[:id] = element.attributes['Id']
    lines = []
    element.each_element do |line|
      lines << line.text
    end
    level[:text] = lines.join("\n")
    level
  end



end