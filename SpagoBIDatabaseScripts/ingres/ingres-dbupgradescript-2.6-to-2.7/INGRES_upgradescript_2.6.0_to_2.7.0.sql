--Chiara 28/08/2010
CREATE SEQUENCE SBI_KPI_DOCUMENTS_SEQ;\p\g
Create table SBI_KPI_DOCUMENTS (
	ID_KPI_DOC INTEGER  NOT NULL with default next value for SBI_KPI_DOCUMENTS_SEQ,
	BIOBJ_ID INTEGER NOT NULL,
	KPI_ID INTEGER NOT NULL,
 Primary Key (ID_KPI_DOC)
);\p\g

alter table SBI_KPI_DOCUMENTS ADD CONSTRAINT FK_SBI_KPI_DOC_1 foreign key (BIOBJ_ID) references SBI_OBJECTS (BIOBJ_ID) ;\p\g
alter table SBI_KPI_DOCUMENTS ADD CONSTRAINT FK_SBI_KPI_DOC_2 foreign key (KPI_ID) references SBI_KPI (KPI_ID);\p\g

INSERT INTO SBI_KPI_DOCUMENTS(KPI_ID,BIOBJ_ID)
SELECT k.KPI_ID, o.BIOBJ_ID
FROM SBI_KPI k,SBI_OBJECTS o
WHERE
k.DOCUMENT_LABEL = o.LABEL
and k.DOCUMENT_LABEL IS NOT NULL;

ALTER TABLE SBI_KPI DROP COLUMN document_label;

--Antonella 08/09/2010: generic user data properties management
CREATE SEQUENCE SBI_UDP_SEQ;\p\g
CREATE TABLE SBI_UDP (
	UDP_ID	        INTEGER NOT NULL with default next value for SBI_UDP_SEQ,
	TYPE_ID			INTEGER NOT NULL,
	FAMILY_ID		INTEGER NOT NULL,
	LABEL           VARCHAR(20) NOT NULL,
	NAME            VARCHAR(40) NOT NULL,
	DESCRIPTION     VARCHAR(1000) NULL,
	IS_MULTIVALUE   Smallint DEFAULT 0,    
 PRIMARY KEY (UDP_ID));\p\g
 
CREATE UNIQUE INDEX XAK1SBI_UDP ON SBI_UDP(LABEL ASC);\p\g
CREATE INDEX XIF3_SBI_SBI_UDP ON SBI_UDP(TYPE_ID ASC);\p\g
CREATE INDEX XIF2SBI_SBI_UDP ON SBI_UDP(FAMILY_ID ASC);\p\g
 
ALTER TABLE SBI_UDP ADD CONSTRAINT FK_SBI_SBI_UDP_1 FOREIGN KEY ( TYPE_ID ) REFERENCES SBI_DOMAINS ( VALUE_ID );\p\g
ALTER TABLE SBI_UDP ADD CONSTRAINT FK_SBI_SBI_UDP_2 FOREIGN KEY ( FAMILY_ID ) REFERENCES SBI_DOMAINS ( VALUE_ID );\p\g

CREATE SEQUENCE SBI_UDP_VALUE_SEQ;\p\g
CREATE TABLE SBI_UDP_VALUE (
	UDP_VALUE_ID       INTEGER NOT NULL with default next value for SBI_UDP_VALUE_SEQ,
	UDP_ID			   INTEGER NOT NULL,
	VALUE              VARCHAR(1000) NOT NULL,
	PROG               INTEGER NULL,
	LABEL              VARCHAR(20) NULL,
	NAME               VARCHAR(40) NULL,
	FAMILY			   VARCHAR(40) NULL,
    BEGIN_TS           TIMESTAMP NOT NULL,
    END_TS             TIMESTAMP NULL,
    REFERENCE_ID	   INTEGER NULL,	
 PRIMARY KEY (UDP_VALUE_ID));\p\g
 
