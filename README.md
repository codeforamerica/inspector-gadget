## [UNMAINTAINED] This repository is not actively maintained, and issues, pull requests, and security warnings are not regularly reviewed or responded to. Any use of this repository is at your own risk, though you're always welcome to try filing an issue/PR on the off chance someone might see it! :-)

## Note: This repo was the basis for a building inspection scheduling and planning tool launched in the City of Long Beach in 2016. While the City maintains (as of 2019-09-14) a *similar* tool based on this codebase, this codebase is no longer under development, and is entirely separate from the codebase used in production by the city.

[![Build Status](https://travis-ci.org/rossettistone/inspector-gadget.svg?branch=master)](https://travis-ci.org/rossettistone/inspector-gadget)
[![Code Climate](https://codeclimate.com/github/rossettistone/inspector-gadget/badges/gpa.svg)](https://codeclimate.com/github/rossettistone/inspector-gadget)
[![Test Coverage](https://codeclimate.com/github/rossettistone/inspector-gadget/badges/coverage.svg)](https://codeclimate.com/github/rossettistone/inspector-gadget/coverage)

# Requirements
- [Docker](https://www.docker.com/products/overview) v1.12.1 (or higher)

# Getting Started

Configure the web and database containers in **docker-compose.yml** and run:
```
$ docker-compose build
```

This will build all the necessary containers. **Please note that you will also need to rebuild the container if you change the Gemfile of Gemfile.lock files.**

Next, follow the instructions from the [Perparing the Database](#preparing-the-database) and [Seeding](#seeding) sections.

## Preparing the Database

`postgres 9.5`
`postgis 2.2.x`

The City of Long Beach uses a "state plane" coordinate projection system by default for most of its GIS data. This application needs to ingest city-created GIS data, but postgis does not include this particular projection by default. It is readily available for import from spatialreference.org at http://spatialreference.org/ref/esri/102645/.

First, spin up the DB docker image:
```
$ docker-compose -f docker-compose.yml -f docker-compose.dev.yml up db
```

Configure the databse settings by modifying `config/database.yml`. With the settings in place, create and setup the database:
```
$ docker-compose -f docker-compose.yml -f docker-compose.dev.yml run web rake db:setup
```

Next, access the command line of the Inspector Gadget DB docker image:
```
$ docker exec -it inspectorgadget_db_1 /bin/bash
```

Switch to the `postgres` user:
```
$ su postgres
```

Next, run the following query directly against the database via `psql` to insert the projection information:

```bash
$ psql
$ \connect inspector_gadget_development
```

```sql
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 102645, 'esri', 102645, '+proj=lcc +lat_1=34.03333333333333 +lat_2=35.46666666666667 +lat_0=33.5 +lon_0=-118 +x_0=2000000 +y_0=500000.0000000002 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs ', 'PROJCS["NAD_1983_StatePlane_California_V_FIPS_0405_Feet",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["False_Easting",6561666.666666666],PARAMETER["False_Northing",1640416.666666667],PARAMETER["Central_Meridian",-118],PARAMETER["Standard_Parallel_1",34.03333333333333],PARAMETER["Standard_Parallel_2",35.46666666666667],PARAMETER["Latitude_Of_Origin",33.5],UNIT["Foot_US",0.30480060960121924],AUTHORITY["EPSG","102645"]]');
```

Note that the above query has one small change from the query available on spatialreference.org: it removes a preceding "9" from the SRID `9102645` to make it `102645`. It seems as though the 9 was a remnant of darker times. This change was gleaned from this [Stack Exchange post](http://gis.stackexchange.com/questions/69864/postgis-is-rejecting-an-srid-code-for-my-projection-ive-found-a-nearly-identic).

Repeat the above step for the `inspector_gadget_test` database. After running the above DDL INSERT statement, be sure to exit out of the postgres and container shells respectively.

## Seeding

While the `db` image is running, populate the database with seeds via rake:

1. `docker-compose -f docker-compose.yml -f docker-compose.dev.yml run web bundle exec rake db:seed:inspectors`
1. `docker-compose -f docker-compose.yml -f docker-compose.dev.yml run web bundle exec rake db:seed:inspection_types`
1. `docker-compose -f docker-compose.yml -f docker-compose.dev.yml run web bundle exec rake import:inspector_regions`

## Testing

Make sure eveything is working by running our tests:
```
$ docker-compose -f docker-compose.yml -f docker-compose.dev.yml run web bundle exec rspec
```

# Running the App

- You can serve the app (in development mode) by running: `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up`
- You can interact with a rails console by running: `docker-compose run web rails console`
- In order to interact with the application in development, you will need to create a test user. For example, you can achieve this by running something like `User.create!({:email => "jane.doe@longbeach.gov", :password => "hunter2", :password_confirmation => "hunter2" })` on the rails console to create your test user.

# Architecture Overview

## How Inspections are Assigned to Inspectors

When inspections are *viewed* (e.g. on the `/inspections_print` or `/reports` pages), the inspector for each inspection is displayed. This relationship is not stored in the database, though, but rather calculated on the fly, and involves enough steps/associations that it bears explaining here.

1. An `Inspection` (see `models/inspection.rb`) calls its `inspector` method. This method gets a list of all inspectors that serve the `InspectionType` for that `Inspection` (e.g. all fire inspectors), then finds which of those inspectors is responsible for the GIS area where the `Inspection` is located.

1. To get the list of inspectors for that `InspectionType`, the `Inspection` delegates delegates to a method on the `InspectionType` called `possible_inspectors`. 

1. The `possible_inspectors` method uses an association called `inspector_profiles` to find all the inspectors for that `InspectionType`. A couple of things to note about this association:

  - This association exists *through* the `assignments` table. This table is created by a seed task (`db/seeds/inspection_types.rb`) that contains one row for every pairing of an `InspectionType` and an inspector. This table is only ever built by a rake task, and only needs to be changed if the `InspectionType` assignments change in the app (e.g. if an inspector joins or leaves the City). For more info on building this table, see the "Updating Inspection Type Assignment Rules" section of this README.

  - This association is with the `InspectorProfile` model, not the `Inspector` model. This is because the `Inspector` model is actually just an extension of the `User` class, and doesn't contain information specific to inspectors - that's stored on the `InspectorProfile` model, which each `Inspector` model `has_one` of.

# Development and Maintenance Tasks

## Populating a Local Database

Heroku provides a database import feature. Because importing an entire database is a major operation, and has the potential to overwrite or destroy data, the command line utility has several warnings before it begins work.

First, make sure the `web` container is up. You can accomplish this by running:
```bash
$ docker-compose -f docker-compose.yml -f docker-compose.dev.yml up web
```

Next, access the command line of the Inspector Gadget web container:
```bash
$ docker exec -it inspectorgadget_web_1 /bin/bash
```

Next, login to Heroku with your account credentials:
```bash
$ heroku
```

Afterward, create a new backup of the current state of the database:
```bash
$ heroku pg:backups capture --app inspector-gadget-cfa
```

Download the dump to the project directory:
```bash
$ curl -o latest.dump `heroku pg:backups public-url --app inspector-gadget-cfa`
```

Close/terminate the web image bash session after downloading the dump.

Next, access the command line of the Bizport DB docker image:
```bash
$ docker exec -it inspectorgadget_db_1 /bin/bash
```

Then restore from latest.dump with `pg_restore`:
```bash
$ su postgres
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d inspector_gadget_development /inspector-gadget/latest.dump
```

Close/terminate the inspectorgadget_db_1 image bash session. You are now ready to [start the web application](#running-the-app) with a copy of production data.

## Updating Inspector Regions

From time to time, the way that inspections are assigned to inspectors may change. There are two general ways that these assignments will change:

1. Changing the underlying GIS data that defines which sections of the city are served by which inspectors; and
1. Changing which types of inspections (e.g. plumbing, photovoltaic) are assigned to which inspectors

Because updating this data can have a major impact on the way the application peforms in production, it is recommended to **test these changes locally before deploying them**. See the section on "Populating a Local Database" in this document to set up an easy environment for trying this.

### Updating GIS Data

Inspector GIS data is imported by running a rake task (defined in `lib/tasks/import.rake`) at the command line: `bundle exec rake import:inspector_regions`. The task assumes that the `B_Insp_Com.zip`, `B_Insp_Ele.zip`, and `B_Insp_Res.zip` source GIS data files are stored in `data/gis/` as one or more zip files exported from ArcGIS. These zip files contain (among other things) a shapefile (`.shp`) that the RGeo gem can ingest and store in the database. These files are provided by the City of Long Beach GIS team.

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


