require 'rubygems'
require 'action_view'
require 'erb'

class MetadataHelper

  include ActionView::Helpers::TagHelper

  def initialize( opts = {} )
    @title        = opts[:title]
    @url          = opts[:url]
    @description  = opts[:description]
    @image_url    = opts[:image_url] || opts[:image]
    @author       = opts[:author]
    @name         = opts[:name]
    @type         = opts[:type]
  end

  def old_school
    Array.new.tap do |arr| 
      arr << ttag( @title )
      arr << mtag( 'description', @description )
      arr << mtag( 'author', @name )
    end.compact

  end
  
  def twitter_card
    Array.new.tap do |arr| 
      arr << mtag( 'twitter:card', 'summary' )
      arr << mtag( 'twitter:url',  @url )
      arr << mtag( 'twitter:title', @title )
      arr << mtag( 'twitter:description', @description )
      arr << mtag( 'twitter:image', @image_url )
      arr << mtag( 'twitter:author', @author )
    end.compact
  end

  def open_graph
    Array.new.tap do |arr| 
      arr << mtag( 'og:type', @type )
      arr << mtag( 'og:url',  @url )
      arr << mtag( 'og:title', @title )
      arr << mtag( 'og:description', @description )
      arr << mtag( 'og:image', @image_url )
    end.compact
  end

  def all
    [ old_school, twitter_card, open_graph ].flatten.join( "\n" )
  end

  private

  def mtag( name, content )
    tag( :meta, { name: name, content: content }, false, false ) if name && content
  end
  
  def ttag( content )
    content_tag( :title, content ) if content
  end

end

template = ERB.new <<EOS
<!DOCTYPE HTML>
<html>
  <head>
    <%= helper.all %>
  </head>
  <body>
    <p>Hello people!</p>
  </body>
</html>
EOS

helper = MetadataHelper.new( { 
  title:        'Test', 
  url:          'http://www.lukaszielinski.de', 
  description:  'Just testing',
  type:         'article',
  author:       '@lukaszielinski',
  name:         'Lukas Zielinski',
  image:        'http://mugs.mugbug.co.uk/500/mb.i_love_html_red_love_heart.coaster.jpg'
} )

puts template.result( binding )
