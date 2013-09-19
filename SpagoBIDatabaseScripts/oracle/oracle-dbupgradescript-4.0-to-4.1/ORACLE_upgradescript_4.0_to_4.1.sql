/* to check:
CREATE TABLE  SBI_COMMUNITY(
  COMMUNITY_ID int(11) NOT NULL AUTO_INCREMENT,
  NAME varchar(200) NOT NULL,
  DESCRIPTION varchar(350) DEFAULT NULL,
  OWNER int(11) NOT NULL,
  FUNCT_CODE varchar(40) DEFAULT NULL,
  CREATION_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  LAST_CHANGE_DATE timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  TIME_UP timestamp NULL DEFAULT NULL,
  TIME_DE timestamp NULL DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  PRIMARY KEY (COMMUNITY_ID)
);

CREATE TABLE SBI_COMMUNITY_USERS (
  `COMMUNITY_ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  CREATION_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  LAST_CHANGE_DATE timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  TIME_UP timestamp NULL DEFAULT NULL,
  TIME_DE timestamp NULL DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  PRIMARY KEY (`COMMUNITY_ID`,`USER_ID`),
  CONSTRAINT `FK_COMMUNITY` FOREIGN KEY (`COMMUNITY_ID`) REFERENCES `SBI_COMMUNITY` (`COMMUNITY_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_USER` FOREIGN KEY (`USER_ID`) REFERENCES `SBI_USER` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;

*/

ALTER TABLE SBI_OBJECTS ADD PREVIEW_FILE VARCHAR2(100) NULL;

INSERT INTO SBI_USER_FUNC (USER_FUNCT_ID, NAME, DESCRIPTION, USER_IN, TIME_IN)
    VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_USER_FUNC'), 
    'MeasuresCatalogueManagement','MeasuresCatalogueManagement', 'server', current_timestamp);
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_USER_FUNC';

INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'MeasuresCatalogueManagement'));
commit;

INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'CreateWorksheetFromDatasetUserFunctionality'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'DEV_ROLE' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'CreateWorksheetFromDatasetUserFunctionality'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'TEST_ROLE' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'CreateWorksheetFromDatasetUserFunctionality'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'MODEL_ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'CreateWorksheetFromDatasetUserFunctionality'));
commit;

CREATE TABLE SBI_GEO_LAYERS (
  	LAYER_ID 			 INTEGER NOT NULL,
  	LABEL 				 VARCHAR2(100) NOT NULL,
  	NAME 				 VARCHAR2(100),
  	DESCR 				 VARCHAR2(100),
  	LAYER_DEFINITION 	 BLOB NOT NULL,
  	TYPE 				 VARCHAR2(40),
	USER_IN              VARCHAR2(100) NOT NULL,
    USER_UP              VARCHAR2(100),
    USER_DE              VARCHAR2(100),
	TIME_IN              TIMESTAMP NOT NULL,
	TIME_UP              TIMESTAMP DEFAULT NULL,    
	TIME_DE              TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN       VARCHAR2(10),
	SBI_VERSION_UP       VARCHAR2(10),
	SBI_VERSION_DE       VARCHAR2(10),
	META_VERSION         VARCHAR2(100),
	ORGANIZATION         VARCHAR2(20),
  	CONSTRAINT LABEL_UNIQUE UNIQUE (LABEL,ORGANIZATION),
  	PRIMARY KEY (LAYER_ID)
) ;


INSERT into SBI_DOMAINS (VALUE_ID, VALUE_CD,VALUE_NM,DOMAIN_CD,DOMAIN_NM,VALUE_DS, USER_IN) 
values ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'),'FILE','FILE','LAYER_TYPE','Layer Type','Layer Type','');
UPDATE hibernate_sequences SET next_val = (SELECT MAX(VALUE_ID) + 1 FROM SBI_DOMAINS) WHERE sequence_name = 'SBI_DOMAINS';  

INSERT into SBI_DOMAINS (VALUE_ID, VALUE_CD,VALUE_NM,DOMAIN_CD,DOMAIN_NM,VALUE_DS, USER_IN) 
values ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'),'WFS','WFS','LAYER_TYPE','Layer Type','Layer Type','');
UPDATE hibernate_sequences SET next_val = (SELECT MAX(VALUE_ID) + 1 FROM SBI_DOMAINS) WHERE sequence_name = 'SBI_DOMAINS';  

INSERT INTO SBI_USER_FUNC (USER_FUNCT_ID, NAME, DESCRIPTION, USER_IN, TIME_IN)
    VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_USER_FUNC'), 
    'GeoLayersManagement','GeoLayersManagement', 'server', current_timestamp);
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_USER_FUNC';

INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'GeoLayersManagement'));
commit;


ALTER TABLE SBI_COMMUNITY ADD UNIQUE INDEX NAME_UNIQUE (ORGANIZATION, NAME ASC) ; 

ALTER TABLE SBI_OBJECTS ADD COLUMN IS_PUBLIC SMALLINT DEFAULT 0;
UPDATE SBI_OBJECTS SET IS_PUBLIC = 1;

ALTER TABLE SBI_DATA_SET ADD PERSIST_TABLE_NAME VARCHAR2(50) NULL;

ALTER TABLE SBI_DATA_SET DROP COLUMN IS_FLAT_DATASET;
ALTER TABLE SBI_DATA_SET DROP COLUMN FLAT_TABLE_NAME;
ALTER TABLE SBI_DATA_SET DROP COLUMN DATA_SOURCE_FLAT_ID;

INSERT INTO SBI_DOMAINS (VALUE_ID, VALUE_CD,VALUE_NM,DOMAIN_CD,DOMAIN_NM,VALUE_DS, USER_IN, TIME_IN)
	VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'),
	'Flat','SbiFlatDataSet','DATA_SET_TYPE','Data Set Type','SbiFlatDataSet', 'biadmin', current_timestamp);
update HIBERNATE_SEQUENCES set next_val = next_val+1 where  sequence_name = 'SBI_DOMAINS';
commit;