[![Build Status](https://travis-ci.org/rossettistone/inspector-gadget.svg?branch=master)](https://travis-ci.org/rossettistone/inspector-gadget)
[![Code Climate](https://codeclimate.com/github/rossettistone/inspector-gadget/badges/gpa.svg)](https://codeclimate.com/github/rossettistone/inspector-gadget)
[![Test Coverage](https://codeclimate.com/github/rossettistone/inspector-gadget/badges/coverage.svg)](https://codeclimate.com/github/rossettistone/inspector-gadget/coverage)

# Requirements
1. [Docker](https://www.docker.com/products/overview) v1.12.1

# Getting Started

1. Copy GIS files to **/data/gis/**. At the moment, files are City GIS data that has not been made public yet.
1. If necessary, configure the web and database containers in **docker-compose.yml** and run`docker-compose build`. This will build all the necessary containers. You will also need to rebuild the container if you change the Gemfile.
1. If necessary, configure the databse settings by modifying **config/database.yml**. With the settings in place, create and setup the database: `docker-compose run web rake db:setup`.
1. Make sure eveything is working by running our tests: `docker-compose run web bundle exec rspec`.
1. Follow the instructions from [Running the App](#running-the-app), [Perparing the Database](#preparing-the-database), and [Seeding](#seeding).

# Running the App

- You can serve the app by running: `docker-compose up`
- Tou can interact with a rails console by running: `docker-compose run web rails console`
- In order to interact with the application in development, you will need to create a test user. You can achieve this by running `User.create!({:email => "jane.doe@longbeach.gov", :password => "hunter2", :password_confirmation => "hunter2" })` on the rails console.

## Preparing the Database

`postgres 9.5`
`postgis 2.2.x`

The city of Long Beach uses a "state plane" coordinate projection system by default for most of its GIS data. This application needs to ingest city-created GIS data, but postgis does not include this particular projection by default. It is readily available for import from spatialreference.org at http://spatialreference.org/ref/esri/102645/. Run the following query directly against the database to insert the projection information:

`INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 102645, 'esri', 102645, '+proj=lcc +lat_1=34.03333333333333 +lat_2=35.46666666666667 +lat_0=33.5 +lon_0=-118 +x_0=2000000 +y_0=500000.0000000002 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs ', 'PROJCS["NAD_1983_StatePlane_California_V_FIPS_0405_Feet",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["False_Easting",6561666.666666666],PARAMETER["False_Northing",1640416.666666667],PARAMETER["Central_Meridian",-118],PARAMETER["Standard_Parallel_1",34.03333333333333],PARAMETER["Standard_Parallel_2",35.46666666666667],PARAMETER["Latitude_Of_Origin",33.5],UNIT["Foot_US",0.30480060960121924],AUTHORITY["EPSG","102645"]]');`

Note that the above query has one small change from the query available on spatialreference.org: it removes a preceding "9" from the SRID `9102645` to make it `102645`. It seems as though the 9 was a remnant of darker times. This change was gleaned from a Stack post at http://gis.stackexchange.com/questions/69864/postgis-is-rejecting-an-srid-code-for-my-projection-ive-found-a-nearly-identic

## Seeding

1. `bundle exec rake db:seed:inspectors`
1. `bundle exec rake db:seed:inspection_types`
1. `bundle exec rake import:inspector_regions`

# Development and Maintenance Tasks

## Populating a Local Database

To get a snapshot of the production database for use locally, use Heroku's `pg:pull` feature, documented here: https://devcenter.heroku.com/articles/heroku-postgres-import-export

At time of writing, the following commands worked:
```bash
$ dropdb inspector_gadget_development
$ heroku pg:pull DATABASE_URL inspector_gadget_development --app inspector-gadget-cfa
```

## Updating Inspector Regions

From time to time, the way that inspections are assigned to inspectors may change. There are two general ways that these assignments will change:

1. Changing the underlying GIS data that defines which sections of the city are served by which inspectors and
1. Changing which types of inspections (e.g. plumbing, photovoltaic) are assigned to which inspectors

Because updating this data can have a major impact on the way the application peforms in production, it is recommended to **test these changes locally before deploying them**. See the section on "Populating a Local Database" in this document to set up an easy environment for trying this.

### Updating GIS Data

Inspector GIS data is imported by running a rake task (defined in `lib/tasks/import.rake`) at the command line: `bundle exec rake import:inspector_regions`
The task assumes that GIS relevant GIS data is stored in `data/gis/` as one or more zip files exported from ArcGIS. These zip files contain (among other things) a shapefile (`.shp`) that the RGeo gem can ingest and store in the database.

Each layer of the shapefile must include an attribute called `INSPECTOR` with an inspector's last name. Name comparison is done with SQL `ILIKE`, so is not case sensitive.

Running the task will generate a report in the console that indicates which GIS data was assigned to an inspector. Some GIS data will not be assigned to inspectors, as it may reference Signal Hill (SH) or sections within Long Beach that belong to LA County (LAC) and are therefore not managed by Long Beach inspectors.

### Updating Inspection Type Assignment Rules

Inspection assignments are made via the `inspector` instance method on the `Inspection` model (`app/models/inspection.rb`). For speed, this method makes use of a join table (effectively a caching table) called `assignments` (model in `app/models/assignment.rb`), which makes it fast to look up which *types* of inspections each inspector handles.

The `assignments` table is seeded by running `bundle exec rake db:seed:inspection_types`.
Because the table is built based on which inspection types inspectors handle (indicated by the `inspection_assignments` attribute on an `InspectorProfile`), it is advisable to update the and run the Inspector seeds (`db/seeds/inspectors.rb`) before seeding the `assignments` table.

So a typical process for updating the assignments would be:

1. Update the inspector seeds (`db/seeds/inspectors.rb`) with any assignment or personnel changes.
1. Update the inspection_type seeds (`db/seeds/inspection_types.rb`) with any assignment changes (see `assignment_categories` attribute on each row)
1. Run `bundle exec rake db:seed:inspectors`. This task should be idempotent, as it uses `find_or_create` for existing inspector records.
1. Run `bundle exec rake db:seed:inspection_types`. This task should be idempotent, as it uses `find_or_create` for inspection types, and recreates the `assignments` table from scratch each time.
1. Manually delete any inspectors that might no longer be needed (e.g. if they no longer work at the City). The seeds don't delete inspectors for data safety reasons.

