require 'net/http'
require 'uri'

module SatellitesHelper

  def get_all_satellites_from_space_track_org
    login_url = 'https://www.space-track.org/ajaxauth/login'
    query_url = '/basicspacedata/query/class/satcat/orderby/norad_cat_id%20asc'
    logout_url = '/ajaxauth/logout'

    #
    # Setup a connection to https://www.space-track.org
    #
    uri = URI.parse(login_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    #
    # Login to space-track.org, and store the cookie for future requests.
    #
    login_request = Net::HTTP::Post.new(uri.request_uri)
    username = Rails.application.credentials.space_track_org_username
    password = Rails.application.credentials.space_track_org_password
    # Attach the username and password to the login request.
    login_request.body = "identity=#{username}&password=#{password}"
    # Make the login request.
    login_response = https.request(login_request)
    # Save the cookie returned from logging in.
    cookie = login_response.response['set-cookie']

    #
    # Query the satellite catalog from space-track.org
    #
    query_request = Net::HTTP::Get.new(query_url)
    # Attach the cookie from the login request to the query request.
    query_request['Cookie'] = cookie
    # Make the query.
    response = https.request(query_request)
    # Store the returned satellites in the application database.
    satellites = JSON.parse(response.body)
    satellites.each do |satellite|
      # Convert the satellite keys from space-track.org format, to the format used in the application.
      satellite_with_proper_keys = convert_to_proper_keys(satellite)
      # Don't save duplicate satellites in the database.
      begin
        Satellite.new(satellite_with_proper_keys).save!
      rescue ActiveRecord::RecordNotUnique => e
        logger.info "Tried to save satellite with duplicate ID: #{satellite_with_proper_keys[norad_catalog_id]}"
      end
    end

    #
    # Logout from space-track.org
    #
    logout_request = Net::HTTP::Get.new(logout_url)
    # Attach the cookie from the login request to the logout request.
    logout_request['Cookie'] = cookie
    # Make the logout request.
    https.request(logout_request)
  end

  private

  def convert_to_proper_keys(satellite)
    satellite_with_proper_keys = {}

    satellite_with_proper_keys['norad_catalog_id'] = satellite['NORAD_CAT_ID']
    satellite_with_proper_keys['international_designator'] = satellite['INTLDES']
    satellite_with_proper_keys['name'] = satellite['SATNAME']
    satellite_with_proper_keys['object_name'] = satellite['OBJECT_NAME']
    satellite_with_proper_keys['object_type'] = satellite['OBJECT_TYPE'].titleize
    satellite_with_proper_keys['object_id'] = satellite['OBJECT_ID']
    satellite_with_proper_keys['object_number'] = satellite['OBJECT_NUMBER']
    satellite_with_proper_keys['country'] = convert_country_to_full_name(satellite['COUNTRY'])
    satellite_with_proper_keys['launch_date'] = satellite['LAUNCH']
    satellite_with_proper_keys['launch_site'] = convert_launch_site_to_full_name(satellite['SITE'])
    satellite_with_proper_keys['decay_date'] = satellite['DECAY']
    satellite_with_proper_keys['launch_year'] = satellite['LAUNCH_YEAR']
    satellite_with_proper_keys['launch_number'] = satellite['LAUNCH_NUM']
    satellite_with_proper_keys['launch_piece'] = satellite['LAUNCH_PIECE']
    satellite_with_proper_keys['period'] = satellite['PERIOD']
    satellite_with_proper_keys['inclination'] = satellite['INCLINATION']
    satellite_with_proper_keys['apogee'] = satellite['APOGEE']
    satellite_with_proper_keys['perigee'] = satellite['PERIGEE']
    satellite_with_proper_keys['radar_cross_section_value'] = satellite['RCSVALUE']
    satellite_with_proper_keys['radar_cross_section_size'] = add_area_to_radar_cross_section_size(satellite['RCS_SIZE'])
    satellite_with_proper_keys['comment'] = satellite['COMMENT']
    satellite_with_proper_keys['comment_code'] = satellite['COMMENTCODE']
    satellite_with_proper_keys['file'] = satellite['FILE']
    satellite_with_proper_keys['current'] = satellite['CURRENT']

    satellite_with_proper_keys
  end

  def convert_country_to_full_name(country_code)
    conversion = {
      'AB': 'Arab Satellite Communications Organization',
      'AC': 'Asiasat Corp',
      'AGO': 'Republic of Angola',
      'ALG': 'Algeria',
      'ARGN': 'Argentina',
      'ASRA': 'Austria',
      'AUS': 'Australia',
      'AZER': 'Azerbaijan',
      'BEL': 'Belgium',
      'BELA': 'Belarus',
      'BERM': 'Bermuda',
      'BGD': 'Bangladesh',
      'BGR': 'Bulgaria',
      'BOL': 'Bolivia',
      'BRAZ': 'Brazil',
      'CA': 'Canada',
      'CHBZ': 'China/Brazil',
      'CHLE': 'Chile',
      'CIS': 'USSR/Russia',
      'COL': 'Colombia',
      'CRI': 'Costa Rica',
      'CZCH': 'Czechoslovakia',
      'DEN': 'Denmark',
      'ECU': 'Ecuador',
      'EGYP': 'Egypt',
      'ESA': 'European Space Agency (ESA)',
      'ESRO': 'European Space Research Organization (ESRO)',
      'EST': 'Estonia',
      'EUME': 'European Organization For The Exploitation Of Meteorological Satellites',
      'EUTE': 'European Telecommunications Satellite Organization (EUTELSAT)',
      'FGER': 'France/Germany',
      'FIN': 'Finland',
      'FR': 'France',
      'FRIT': 'France/Italy',
      'GER': 'Germany',
      'GHA': 'Ghana',
      'GLOB': 'Globalstar',
      'GREC': 'Greece',
      'HUN': 'Hungary',
      'IM': 'International Maritime Satellite Organization (INMARSAT)',
      'IND': 'India',
      'INDO': 'Indonesia',
      'IRAN': 'Iran',
      'IRAQ': 'Iraq',
      'ISRA': 'Israel',
      'ISS': 'International Space Station (ISS)',
      'IT': 'Italy',
      'ITSO': 'International Telecommunications Satellite Organization (INTELSAT)',
      'JOR': 'Jordan',
      'JPN': 'Japan',
      'KAZ': 'Kazakhstan',
      'KEN': 'Kenya',
      'LAOS': 'Laos',
      'LKA': 'Sri Lanka',
      'LTU': 'Lithuania',
      'LUXE': 'Luxembourg',
      'MA': 'Morocco',
      'MALA': 'Malaysia',
      'MEX': 'Mexico',
      'MNG': 'Mongolia',
      'NATO': 'North Atlantic Treaty Organization (NATO)',
      'NETH': 'Netherlands',
      'NICO': 'New ICO',
      'NIG': 'Nigeria',
      'NKOR': 'North Korea',
      'NOR': 'Norway',
      'NPL': 'Nepal',
      'NZ': 'New Zealand',
      'O3B': 'O3B Networks',
      'ORB': 'Orbital Telecommunications Satellite (Globalstar)',
      'PAKI': 'Pakistan',
      'PER': 'Peru',
      'POL': 'Poland',
      'POR': 'Portugal',
      'PRC': 'China',
      'RASC': 'Regional African Satellite Communications Org',
      'ROC': 'Taiwan',
      'ROM': 'Romania',
      'RP': 'Philippines',
      'RWA': 'Rwanda',
      'SAFR': 'South Africa',
      'SAUD': 'Saudi Arabia',
      'SDN': 'Sudan',
      'SEAL': 'Sea Launch Demo',
      'SES': 'Société Européenne Des Satellites (SES)',
      'SING': 'Singapore',
      'SKOR': 'South Korea',
      'SPN': 'Spain',
      'STCT': 'Singapore/Taiwan',
      'SWED': 'Sweden',
      'SWTZ': 'Switzerland',
      'TBD': 'To Be Determined/Unknown',
      'THAI': 'Thailand',
      'TMMC': 'Turkmenistan/Monaco',
      'TURK': 'Turkey',
      'UAE': 'United Arab Emirates',
      'UK': 'United Kingdom',
      'UKR': 'Ukraine',
      'URY': 'Uruguay',
      'US': 'United States Of America',
      'USBZ': 'United States/Brazil',
      'VENZ': 'Venezuela',
      'VTNM': 'Vietnam'
    }

    conversion[country_code.to_sym]
  end

  def convert_launch_site_to_full_name(launch_site_code)
    conversion = {
      'AFETR': 'Air Force Eastern Test Range',
      'AFWTR': 'Air Force Western Test Range',
      'CAS': 'Pegasus launched from Canary Islands Air Space',
      'ERAS': 'Pegasus launched from Eastern Range Air Space',
      'FRGUI': 'French Guiana',
      'HGSTR': 'Hamma Guira Space Track Range, Algeria',
      'JSC': 'Jiuquan Satellite Launch Center, China',
      'KODAK': 'Kodiak Island, Alaska, USA',
      'KSCUT': 'Kagishima Space Center University of Tokyo, Japan',
      'KWAJL': 'Kwajalein, Marshall Islands',
      'KYMTR': 'Kapustin Yar Missile and Space Complex, Russia',
      'NSC': 'Naro Space Center, South Korea',
      'OREN': 'Orenburg, Russia',
      'PKMTR': 'Plesetsk Missile and Space Complex, Russia',
      'PMRF': 'Pacific Missile Range Facility, USA',
      'RLLC': 'Rocket Lab Launch Complex, New Zealand',
      'SADOL': 'Submarine Launch from Barents Sea, Russia',
      'SEAL': 'Sea Launch',
      'SEM': 'Semnan, Iran',
      'SNMLP': 'San Marco Launch Platform, Kenya',
      'SRI': 'Sirharikota, India',
      'SVOB': 'Svobodny, Russia',
      'TNSTA': 'Tanegashima Space Center, Japan',
      'TSC': 'Taiyaun Space Center, China',
      'TTMTR': 'Tyuratam Missle and Space Complex, Russia',
      'UNKN': 'Unknown',
      'VOSTO': 'Vostochny Cosmodrone, Russia',
      'WLPIS': 'Wallops Island, Virginia, USA',
      'WOMRA': 'Woomera, Australia',
      'WRAS': 'Pegasus launched from Western Range Air Space',
      'WSC': 'Wenchang Satellite Launch Center, China',
      'XSC': 'Xichang Space Center, China',
      'YAVNE': 'Yavne, Israel',
      'YSLA': 'Yellow Sea Launch Area, China',
      'YUN': 'Yunsong, North Korea'
    }

    conversion[launch_site_code.to_sym]
  end

  def add_area_to_radar_cross_section_size(radar_cross_section_size)
    if radar_cross_section_size.nil?
      radar_cross_section_size
    else
      conversion = {
        'SMALL': 'Small (area < 0.1)',
        'MEDIUM': 'Medium (0.1 < area < 1.0)',
        'LARGE': 'Large (area > 1.0)'
      }

      conversion[radar_cross_section_size.to_sym]
    end
  end

end
