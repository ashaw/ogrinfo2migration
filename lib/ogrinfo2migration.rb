require 'json'
require 'rest-client'
require 'erb'
require 'active_support/inflector'

class Ogrinfo2Migration
  RESERVED = [
    "INFO",
    "Geometry",
    "Feature Count",
    "Extent",
    "Layer SRS WKT"
  ]

  TYPES = {
    "real" => "decimal"
  }

  attr_reader :info, :attributes, :wkt

  def initialize(file, outdir)
    @outdir = outdir
    @info = %x(ogrinfo -so -al #{file}).split("\n")
    @info.shift(3)
    @attributes = @info.reduce(Hash.new(0)) do |memo, it|
      if it =~ /:/ && it !~ Regexp.new("(#{RESERVED.join("|")})")
        name, type = it.split(":")
        name = name.downcase.gsub(/ /,"_")
        type = type.gsub(/\([\d\.]+\)/,"").strip.downcase
        type = TYPES[type] ? TYPES[type] : type
        memo[name] = type
      end
      memo
    end
  end

  def wkt
    # the SRS wkt are the only lines 
    # that aren't a key-value pair
    wkt = @info.reject {|q| q =~ /:/ }.join("\n")
  end

  def get_epsg
    if wkt == "(unknown)"
      @epsg = nil
      return
    end
    j = JSON.parse(RestClient.get("http://prj2epsg.org/search.json?mode=wkt&terms=#{URI.encode(wkt)}"))
    if !j || j['totalHits'] < 1
      @epsg = nil
      return
    end
    @epsg = j['codes'][0]['code']
  end

  def to_migration
    get_epsg
    migration = ERB.new(File.open("#{File.expand_path(File.dirname(__FILE__))}/tmpl.erb",'r').read).result(binding)
    File.open("#{@outdir}#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_add_#{@attributes["layer_name"]}.rb", "w") do |f|
      f.write migration
    end
  end
end