CREATE INDEX XIF2SBI_SBI_UDP_VALUE ON SBI_UDP_VALUE(UDP_ID ASC);\p\g

ALTER TABLE SBI_UDP_VALUE ADD CONSTRAINT FK_SBI_UDP_VALUE_2 FOREIGN KEY ( UDP_ID ) REFERENCES SBI_UDP ( UDP_ID );\p\g

--adds new funcionality for udp management
INSERT INTO SBI_USER_FUNC (NAME, DESCRIPTION) VALUES ('UserDefinedPropertyManagement', 'UserDefinedPropertyManagement');\p\g
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
 SELECT a.VALUE_ID  , b.USER_FUNCT_ID FROM
 (
  SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'ROLE_TYPE' AND VALUE_CD = 'ADMIN' 
 ) a( VALUE_ID ) ,
 (
  SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME='UserDefinedPropertyManagement'
 ) b(USER_FUNCT_ID );\p\g
COMMIT;\p\g
---KPI RELATIONS
CREATE SEQUENCE SBI_KPI_REL_SEQ;\p\g
CREATE TABLE SBI_KPI_REL (
  KPI_REL_ID INTEGER NOT NULL with default next value for SBI_KPI_REL_SEQ,
  KPI_FATHER_ID INTEGER  NOT NULL,
  KPI_CHILD_ID INTEGER  NOT NULL,
  PARAMETER VARCHAR(100) NULL,
  PRIMARY KEY (KPI_REL_ID)
);\p\g
ALTER TABLE SBI_KPI_REL ADD CONSTRAINT FK_SBI_KPI_REL_2 FOREIGN KEY ( KPI_REL_ID ) REFERENCES SBI_KPI ( KPI_ID );\p\g

-- KPI ERRORS 28/09/2010
CREATE SEQUENCE SBI_KPI_ERROR_SEQ
\p\g
CREATE TABLE SBI_KPI_ERROR (
	KPI_ERROR_ID	        INTEGER NOT NULL with default next value for SBI_KPI_ERROR_SEQ,
	KPI_MODEL_INST_ID			INTEGER NOT NULL,
  USER_MSG              VARCHAR(1000) NULL,
  FULL_MSG              Long nvarchar NULL,
  TS_DATE               TIMESTAMP NULL,
  LABEL_MOD_INST        VARCHAR(100) NULL,
	PARAMETERS            VARCHAR(1000) NULL,
 PRIMARY KEY (KPI_ERROR_ID))
 \p\g
 
 alter table SBI_KPI_ERROR ADD CONSTRAINT FK_SBI_KPI_ERROR_MODEL_1 foreign key (KPI_MODEL_INST_ID) references SBI_KPI_MODEL_INST(KPI_MODEL_INST);\p\g 

--Chiara 28/09/2010
DROP TABLE SBI_KPI_MODEL_ATTR_VAL; \p\g
DROP TABLE SBI_KPI_MODEL_ATTR; \p\g


-- Organization Unit
CREATE TABLE SBI_ORG_UNIT (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR(100) NOT NULL,
  NAME             VARCHAR(100) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  UNIQUE (LABEL, NAME),
  PRIMARY KEY (ID)
) ;\p\g

CREATE TABLE SBI_ORG_UNIT_HIERARCHIES (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR(100) NOT NULL,
  NAME             VARCHAR(200) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  TARGET     VARCHAR(1000),
  COMPANY    VARCHAR(100),
  UNIQUE (LABEL, COMPANY),
  PRIMARY KEY (ID)
) ;\p\g

CREATE TABLE SBI_ORG_UNIT_NODES (
  NODE_ID            INTEGER NOT NULL,
  OU_ID           INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  PARENT_NODE_ID INTEGER NULL,
  PATH VARCHAR(4000) NOT NULL,
  PRIMARY KEY (NODE_ID)
) ;\p\g

