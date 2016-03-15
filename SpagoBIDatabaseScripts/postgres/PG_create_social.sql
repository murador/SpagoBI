CREATE TABLE TWITTER_HIBERNATE_SEQUENCES (
  SEQUENCE_NAME VARCHAR(200) NOT NULL,
  NEXT_VAL INTEGER NOT NULL,
  PRIMARY KEY (SEQUENCE_NAME)
)WITHOUT OIDS;

CREATE TABLE TWITTER_USERS (
	USER_ID 				BIGINT NOT NULL,
	USERNAME 				VARCHAR(45) NOT NULL,
	DESCRIPTION 			VARCHAR(200) NULL DEFAULT NULL,
	FOLLOWERS_COUNT 		INTEGER NOT NULL DEFAULT '0',
	PROFILE_IMAGE_SOURCE 	VARCHAR(200) NOT NULL,
	LOCATION 				VARCHAR(200) NULL DEFAULT NULL,
	LOCATION_CODE 			VARCHAR(45) NULL DEFAULT NULL,
	LANGUAGE_CODE 			VARCHAR(5) NULL DEFAULT NULL,
	NAME 					VARCHAR(45) NOT NULL,
	TIME_ZONE 				VARCHAR(200) NULL DEFAULT NULL,
	TWEETS_COUNT 			INTEGER NOT NULL DEFAULT '0',
	VERIFIED 				BOOLEAN NOT NULL DEFAULT '0',
	FOLLOWING_COUNT 		INTEGER NOT NULL DEFAULT '0',
	UTC_OFFSET 				INTEGER NULL DEFAULT NULL,
	IS_GEO_ENABLED 			BOOLEAN NOT NULL DEFAULT '0',
	LISTED_COUNT 			INTEGER NOT NULL DEFAULT '0',
	START_DATE 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	END_DATE 				TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (USER_ID),
	CONSTRAINT XAK1TWITTER_USERS UNIQUE (USERNAME)
) WITHOUT OIDS;



CREATE TABLE TWITTER_SEARCH (
	SEARCH_ID 				BIGINT NOT NULL,
	LABEL 					VARCHAR(100) NOT NULL,
	KEYWORDS 				VARCHAR(200) NOT NULL,
	CREATION_DATE 			DATE NOT NULL,
	LAST_ACTIVATION_TIME 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	TYPE					VARCHAR(50) NOT NULL,
	LOADING 				BOOLEAN NOT NULL DEFAULT '1',
	DELETED 				BOOLEAN NOT NULL DEFAULT '0',
	FAILED 					BOOLEAN NOT NULL DEFAULT '0',
	FAIL_MESSAGE 			VARCHAR(500) NULL DEFAULT NULL,
	BOOLEAN_OPERATOR 		VARCHAR(10) NOT NULL DEFAULT 'OR',
	DAYS_AGO 				INTEGER NULL DEFAULT NULL,
	R_ANALYSIS 				BOOLEAN NOT NULL DEFAULT '0',
	PRIMARY KEY (SEARCH_ID),
	CONSTRAINT XAK1TWITTER_SEARCH UNIQUE (LABEL)
) WITHOUT OIDS;



CREATE TABLE TWITTER_DATA (
	TWEET_ID 				BIGINT NOT NULL,
	USER_ID 				BIGINT NOT NULL,
	SEARCH_ID 				BIGINT NOT NULL,
	DATE_CREATED_AT 		DATE NOT NULL,
	TIME_CREATED_AT 		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	SOURCE_CLIENT 			VARCHAR(200) NOT NULL,
	TWEET_TEXT 				VARCHAR(400) NOT NULL,
	TWEET_TEXT_TRANSLATED 	VARCHAR(400) NULL DEFAULT NULL,
	GEO_LATITUDE 			DOUBLE PRECISION NULL DEFAULT NULL,
	GEO_LONGITUDE 			DOUBLE PRECISION NULL DEFAULT NULL,
	HASHTAGS 				VARCHAR(200) NULL DEFAULT NULL,
	MENTIONS 				VARCHAR(200) NULL DEFAULT NULL,
	RETWEET_COUNT 			INTEGER NOT NULL DEFAULT '0',
	IS_RETWEET 				BOOLEAN NOT NULL DEFAULT '0',
	LANGUAGE_CODE 			VARCHAR(5) NULL DEFAULT NULL,
	PLACE_COUNTRY 			VARCHAR(200) NULL DEFAULT NULL,
	PLACE_NAME 				VARCHAR(200) NULL DEFAULT NULL,
	URL_CITED 				VARCHAR(200) NULL DEFAULT NULL,
	IS_FAVORITED 			BOOLEAN NOT NULL DEFAULT '0',
	FAVORITED_COUNT 		INTEGER NOT NULL DEFAULT '0',
	REPLY_TO_SCREEN_NAME 	VARCHAR(45) NULL DEFAULT NULL,
	REPLY_TO_USER_ID 		BIGINT NULL DEFAULT NULL,
	REPLY_TO_TWEET_ID 		BIGINT NULL DEFAULT NULL,
	ORIGINAL_RT_TWEET_ID 	BIGINT NULL DEFAULT NULL,
	IS_SENSITIVE 			BOOLEAN NOT NULL DEFAULT '0',
	MEDIA_COUNT 			INTEGER NOT NULL DEFAULT '0',
	TOPICS 					VARCHAR(1000) NULL DEFAULT NULL,
	IS_POSITIVE 			BOOLEAN NOT NULL DEFAULT '0',
	IS_NEUTRAL 				BOOLEAN NOT NULL DEFAULT '0',
	IS_NEGATIVE 			BOOLEAN NOT NULL DEFAULT '0',
	PRIMARY KEY (TWEET_ID, SEARCH_ID)
) WITHOUT OIDS;



