require 'net/http'
require 'uri'

module SatellitesHelper

  # TODO: Refactor into multiple methods.
  def get_all_satellites_from_space_track_org
    login_url = 'https://www.space-track.org/ajaxauth/login'
    query_url = '/basicspacedata/query/class/satcat/orderby/norad_cat_id%20asc'

    # Setup a connection to space-track.org
    uri = URI.parse(login_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    login_request = Net::HTTP::Post.new(uri.request_uri)

    username = Rails.application.credentials.space_track_org_username
    password = Rails.application.credentials.space_track_org_password
    # Attack the username and password to the login request.
    login_request.body = "identity=#{username}&password=#{password}"
    # Make the login request.
    login_response = https.request(login_request)

    login_cookies = login_response.response['set-cookie']
    # Setup the query request.
    request = Net::HTTP::Get.new(query_url)
    # Attach the cookie from the login request to the query request.
    request['Cookie'] = login_cookies
    # Make the query.
    response = https.request(request)
    satellites = JSON.parse(response.body)

    satellites.each do |satellite|
      satellite_with_proper_keys = {}
      satellite_with_proper_keys['norad_catalog_id'] = satellite['NORAD_CAT_ID']
      satellite_with_proper_keys['international_designator'] = satellite['INTLDES']
      satellite_with_proper_keys['name'] = satellite['SATNAME']
      satellite_with_proper_keys['object_name'] = satellite['OBJECT_NAME']
      satellite_with_proper_keys['object_type'] = satellite['OBJECT_TYPE']
      satellite_with_proper_keys['object_id'] = satellite['OBJECT_ID']
      satellite_with_proper_keys['object_number'] = satellite['OBJECT_NUMBER']
      satellite_with_proper_keys['country'] = satellite['COUNTRY']
      satellite_with_proper_keys['launch_date'] = satellite['LAUNCH']
      satellite_with_proper_keys['launch_site'] = satellite['SITE']
      satellite_with_proper_keys['decay_date'] = satellite['DECAY']
      satellite_with_proper_keys['launch_year'] = satellite['LAUNCH_YEAR']
      satellite_with_proper_keys['launch_number'] = satellite['LAUNCH_NUM']
      satellite_with_proper_keys['launch_piece'] = satellite['LAUNCH_PIECE']
      satellite_with_proper_keys['period'] = satellite['PERIOD']
      satellite_with_proper_keys['inclination'] = satellite['INCLINATION']
      satellite_with_proper_keys['apogee'] = satellite['APOGEE']
      satellite_with_proper_keys['perigee'] = satellite['PERIGEE']
      satellite_with_proper_keys['radar_cross_section_value'] = satellite['RCSVALUE']
      satellite_with_proper_keys['radar_cross_section_size'] = satellite['RCS_SIZE']
      satellite_with_proper_keys['comment'] = satellite['COMMENT']
      satellite_with_proper_keys['comment_code'] = satellite['COMMENTCODE']
      satellite_with_proper_keys['file'] = satellite['FILE']
      satellite_with_proper_keys['current'] = satellite['CURRENT']

      begin
        Satellite.new(satellite_with_proper_keys).save!
      rescue ActiveRecord::RecordNotUnique => e
        logger.info "Tried to save satellite with duplicate ID: #{satellite_with_proper_keys[norad_catalog_id]}"
      end
    end
  end

end