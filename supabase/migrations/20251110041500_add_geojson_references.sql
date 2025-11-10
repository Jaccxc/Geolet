-- Add GeoJSON reference columns to regions table
-- This allows frontend to load GeoJSON files on-demand instead of storing geometry inline

ALTER TABLE regions
ADD COLUMN geojson_file text,
ADD COLUMN geojson_id_property text,
ADD COLUMN geojson_feature_id text;

-- Add comments
COMMENT ON COLUMN regions.geojson_file IS 'Path to GeoJSON file containing this region geometry (e.g., /geojson/countries.json)';
COMMENT ON COLUMN regions.geojson_id_property IS 'Property name in GeoJSON feature to match against (e.g., iso_a2, NAME_1)';
COMMENT ON COLUMN regions.geojson_feature_id IS 'Value to match in the GeoJSON feature properties (e.g., IN, Maharashtra)';

-- Update countries to reference countries.json
UPDATE regions SET
  geojson_file = '/geojson/countries.json',
  geojson_id_property = 'iso_a2',
  geojson_feature_id = key
WHERE kind = 'country';

-- Update Indian states to reference regions/IN.json
UPDATE regions SET
  geojson_file = '/geojson/regions/IN.json',
  geojson_id_property = 'NAME_1',
  geojson_feature_id = CASE key
    WHEN 'IN-AN' THEN 'Andaman and Nicobar'
    WHEN 'IN-AP' THEN 'Andhra Pradesh'
    WHEN 'IN-AR' THEN 'Arunachal Pradesh'
    WHEN 'IN-AS' THEN 'Assam'
    WHEN 'IN-BR' THEN 'Bihar'
    WHEN 'IN-CH' THEN 'Chandigarh'
    WHEN 'IN-CT' THEN 'Chhattisgarh'
    WHEN 'IN-DD' THEN 'Daman and Diu'
    WHEN 'IN-DL' THEN 'NCT of Delhi'
    WHEN 'IN-DN' THEN 'Dadra and Nagar Haveli'
    WHEN 'IN-GA' THEN 'Goa'
    WHEN 'IN-GJ' THEN 'Gujarat'
    WHEN 'IN-HP' THEN 'Himachal Pradesh'
    WHEN 'IN-HR' THEN 'Haryana'
    WHEN 'IN-JH' THEN 'Jharkhand'
    WHEN 'IN-JK' THEN 'Jammu and Kashmir'
    WHEN 'IN-KA' THEN 'Karnataka'
    WHEN 'IN-KL' THEN 'Kerala'
    WHEN 'IN-LD' THEN 'Lakshadweep'
    WHEN 'IN-MH' THEN 'Maharashtra'
    WHEN 'IN-ML' THEN 'Meghalaya'
    WHEN 'IN-MN' THEN 'Manipur'
    WHEN 'IN-MP' THEN 'Madhya Pradesh'
    WHEN 'IN-MZ' THEN 'Mizoram'
    WHEN 'IN-NL' THEN 'Nagaland'
    WHEN 'IN-OR' THEN 'Odisha'
    WHEN 'IN-PB' THEN 'Punjab'
    WHEN 'IN-PY' THEN 'Puducherry'
    WHEN 'IN-RJ' THEN 'Rajasthan'
    WHEN 'IN-SK' THEN 'Sikkim'
    WHEN 'IN-TG' THEN 'Telangana'
    WHEN 'IN-TN' THEN 'Tamil Nadu'
    WHEN 'IN-TR' THEN 'Tripura'
    WHEN 'IN-UP' THEN 'Uttar Pradesh'
    WHEN 'IN-UT' THEN 'Uttarakhand'
    WHEN 'IN-WB' THEN 'West Bengal'
  END
WHERE country = 'IN' AND kind = 'region';

-- Cities don't need GeoJSON (using centroid + tolerance for MVP)
-- Leave geojson_file NULL for cities
