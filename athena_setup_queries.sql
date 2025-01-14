------------------------------------------------------------------------
-- Set up the Overture Maps data tables in Amazon Athena on AWS
------------------------------------------------------------------------
-- The below Athena SQL queries will create tables in your AWS account's
-- data catalog pointing directly to data hosted on Overture's S3
-- bucket. You can then query Overture data directly from Athena without
-- needing to copy it.
--
-- 💡 TIP: Athena only allows one SQL statement to be run at a time, so
--         highlight and run each SQL query separately.
-- 💡 TIP: Overture's S3 bucket is located in the us-west-2 AWS region,
--         so use Athena in us-west-2 for best performance.
------------------------------------------------------------------------

-- Themes distributed since the October 2023 release are described using
-- compatible schemas and may be viewed as part of a unified table,
-- partitioned by `theme` and `type`.

CREATE EXTERNAL TABLE `overture` (
  `id` string,
  `geometry` binary,
  `bbox` struct<minx:double,maxx:double,miny:double,maxy:double>,
  `subtype` string,
  `localitytype` string,
  `names` struct<primary:string,common:map<string,string>,rules:array<struct<variant:string,language:string,value:string,at:array<double>,side:string>>>,
  `contextid` string,
  `adminlevel` int,
  `isocountrycodealpha2` string,
  `isosubcountrycode` string,
  `defaultlanguage` string,
  `drivingside` string,
  `version` int,
  `updatetime` string,
  `sources` array<struct<property:string,dataset:string,recordId:string,confidence:double>>,
  `ismaritime` boolean,
  `geopoldisplay` string,
  `localityid` string,
  `class` string,
  `sourcetags` map<string,string>,
  `wikidata` string,
  `surface` string,
  `elevation` int, 
  `issalt` boolean,
  `isintermittent` boolean,
  `hasparts` boolean,
  `height` double,
  `numfloors` int,
  `facadecolor` string,
  `facadematerial` string,
  `roofmaterial` string,
  `roofshape` string,
  `roofdirection` double,
  `rooforientation` string,
  `roofcolor` string,
  `eaveheight` double,
  `level` int,
  `minheight` double,
  `buildingid` string,
  `categories` struct<main:string,alternate:array<string>>,
  `confidence` double,
  `websites` array<string>,
  `socials` array<string>,
  `emails` array<string>,
  `phones` array<string>,
  `brand` struct<names:struct<common:array<struct<value:string,language:string>>,official:array<struct<value:string,language:string>>,alternate:array<struct<value:string,language:string>>,short:array<struct<value:string,language:string>>>,wikidata:string>,
  `addresses` array<struct<freeform:string,locality:string,postcode:string,region:string,country:string>>,
  `connectors` array<string>,
  `road` string)
PARTITIONED BY (
  `theme` string,
  `type` string)
STORED AS PARQUET
LOCATION
  's3://overturemaps-us-west-2/release/<release-version>/'


-- Load partitions
MSCK REPAIR TABLE `overture`;


-- =====================================================================
-- The below queries are for the July 2023 Data Release



-- Admins theme
-- =====================================================================

CREATE EXTERNAL TABLE `admins`(
  `id` string,
  `geometry` binary,
  `bbox` struct<minx:double,maxx:double,miny:double,maxy:double>,
  `subtype` string,
  `localitytype` string,
  `names` struct<common:array<struct<value:string,language:string>>,official:array<struct<value:string,language:string>>,alternate:array<struct<value:string,language:string>>,short:array<struct<value:string,language:string>>>,
  `contextid` string,
  `adminlevel` int,
  `isocountrycodealpha2` string,
  `isosubcountrycode` string,
  `defaultlanguage` string,
  `drivingside` string,
  `version` int,
  `updatetime` string,
  `sources` array<struct<property:string,dataset:string,recordId:string,confidence:double>>,
  `ismaritime` boolean,
  `geopoldisplay` string,
  `localityid` string)
PARTITIONED BY (
  `type` string)
STORED AS PARQUET
LOCATION
  's3://overturemaps-us-west-2/release/<release-version>/theme=admins'


-- Load partitions
MSCK REPAIR TABLE `admins`