CREATE TABLE TWITTER_SENTIMENT (
	SENTIMENT_ID 			BIGINT NOT NULL,
	TWEET_ID 				BIGINT NOT NULL,
	POLARITY 				VARCHAR(45) NULL DEFAULT NULL,
	RICH_SENTIMENT 			VARCHAR(45) NULL DEFAULT NULL,
	TOPICS 					VARCHAR(45) NULL DEFAULT NULL,
	KLOUT_SCORE 			VARCHAR(45) NULL DEFAULT NULL,
	PRIMARY KEY (SENTIMENT_ID)
) WITHOUT OIDS;




CREATE TABLE TWITTER_SEARCH_SCHEDULER (
	ID 						BIGINT NOT NULL,
	SEARCH_ID 				BIGINT NOT NULL,
	STARTING_TIME 			TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	REPEAT_FREQUENCY 		INTEGER NOT NULL,
	REPEAT_TYPE 			VARCHAR(45) NOT NULL,
	ACTIVE 					BOOLEAN NOT NULL DEFAULT '1',
	PRIMARY KEY (ID)
) WITHOUT OIDS;



CREATE TABLE TWITTER_MONITOR_SCHEDULER (
	ID 						BIGINT NOT NULL,
	SEARCH_ID 				BIGINT NOT NULL,
	LAST_ACTIVATION_TIME  	TIMESTAMP NULL DEFAULT NULL,
	STARTING_TIME 			TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ENDING_TIME 			TIMESTAMP  NULL DEFAULT NULL,
	REPEAT_FREQUENCY 		INTEGER NOT NULL,
	REPEAT_TYPE 			VARCHAR(45) NOT NULL,
	ACTIVE_SEARCH 			BOOLEAN NOT NULL DEFAULT '0',
	UP_TO_VALUE 			INTEGER NOT NULL,
	UP_TO_TYPE 				VARCHAR(50) NOT NULL,
	LINKS 					VARCHAR(500) NULL DEFAULT NULL,
	ACCOUNTS 				VARCHAR(500) NULL DEFAULT NULL,
	DOCUMENTS 				VARCHAR(500) NULL DEFAULT NULL,
	ACTIVE 					BOOLEAN NOT NULL DEFAULT '1',
	PRIMARY KEY (ID)
) WITHOUT OIDS;




CREATE TABLE TWITTER_LINKS_TO_MONITOR (
	ID 						BIGINT NOT NULL,
	SEARCH_ID 				BIGINT NOT NULL,
	LINK 					VARCHAR(45) NOT NULL,
	LONG_URL 				VARCHAR(400) NULL DEFAULT NULL,
	CLICKS_COUNT 			INTEGER NOT NULL DEFAULT '0',
	TIMESTAMP 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (ID)
) WITHOUT OIDS;




CREATE TABLE TWITTER_LINK_TO_MONITOR_CAT (
	ID 						BIGINT NOT NULL,
	LINK_ID 				BIGINT NOT NULL,
	TYPE 					VARCHAR(45) NOT NULL,
	CATEGORY 				VARCHAR(45) NOT NULL,
	CLICKS_COUNT 			INTEGER NOT NULL DEFAULT '0',
	PRIMARY KEY (ID)
) WITHOUT OIDS;




CREATE TABLE TWITTER_ACCOUNTS_TO_MONITOR (
	ID 						BIGINT NOT NULL,
	SEARCH_ID 				BIGINT NOT NULL,
	ACCOUNT_NAME 			VARCHAR(45) NOT NULL,
	FOLLOWERS_COUNT 		INTEGER NOT NULL DEFAULT '0',
	TIMESTAMP 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (ID)
) WITHOUT OIDS;




ALTER TABLE TWITTER_DATA ADD CONSTRAINT FK_TWITTER_DATA_TWITTER_SEARCH FOREIGN KEY (SEARCH_ID) REFERENCES TWITTER_SEARCH (SEARCH_ID) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE TWITTER_DATA ADD CONSTRAINT FK_TWITTER_DATA_TWITTER_USER FOREIGN KEY (USER_ID) REFERENCES TWITTER_USERS (USER_ID) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE TWITTER_SEARCH_SCHEDULER ADD CONSTRAINT FK_TWITTER_SEARCH_SCHEDULER_TWITTER_SEARCH FOREIGN KEY (SEARCH_ID) REFERENCES TWITTER_SEARCH (SEARCH_ID) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE TWITTER_MONITOR_SCHEDULER ADD CONSTRAINT FK_TWITTER_MONITOR_SCHEDULER_TWITTER_SEARCH FOREIGN KEY (SEARCH_ID) REFERENCES TWITTER_SEARCH (SEARCH_ID) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE TWITTER_LINKS_TO_MONITOR ADD CONSTRAINT FK_TWITTER_LINKS_TO_MONITOR_TWITTER_SEARCH FOREIGN KEY (SEARCH_ID) REFERENCES TWITTER_SEARCH (SEARCH_ID) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE TWITTER_LINK_TO_MONITOR_CAT ADD CONSTRAINT FK_TWITTER_LINK_TO_MONITOR_CATEGORY_TWITTER_LINKS_TO_MONITOR FOREIGN KEY (LINK_ID) REFERENCES TWITTER_LINKS_TO_MONITOR (ID) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE TWITTER_ACCOUNTS_TO_MONITOR ADD CONSTRAINT FK_TWITTER_ACCOUNTS_TO_MONITOR_TWITTER_SEARCH FOREIGN KEY (SEARCH_ID) REFERENCES TWITTER_SEARCH (SEARCH_ID) ON UPDATE NO ACTION ON DELETE NO ACTION;