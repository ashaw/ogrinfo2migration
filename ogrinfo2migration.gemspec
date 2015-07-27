Gem::Specification.new do |s|
  s.name        = 'ogrinfo2migration'
  s.version     = '0.0.4'
  s.date        = '2015-07-27'
  s.summary     = "Generate Rails migrations from shapefiles"
  s.description = "Generate Rails migrations from shapefiles"
  s.authors     = ["Al Shaw"]
  s.email       = 'almshaw@gmail.com'
  s.files       = ["lib/ogrinfo2migration.rb", "lib/tmpl.erb"]
  s.executables << 'ogrinfo2migration'
  s.homepage    =
    'https://github.com/ashaw/ogrinfo2migration'
  s.license       = 'MIT'
end