CREATE TABLE SBI_ORG_UNIT_GRANT (
  ID INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  START_DATE  Date,
  END_DATE  Date,
  LABEL            VARCHAR(200) NOT NULL,
  NAME             VARCHAR(400) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  UNIQUE (LABEL),
  PRIMARY KEY (ID)
) ;\p\g

CREATE TABLE SBI_ORG_UNIT_GRANT_NODES (
  NODE_ID INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  GRANT_ID INTEGER NOT NULL,
  PRIMARY KEY (NODE_ID, KPI_MODEL_INST_NODE_ID, GRANT_ID)
) ;\p\g

ALTER TABLE SBI_ORG_UNIT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_NODES_1 FOREIGN KEY ( OU_ID ) REFERENCES SBI_ORG_UNIT ( ID ) ON DELETE CASCADE;\p\g
ALTER TABLE SBI_ORG_UNIT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_NODES_2 FOREIGN KEY ( HIERARCHY_ID ) REFERENCES SBI_ORG_UNIT_HIERARCHIES ( ID ) ON DELETE CASCADE;\p\g
ALTER TABLE SBI_ORG_UNIT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_NODES_3 FOREIGN KEY ( PARENT_NODE_ID ) REFERENCES SBI_ORG_UNIT_NODES ( NODE_ID ) ON DELETE CASCADE;\p\g
ALTER TABLE SBI_ORG_UNIT_GRANT ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_2 FOREIGN KEY ( HIERARCHY_ID ) REFERENCES SBI_ORG_UNIT_HIERARCHIES ( ID ) ON DELETE CASCADE;\p\g
ALTER TABLE SBI_ORG_UNIT_GRANT ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_3 FOREIGN KEY ( KPI_MODEL_INST_NODE_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST ) ON DELETE CASCADE;\p\g
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_NODES_1 FOREIGN KEY ( NODE_ID ) REFERENCES SBI_ORG_UNIT_NODES ( NODE_ID ) ON DELETE CASCADE;\p\g
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_NODES_2 FOREIGN KEY ( KPI_MODEL_INST_NODE_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST ) ON DELETE CASCADE;\p\g
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_NODES_3 FOREIGN KEY ( GRANT_ID ) REFERENCES SBI_ORG_UNIT_GRANT ( ID ) ON DELETE CASCADE;\p\g

--new column on SBI_KPI
ALTER TABLE SBI_KPI ADD COLUMN IS_ADDITIVE CHAR(1); \p\g
--ADD COLUMN ORG_UNIT_ID
ALTER TABLE SBI_KPI_VALUE add COLUMN ORG_UNIT_ID INTEGER; \p\g
ALTER TABLE SBI_KPI_VALUE ADD CONSTRAINT FK_SBI_KPI_VALUE_3 FOREIGN KEY (ORG_UNIT_ID) REFERENCES SBI_ORG_UNIT (ID) ON DELETE CASCADE; \p\g
--analytical drivers are visible by default
UPDATE SBI_OBJ_PAR SET VIEW_FL = 1;\p\g
COMMIT;\p\g
--BUG ON DUPLICATE ROLE NAMES
ALTER TABLE SBI_EXT_ROLES ALTER COLUMN NAME NOT NULL;\p\g 
ALTER TABLE SBI_EXT_ROLES ADD CONSTRAINT XHANAME UNIQUE (NAME);\p\g
 --KPI ENGINE : added hierarchy as parameter to filter grants
 --added company 
ALTER TABLE SBI_KPI_VALUE add COLUMN HIERARCHY_ID integer;\p\g 
ALTER TABLE SBI_KPI_VALUE ADD CONSTRAINT FK_SBI_KPI_VALUE_4 FOREIGN KEY (HIERARCHY_ID) REFERENCES SBI_ORG_UNIT_HIERARCHIES (ID) ON DELETE CASCADE;\p\g 
ALTER TABLE SBI_KPI_VALUE add COLUMN COMPANY VARCHAR(200);\p\g 
