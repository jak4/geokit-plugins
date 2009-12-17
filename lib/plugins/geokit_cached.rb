module GeokitPlugins
  module GeokitCached
    #attr_accessor :geocoding_errors
    def self.included(mod) # :nodoc:
      mod.extend(ClassMethods)
      mod.send(:include, InstanceMethods)
    end
    
     # config options for to_xml
#    XML_OPTIONS = {:include => [], :except => [] + self.protected_attributes().to_a, :methods => [:geocoding_errors]}
    
    module ClassMethods      
      def find_location(address)
        raise "Empty addresses are hard to geocode!" if address.blank?
        raise "Provided address currently needs to be a GeoLoc-Object!" unless address.is_a?(Geokit::GeoLoc)
    
        geo_loc = nil
        locations = find_all_by_city_and_street_name_and_street_number(address.city, address.street_name, address.street_number)
        
        if( locations.size == 1 )
          geo_loc = locations[0].convert_to_geoloc
          geo_loc.success = true
          geo_loc.provider = locations[0].provider.upcase
          geo_loc.precision = locations[0].precision
        elsif( locations.size > 1)
          raise "Found more than one entry for this '" + attributes[:city] + " " + attributes[:street_name] + " " +  attributes[:street_number] + "' address! Please fix that!" if location.size > 1
        end
    
        return geo_loc
      end
      
      def save_location(location)
        raise "Only Geoloc-Objects" unless location.is_a?(Geokit::GeoLoc)
        l = create!(convert_to_self(location))
        return l
      end
      
      def convert_to_self(ext_loc)
        raise "Only GeoLoc-Class supported!" unless ext_loc.is_a?(Geokit::GeoLoc)
        raise "hash method not supported!" unless ext_loc.respond_to?(:attribures) or ext_loc.respond_to?(:hash)
        
        ext_hsh = ext_loc.attributes rescue nil
        ext_hsh ||= ext_loc.hash
        ext_hsh.symbolize_keys!
       
        loc_attr = new.attributes.symbolize_keys
        int_hsh = Hash.new
        
        ext_hsh.each_pair do |key, value|
          if key.to_sym.eql?(:street_address)
            int_hsh[:street_name] = ext_loc.street_name
            int_hsh[:street_number] = ext_loc.street_number
          else
            int_hsh[key.to_sym] = value if loc_attr.has_key?(key.to_sym)
          end
        end
        return int_hsh
      end
    end
    
    module InstanceMethods
      attr_accessor :geocoding_errors
      def street_address
        street_address = (street_name.to_s + " " + street_number.to_s).strip
        return street_address.blank? ? nil:street_address
      end
      
      def convert_to_geoloc()
        ext_hsh = Hash.new
        int_hsh = attributes.symbolize_keys
    
        int_hsh.each_pair do |key, value|
          ext_hsh[key] = value unless key.eql?(:street_name) or key.eql?(:stree_number)
        end    
        ext_hsh[:street_address] = street_address
        
        # just to have some difference between a database-provider and a "original" providers
        # the original provider should always be lower case, the database provided location has the original provider in upper cases
        ext_hsh[:provider] = ext_hsh[:provider].upcase
        
        return Geokit::GeoLoc.new(ext_hsh)
      end
    end
  end
end