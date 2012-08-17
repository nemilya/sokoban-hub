require 'spec_helper'
require 'sokoban_loader'


XML_LEVEL =<<LEVEL_END
<?xml version="1.0" encoding="ISO-8859-1"?>
<SokobanLevels xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="SokobanLev.xsd">
  <Title>File title</Title>
  <Description>File description</Description>
  <Email>email@email</Email>
  <Url>url_link</Url>
  <LevelCollection Copyright="copy right" MaxWidth="11" MaxHeight="12">
    <Level Id="Connection" Width="9" Height="10">
      <L>   ####</L>
      <L>####  ##</L>
      <L>#   $  #</L>
      <L>#  *** #</L>
      <L>#  . . ##</L>
      <L>## * *  #</L>
      <L> ##***  #</L>
      <L>  # $ ###</L>
      <L>  # @ #</L>
      <L>  #####</L>
    </Level>
    <Level Id="Two rooms" Width="11" Height="8">
      <L> #########</L>
      <L> #   #   #</L>
      <L> # @ #   #</L>
      <L>##$**$**$#</L>
      <L>#  #. .# ##</L>
      <L>#  .*$*.  #</L>
      <L>#         #</L>
      <L>###########</L>
    </Level>
  </LevelCollection>
</SokobanLevels>
LEVEL_END

describe SokobanLoader do
  describe "file load" do
    it "test" do
      sl = SokobanLoader.new
      sl.parse 'file_name.slc', XML_LEVEL

      sl.file_name.should == 'file_name.slc'
      sl.content.should == XML_LEVEL
    end

    it "parse xml attributes" do
      sl = SokobanLoader.new
      sl.parse 'file_name.slc', XML_LEVEL

      sl.title.should == 'File title'
      sl.description.should == 'File description'
      sl.email.should == 'email@email'
      sl.url.should   == 'url_link'
      sl.copyright.should == 'copy right'
    end
  end

  describe "levels parse" do
    it "levels count" do
      sl = SokobanLoader.new
      sl.parse 'file_name.slc', XML_LEVEL

      sl.levels.size.should == 2
    end

    it "level info" do
      sl = SokobanLoader.new
      sl.parse 'file_name.slc', XML_LEVEL

      level1 = sl.levels[0]
      level1[:id].should == 'Connection'
      level1[:text].should == \
                              '   ####'+"\n"+
                              '####  ##'+"\n"+
                              '#   $  #'+"\n"+
                              '#  *** #'+"\n"+
                              '#  . . ##'+"\n"+
                              '## * *  #'+"\n"+
                              ' ##***  #'+"\n"+
                              '  # $ ###'+"\n"+
                              '  # @ #'+"\n"+
                              '  #####'
    end
  end
end