module ApplicationHelper
  # Verifies the integrity of a two-line element set received from space-track.org using its checksum digit
  def verify_checksum(tles)
    puts tles
    checksum = Integer(tles[tles.length]) # Extract the checksum digit from the end of the tles
    tles = tles[0..tles.length] # Remove the checksum from the tles so we don't add it later
    puts checksum
    puts tles
    # Sum each digit in the tles, ignoring other characters (except -'s)
    sum = 0
    tles.each_char do |char|
      begin
        # Add the value of the number, if its a number
        sum += Integer(char)
      rescue
        # Add 1 if its a minus sign
        sum += 1 if char == '-'
      end
    end

    (sum % 10) == checksum
  end
end
