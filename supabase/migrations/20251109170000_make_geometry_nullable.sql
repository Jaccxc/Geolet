-- Make geometry fields nullable to allow initial seed without GeoJSON
alter table regions
  alter column centroid_lonlat drop not null,
  alter column bbox drop not null;

-- Add comments for clarity
comment on column regions.centroid_lonlat is 'Can be null initially, will be populated when GeoJSON data is available';
comment on column regions.bbox is 'Can be null initially, will be populated when GeoJSON data is available';
