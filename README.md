# ogrinfo2migration

## Requirements

Rails 4+
activerecord-postgis-adapter 3+

## Installation

    gem install ogrinfo2migration

## Usage

    ogrinfo2migration <shapefile> </path/to/your_app/db/migrate>

## Example

  Using `ogrinfo2migration` on a [Census state cartographic boundary file](https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html) would result in a migration like so:

    class AddCb2014UsState500k < ActiveRecord::Migration
      def change
        create_table :cb_2014_us_state_500ks do |t|
            t.string :statefp
            t.string :statens
            t.string :affgeoid
            t.string :geoid
            t.string :stusps
            t.string :name
            t.string :lsad
            t.decimal :aland
            t.decimal :awater
          t.geometry :the_geom, limit: {:srid=>4269, :type=>"geometry"}
        end
        add_index :cb_2014_us_state_500ks, ["the_geom"], :name => "cb_2014_us_state_500ks_geometry_gist", :using => :gist    
      end
    end

NB1: Usually I change the table name to something more Railsy. In the example above, I would replace `create_table :cb_2014_us_state_500ks` with `create_table :states`, and update the index likewise. 

NB2: If you're using [SimpleTiles](https://github.com/propublica/simple-tiles), you may want to change the `srid` to `3857` so you don't have to reproject on the fly when generating map tiles.


