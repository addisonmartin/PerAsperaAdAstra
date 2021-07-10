# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'net/http'
require 'uri'

# URL and identity constants
base_url = 'https://www.space-track.org'
login_url = '/ajaxauth/login'
logout_url = 'ajaxauth/logout'
username = Rails.application.credentials.space_track_org[:username]
password = Rails.application.credentials.space_track_org[:password]
satcat_query_url = '/basicspacedata/query/class/satcat/orderby/norad_cat_id%20asc'
tles_query_url = '/basicspacedata/query/class/gp/NORAD_CAT_ID/*/orderby/TLE_LINE1%20ASC/format/tle'
cache_path = Rails.root.join('db', 'satcat_cache.json')
use_cache = true

if use_cache
  satcat_satellites = {}
  File.open(cache_path, 'r') do |file|
    satcat_satellites = JSON.parse(file.read)
  end
else
  # Establish the base connection before logging in
  uri = URI.parse(base_url + login_url)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  # Prepare the login request
  login_request = Net::HTTP::Post.new(uri.request_uri)
  login_request.body = "identity=#{username}&password=#{password}"

  # Make the login request and store the cookie for later use
  login_response = https.request(login_request)
  login_cookie = login_response.response['set-cookie']

  raise "Unable to login to space-track.org due to bad credentials!" if login_response.code == '401'
  raise 'Unable to login to space-track.org likely due to rate throttling!' if login_response.code == '500'
  raise "Unable to login to space-track.org! HTTP Code: #{login_response.code}" if login_response.code != '200'
  puts 'Logged in to space-track.org...'

  # Prepare to query the satellite catalog
  satcat_query_request = Net::HTTP::Get.new(satcat_query_url)
  satcat_query_request['Cookie'] = login_cookie

  # Make the query request
  satcat_response = https.request(satcat_query_request)

  raise 'Unable to query space-track.org satellite catalog likely due to rate throttling!' if satcat_response.code == '500'
  raise "Unable to query space-track.org satellite catalog! HTTP Code: #{satcat_response.code}" if satcat_response.code != '200'
  puts 'Queried space-track.org satellite catalog...'

  satcat_satellites = JSON.parse(satcat_response.body)
  File.open(Rails.root.join('db', 'satcat_cache.json'), 'w') do |file|
    file.write(JSON.generate(satcat_satellites))
  end
end

# Used to prevent rate throttling the API
#start_time = Time.now
#number_of_queries = 0

satcat_satellites.each do |satcat|
  # Convert the keys to a format this application can use.
  satellite_keys = {}
  satellite_keys['catalog_id'] = satcat['NORAD_CAT_ID']
  satellite_keys['international_designation'] = satcat['INTLDES']
  satellite_keys['name'] = satcat['SATNAME']
  #satellite_keys['object_name'] = satcat['OBJECT_NAME']
  satellite_keys['space_object_type'] = satcat['OBJECT_TYPE']&.titleize
  #satellite_keys['object_id'] = satcat['OBJECT_ID']
  #satellite_keys['object_number'] = satcat['OBJECT_NUMBER']
  satellite_keys['country'] = Satellite::COUNTRY_CONVERSIONS[satcat['COUNTRY'].to_sym]
  satellite_keys['launch_date'] = satcat['LAUNCH']
  satellite_keys['launch_site'] = Satellite::LAUNCH_SITE_CONVERSIONS[satcat['SITE'].to_sym]
  satellite_keys['decay_date'] = satcat['DECAY']
  #satellite_keys['launch_year'] = satcat['LAUNCH_YEAR']
  #satellite_keys['launch_number'] = satcat['LAUNCH_NUM']
  #satellite_keys['launch_piece'] = satcat['LAUNCH_PIECE']
  #satellite_keys['radar_cross_section_value'] = satcat['RCSVALUE']
  satellite_keys['radar_cross_section_size'] = satcat['RCS_SIZE']&.titleize
  #satellite_keys['comment'] = satcat['COMMENT']
  #satellite_keys['comment_code'] = satcat['COMMENTCODE']
  #satellite_keys['file'] = satcat['FILE']
  #satellite_keys['current'] = satcat['CURRENT']

  # Prepare the query request for the satellite's two-line element set (TLES)
  #tles_query_request_url = tles_query_url.sub('*', satellite_keys['catalog_id'])
  #tles_query_request = Net::HTTP::Get.new(tles_query_request_url)
  #tles_query_request['Cookie'] = login_cookie

  # Make the tles query request
  #tles_response = https.request(tles_query_request)

  #raise 'Unable to query space-track.org TLES likely due to rate throttling!' if tles_response.code == '500'
  #raise "Unable to query space-track.org TLES! HTTP Code: #{tles_response.code}" unless tles_response.code == '200' or tles_response.code == '204'

  #if tles_response.code == '200'
  #  puts "Queried space-track.org for the TLES of #{satellite_keys['name']}..."
  #  tles = tles_response.body
  #else
  #  puts "Queried space-track.org and got no TLES for #{satellite_keys['name']}..."
  #  tles = nil
  #end

  # raise "Verify checksum failed for satellite with NORAD Catalog ID #{satellite_keys['catalog_id']}" unless verify_checksum(tles)

  satellite = Satellite.new(satellite_keys)
  #satellite.tles = tles

  # Convert the keys to a format this application can use.
  orbit_keys = {}
  orbit_keys['name'] = "#{satellite.name}'s Orbit"
  orbit_keys['period'] = satcat['PERIOD']
  orbit_keys['inclination'] = satcat['INCLINATION']
  orbit_keys['apogee'] = satcat['APOGEE']
  orbit_keys['perigee'] = satcat['PERIGEE']

  orbit = Orbit.new(orbit_keys)
  orbit.satellite = satellite
  #orbit.tles = tles
  orbit.save!
  satellite.save!

  puts "Saved satellite #{satellite.name} and its orbit in the database..."
  #number_of_queries += 1

  #now_time = Time.now
  #delta_time = now_time - start_time
  #if delta_time <= 1.minute and number_of_queries >= 19
  #  sleep_time = 1.minute - delta_time + 3.seconds
  #  puts "Sleeping for #{sleep_time} seconds to prevent rate throttling..."
  #  sleep(sleep_time)
  #  start_time = Time.now
  #  number_of_queries = 0
  #end
end

if not use_cache
  # Prepare the logout request
  logout_request = Net::HTTP::Get.new(logout_url)
  logout_request['Cookie'] = login_cookie

  # Make the logout request
  https.request(logout_request)
  puts 'Logged out of space-track.org...'
  puts "Complete! Saved #{Satellite.all.count} new satellites."
end
