class <%= class_name %> < ActiveRecord::Base
  include geokit_cached
  # config options for to_xml
  XML_OPTIONS = {:include => [], :except => [] + self.protected_attributes().to_a, :methods => [:geocoding_errors]}
  
  alias_method :ar_to_xml, :to_xml
  def to_xml(options = {})
    options[:except] = (options[:except] ? Array(options[:except]) + XML_OPTIONS[:except] : XML_OPTIONS[:except])
    options[:include] = (options[:include] ? Array(options[:include]) + XML_OPTIONS[:include] : XML_OPTIONS[:include])
    options[:methods] = (options[:methods] ? Array(options[:methods]) + XML_OPTIONS[:methods] : XML_OPTIONS[:methods])
    ar_to_xml(options)
  end
end