-- =====================================================================
-- Base theme
-- =====================================================================

CREATE EXTERNAL TABLE `base`(
  `id` string,
  `geometry` binary,
  `bbox` struct<minx:double,maxx:double,miny:double,maxy:double>,
  `subtype` string,
  `names` struct<common:array<struct<value:string,language:string>>,official:array<struct<value:string,language:string>>,alternate:array<struct<value:string,language:string>>,short:array<struct<value:string,language:string>>>,
  `version` int,
  `updatetime` string,
  `sources` array<struct<property:string,dataset:string,recordId:string,confidence:double>>,
  `class` string,
  `sourcetags` map<string,string>,
  `wikidata` string,
  `surface` string,
  `issalt` boolean,
  `isintermittent` boolean)
PARTITIONED BY (
  `type` string)
STORED AS PARQUET
LOCATION
  's3://overturemaps-us-west-2/release/<release-version>/theme=base'


-- Load partitions
MSCK REPAIR TABLE `base`

-- =====================================================================
-- Buildings theme
-- =====================================================================

CREATE EXTERNAL TABLE `buildings`(
  `id` string,
  `geometry` binary,
  `bbox` struct<minx:double,maxx:double,miny:double,maxy:double>,
  `names` struct<common:array<struct<value:string,language:string>>,official:array<struct<value:string,language:string>>,alternate:array<struct<value:string,language:string>>,short:array<struct<value:string,language:string>>>,
  `version` int,
  `updatetime` string,
  `sources` array<struct<property:string,dataset:string,recordId:string,confidence:double>>,
  `class` string,
  `hasparts` boolean,
  `height` double,
  `numfloors` int,
  `facadecolor` string,
  `facadematerial` string,
  `roofmaterial` string,
  `roofshape` string,
  `roofdirection` double,
  `rooforientation` string,
  `roofcolor` string,
  `eaveheight` double,
  `level` int,
  `minheight` double,
  `buildingid` string)
PARTITIONED BY (
  `type` string)
STORED AS PARQUET
LOCATION
  's3://overturemaps-us-west-2/release/<release-version>/theme=buildings'


-- Load partitions
MSCK REPAIR TABLE `buildings`


-- =====================================================================
-- Places theme
-- =====================================================================

CREATE EXTERNAL TABLE `places`(
  `id` string,
  `geometry` binary,
  `bbox` struct<minx:double,maxx:double,miny:double,maxy:double>,
  `names` struct<common:array<struct<value:string,language:string>>,official:array<struct<value:string,language:string>>,alternate:array<struct<value:string,language:string>>,short:array<struct<value:string,language:string>>>,
  `version` int,
  `updatetime` string,
  `sources` array<struct<property:string,dataset:string,recordId:string,confidence:double>>,
  `categories` struct<main:string,alternate:array<string>>,
  `confidence` double,
  `websites` array<string>,
  `socials` array<string>,
  `emails` array<string>,
  `phones` array<string>,
  `brand` struct<names:struct<common:array<struct<value:string,language:string>>,official:array<struct<value:string,language:string>>,alternate:array<struct<value:string,language:string>>,short:array<struct<value:string,language:string>>>,wikidata:string>,
  `addresses` array<struct<freeform:string,locality:string,postcode:string,region:string,country:string>>)
PARTITIONED BY (
  `type` string)
STORED AS PARQUET
LOCATION
  's3://overturemaps-us-west-2/release/<release-version>/theme=places'


-- Load partitions
MSCK REPAIR TABLE `places`


-- =====================================================================
-- Transportation theme
-- =====================================================================

CREATE EXTERNAL TABLE `transportation`(
  `id` string,
  `geometry` binary,
  `bbox` struct<minx:double,maxx:double,miny:double,maxy:double>,
  `subtype` string,
  `version` int,
  `updatetime` string,
  `sources` array<struct<property:string,dataset:string,recordId:string,confidence:double>>,
  `level` int,
  `connectors` array<string>,
  `road` string)
PARTITIONED BY (
  `type` string)
STORED AS PARQUET
LOCATION
  's3://overturemaps-us-west-2/release/<release-version>/theme=transportation'


-- Load partitions
MSCK REPAIR TABLE `transportation`
