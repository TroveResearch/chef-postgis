execute 'create_postgis_template' do
  not_if "psql -qAt --list | grep -q '^#{node['postgis']['template_name']}\|'", :user => 'postgres'
  user 'postgres'
  command <<CMD
(createdb -E UTF8 --locale=#{node['postgis']['locale']} #{node['postgis']['template_name']} -T template0) &&
(psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/postgis-2.0/postgis.sql) &&
(psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/postgis-2.0/spatial_ref_sys.sql) &&
(psql -d #{node['postgis']['template_name']} -c "GRANT ALL ON geometry_columns TO PUBLIC;") &&
(psql -d #{node['postgis']['template_name']} -c "GRANT ALL ON geography_columns TO PUBLIC;") &&
(psql -d #{node['postgis']['template_name']} -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;") 
CMD
  action :run
end
