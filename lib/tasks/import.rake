namespace :import do

  task :inspector_regions => :environment do
    import_inspector_regions
  end

end

def import_inspector_regions
  require 'zip'

  gis_files_path = './data/gis/'
  zipfiles = Dir.entries(gis_files_path).select{|name| name.match('zip')}
  zipfiles.each do |zipfile|
    Zip::File.open(gis_files_path+zipfile) do |contents|
      contents.each{|file| file.extract(gis_files_path+file.name){ true } }
    end
    shp_path = gis_files_path + Dir.entries(gis_files_path).find{|f| f.match('shp(?!\.xml)')}
    handle_shapefile(shp_path)
  end
end


private

def handle_shapefile(shapefile_path)
  RGeo::Shapefile::Reader.open(shapefile_path) do |file|
    file.each do |record|
      region_latlong_text = ActiveRecord::Base.connection.execute("SELECT ST_AsText(ST_Transform(ST_GeomFromText('#{record.geometry.as_text}',102645),4326)) As region;").first['region']
      inspector_name = record.attributes['INSPECTOR']
      assign_inspector_region(inspector_name, region_latlong_text)
    end
    file.rewind
    record = file.next
  end
  # to transform from state plane to WGR 4326
  # "SELECT ST_AsText(ST_Transform(ST_GeomFromText('POLYGON((743238 2967416,743238 2967450,743265 2967450,743265.625 2967416,743238 2967416))',102645),4326)) As wgs_geom;"
end

def assign_inspector_region(inspector_name, region)
  inspector = Inspector.find_by('name ILIKE ?', inspector_name.split(' ').last)
  if inspector.present?
    profile = inspector.inspector_profile || inspector.create_inspector_profile
    profile.update_attributes(inspection_region: region)
    puts "Found region for #{inspector_name}. Assigned to #{inspector.name}."
  else
    puts "No inspector found in DB for name #{inspector_name}."
  end
end
