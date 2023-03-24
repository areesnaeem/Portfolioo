use udlswl;

create table nashville (
uniqueid int,
parcelid int,
landuse varchar(50),
propertyaddress varchar(255),
saledate date,
saleprice int,
legalreference int,
soldasvacant varchar(50),
ownername varchar(255),
owneraddress varchar (255),
acreage int,
taxdistrict varchar (100),
landvalue int,
buildingvalue int,
totalvalue int,
yearbuilt year,
bedrooms int,
fullbath int,
halfbath int);

show variables like "secure_file_priv";
ALTER TABLE nashville MODIFY COLUMN parcelid VARCHAR(50);
ALTER TABLE nashville MODIFY COLUMN saledate DATE;



load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nash.csv'
into table nashville
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nash.csv'
INTO TABLE nashville
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@parcelid, @saledate, @price, @propertyaddress, @owneraddress)
SET parcelid = @parcelid,
    saledate = STR_TO_DATE(@saledate, '%%m/%%d/%%Y'),
    saleprice = @price,
    propertyaddress = @propertyaddress,
    owneraddress = @owneraddress;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nash.csv'
INTO TABLE nashville
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@parcelid, @saledate, @price, @propertyaddress, @owneraddress)
SET parcelid = @parcelid,
    saledate = NULLIF(STR_TO_DATE(@saledate, '%%m/%%d/%%Y'), '0000-00-00'),
    saleprice = @price,
    propertyaddress = @propertyaddress,
    owneraddress = @owneraddress;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nash.csv'
INTO TABLE nashville
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@parcelid, @price, @propertyaddress, @owneraddress)
SET parcelid = @parcelid,
    saleprice = @price,
    propertyaddress = @propertyaddress,
    owneraddress = @owneraddress;

ALTER TABLE nashville
DROP COLUMN Acreage;

DESCRIBE nashville;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nash.csv'
INTO TABLE nashville
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nash.csv'
INTO TABLE nashville
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Finally succeeded at this point after so much error.
