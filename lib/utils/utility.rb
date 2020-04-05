class Utility

  ##
  # Haversine Distance Calculation
  #
  # Accepts two coordinates in the form
  # of a tuple. I.e.
  #   geo_a  Array(Num, Num)
  #   geo_b  Array(Num, Num)
  #   miles  Boolean
  #
  # Returns the distance between these two
  # points in either miles or kilometers
  def self.haversine_distance(geo_a, geo_b, miles=false)
    # Get latitude and longitude
    lat1, lon1 = geo_a
    lat2, lon2 = geo_b

    # Calculate radial arcs for latitude and longitude
    dLat = (lat2 - lat1) * Math::PI / 180
    dLon = (lon2 - lon1) * Math::PI / 180

    a = Math.sin(dLat / 2) *
    Math.sin(dLat / 2) +
    Math.cos(lat1 * Math::PI / 180) *
    Math.cos(lat2 * Math::PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = 6371 * c * (miles ? 1 / 1.6 : 1)

    d
  end

end
