[![Code Climate](https://codeclimate.com/github/rossettistone/inspector-gadget/badges/gpa.svg)](https://codeclimate.com/github/rossettistone/inspector-gadget)
[![Test Coverage](https://codeclimate.com/github/rossettistone/inspector-gadget/badges/coverage.svg)](https://codeclimate.com/github/rossettistone/inspector-gadget/coverage)


# Requirements

- ruby v2.3.0
- Postgres 9.5+ (w/ the PostGIS extension)
- The right developer tools (if on OS X 10.11):
	- `xcode-select --install` (had to reinstall XCode dev tools for some reason)
	- `gem install nokogiri -v '1.6.7.2'`. If that fails to install, you can install with native extensions using `gem install nokogiri -v '1.6.7.2' -- --use-system-libraries`
	- [capybara-webkit](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit)
		- Has a dependency on Qt v5.5 at the time of writing
		- `brew tap homebrew/versions`
		-	`brew install qt55`
		- Force Homebrew to symlink those binaries into your /usr/local/bin directory you can run: `brew link --force qt55`

# Initial Setup

- Copy GIS files to **/data/gis/**. At the moment, files are City GIS data that has not been made public yet.
- `bundle install`
- `rake db:setup`
- Make sure everything is working: `bundle exec rspec`

## Seeding

1. `bundle exec rake db:seed:inspectors`
1. `bundle exec rake db:seed:inspection_types`
1. `bundle exec rake import:inspector_regions`

## Preparing the Database

`postgres 9.5`
`postgis 2.2.x`

The city of Long Beach uses a "state plane" coordinate projection system by default for most of its GIS data. This application needs to ingest city-created GIS data, but postgis does not include this particular projection by default. It is readily available for import from spatialreference.org at http://spatialreference.org/ref/esri/102645. Run the following query directly against the database to insert the projection information: 

`INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 102645, 'esri', 102645, '+proj=lcc +lat_1=34.03333333333333 +lat_2=35.46666666666667 +lat_0=33.5 +lon_0=-118 +x_0=2000000 +y_0=500000.0000000002 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs ', 'PROJCS["NAD_1983_StatePlane_California_V_FIPS_0405_Feet",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["False_Easting",6561666.666666666],PARAMETER["False_Northing",1640416.666666667],PARAMETER["Central_Meridian",-118],PARAMETER["Standard_Parallel_1",34.03333333333333],PARAMETER["Standard_Parallel_2",35.46666666666667],PARAMETER["Latitude_Of_Origin",33.5],UNIT["Foot_US",0.30480060960121924],AUTHORITY["EPSG","102645"]]');`

Note that the above query has one small change from the query available on spatialreference.org: it removes a preceding "9" from the SRID `9102645` to make it `102645`. It seems as though the 9 was a remnant of darker times. This change was gleaned from a Stack post at http://gis.stackexchange.com/questions/69864/postgis-is-rejecting-an-srid-code-for-my-projection-ive-found-a-nearly-identic
