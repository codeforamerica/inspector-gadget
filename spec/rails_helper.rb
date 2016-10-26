# Added to top of file per instructions on CodeClimate
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'chosen-rails/rspec'
require 'capybara/rails'
require 'capybara/rspec'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include FactoryGirl::Syntax::Methods

  Capybara.default_driver = :webkit
  Capybara::Webkit.configure do |config|
    config.block_unknown_urls
  end
  # hack for Capybara tests
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end
  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, { except: %w[spatial_ref_sys] }
    DatabaseCleaner.clean_with :truncation, { except: %w[spatial_ref_sys] }
    load "#{Rails.root}/db/seeds/inspectors.rb"
    load "#{Rails.root}/db/seeds/inspection_types.rb"

    # inspector region GIS data isn't available on the test server
    unless config.exclusion_filter.rules[:ci_skip] == true
      ActiveRecord::Base.connection.execute(%Q|DELETE FROM spatial_ref_sys where srid = 102645|)
      ActiveRecord::Base.connection.execute(%Q|INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 102645, 'esri', 102645, '+proj=lcc +lat_1=34.03333333333333 +lat_2=35.46666666666667 +lat_0=33.5 +lon_0=-118 +x_0=2000000 +y_0=500000.0000000002 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs ', 'PROJCS["NAD_1983_StatePlane_California_V_FIPS_0405_Feet",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["False_Easting",6561666.666666666],PARAMETER["False_Northing",1640416.666666667],PARAMETER["Central_Meridian",-118],PARAMETER["Standard_Parallel_1",34.03333333333333],PARAMETER["Standard_Parallel_2",35.46666666666667],PARAMETER["Latitude_Of_Origin",33.5],UNIT["Foot_US",0.30480060960121924],AUTHORITY["EPSG","102645"]]');|)

      require 'rake'
      Rails.application.load_tasks
      Rake::Task['import:inspector_regions'].invoke
    end
  end


  # GEOCODER STUBS
  Geocoder.configure(lookup: :test)

  Geocoder::Lookup::Test.add_stub(
    '333 West Ocean Blvd, Long Beach, CA, 90802', [
      {
        'latitude'     => 33.767949,
        'longitude'    => -118.1958298,
        'address'      => '333 W Ocean Blvd, Long Beach, CA 90802, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
    '2061 Snowden, Long Beach, CA, ', [
      {
        'latitude'     => 33.793579,
        'longitude'    => -118.11194,
        'address'      => '2061 Snowden Ave, Long Beach, CA 90815, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
    '4350 Sunfield Ave, Long Beach, CA, ', [
      {
        'latitude'     => 33.837587,
        'longitude'    => -118.134658,
        'address'      => '4350 Sunfield Ave, Long Beach, CA 90808, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
    '2326 Olive Ave, Long Beach, CA, ', [
      {
        'latitude'     => 33.799485,
        'longitude'    => -118.182539,
        'address'      => '2326 Olive Ave, Long Beach, CA 90806, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
    '3067 Charlemagne, Long Beach, CA, ', [
      {
        'latitude'     => 33.812648,
        'longitude'    => -118.13071,
        'address'      => '3067 Charlemagne Ave, Long Beach, CA 90808, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
    '2821 Daisy Ave, Long Beach, CA, ', [
      {
        'latitude'     => 33.808427,
        'longitude'    => -118.199461,
        'address'      => '2821 Daisy Ave, Long Beach, CA 90806, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
    '1911 E 63rd St, Long Beach, CA, ', [
      {
        'latitude'     => 33.869464,
        'longitude'    => -118.169395,
        'address'      => '1911 E 63rd St, Long Beach, CA 90805, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
    '2810 Eucalyptus Avenue, Long Beach, CA, 90806', [
      {
        'latitude'     => 33.808307,
        'longitude'    => -118.196657,
        'address'      => '2810 Eucalyptus Avenue, Long Beach, CA 90806, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
    '5433 Lemon Avenue, Long Beach, CA, ', [
      {
        'latitude'     => 33.8550275,
        'longitude'    => -118.179379,
        'address'      => '5433 Lemon Ave, Long Beach, CA 90805, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
    '1000 Marietta Ct, Long Beach, CA, ', [
      {
        'latitude'     => 33.7789851,
        'longitude'    => -118.1833913,
        'address'      => '1000 Marietta Ct, Long Beach, CA 90813, USA',
        'state'        => 'Long Beach',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )

end
