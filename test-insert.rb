require 'pp'
require 'sqlite3'
require_relative('sqlite3-field.rb')
require_relative('sqlite3-session.rb')
require_relative('sqlite3-table-schema.rb')

def main

  sqlite_session = SQLite3DatabaseSession.new('sandbox')
  
  # Clean up prior testing
  query = "DROP TABLE IF EXISTS ballparks;"
  sqlite_session.execute_query(query)
  
  # Define the ballparks table structure
  raw_field_data = [
    ['park_id', 'INTEGER', true],
    ['primary_name', 'TEXT'],
    ['alternate_names', 'TEXT'],
    ['home_team', 'TEXT'],
    ['league', 'TEXT'],
    ['street_address', 'TEXT'],
    ['city', 'TEXT'],
    ['state', 'TEXT'],
    ['zip', 'TEXT'],
    ['latitude', 'REAL'],
    ['longitude', 'REAL'],
    ['active_status', 'BOOLEAN'],
    ['places_photo_filename', 'TEXT'],
    ['places_photo_attribution', 'TEXT'],
    ['mlb_website_url', 'TEXT']
  ]
  
  # Build and execute the table creation query.
  ballparks_table_schema = SQLite3TableSchema.new('ballparks')
  ballparks_table_schema.parse_raw_table_data(raw_field_data)
  query = ballparks_table_schema.table_creation_query
  sqlite_session.execute_query(query)
  
  # Insert a value into the ballparks table
  query = "INSERT INTO ballparks
    (
      primary_name, 
      home_team, 
      league, 
      latitude, 
      longitude, 
      active_status
    ) VALUES 
    (
      'Minute Maid Park',
      'Houston Astros',
      'National League',
      29.7572103,
      -95.3553691,
      1
    );"
  sqlite_session.execute_query(query)
  
  # Select some data from the ballparks table
  query = "SELECT primary_name, latitude + 100, longitude FROM ballparks;"
  sqlite_session.execute_query(query)
  
  # Show pride for minute maid park
  sqlite_session.result.each do |row|
    p "#{row[0]} is the best!"
    p "Find it on the map: #{row[1]}, #{row[2] + 25}"
    pp row
  end
  
end

main
