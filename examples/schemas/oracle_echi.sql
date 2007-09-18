CREATE TABLE PCO_ECHILOG (
  ID NUMBER,
  FILENAME VARCHAR2(10),
  FILENUMBER NUMBER,
  VERSION NUMBER,
  RECORDS VARCHAR2(2),
  PROCESSEDAT DATE
);

ALTER TABLE PCO_ECHILOG ADD CONSTRAINT PCO_ECHILOGPK PRIMARY KEY (ID)
USING INDEX TABLESPACE PINDEX;
ALTER TABLE PCO_ECHILOG ENABLE CONSTRAINT PCO_ECHILOGPK;

CREATE SEQUENCE PCO_ECHILOGSEQ ORDER;

CREATE OR REPLACE TRIGGER PCO_ECHILOGTRG BEFORE INSERT ON PCO_ECHILOG
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW DECLARE
  TEMP NUMBER;
BEGIN

  SELECT PCO_ECHILOGSEQ.NEXTVAL
  INTO TEMP
  FROM DUAL;

  :NEW.ID:=TEMP;

END;
/

CREATE TABLE PCO_ECHIRECORD (
  ID NUMBER,
  CALLID NUMBER,
  ACWTIME NUMBER,
  ONHOLDTIME NUMBER,
  CONSULTTIME NUMBER,
  DISPTIME NUMBER,
  DURATION NUMBER,
  SEGSTART DATE,
  SEGSTOP DATE,
  TALKTIME NUMBER,
  NETINTIME NUMBER,
  ORIGHOLDTIME NUMBER,
  QUEUETIME NUMBER,
  RINGTIME NUMBER,
  DISPIVECTOR NUMBER,
  DISPSPLIT NUMBER,
  FIRSTIVECTOR NUMBER,
  SPLIT1 NUMBER,
  SPLIT2 NUMBER,
  SPLIT3 NUMBER,
  TRUNGROUP NUMBER,
  TKLOCID NUMBER,
  ORIGLOCID NUMBER,
  ANSWERLOCID NUMBER,
  OBSLOCID NUMBER,
  UUILEN NUMBER,
  ASSIST CHAR(1), 
  AUDIODIFFICULTY CHAR(1),
  CONFERENCE CHAR(1),
  DAQUEUED CHAR(1),
  HOLDABN CHAR(1),
  MALICIOUS CHAR(1),
  OBSERVINGCALL CHAR(1),
  TRANSFERRED CHAR(1),
  AGENTRELEASED CHAR(1),
  ACDNUM NUMBER,
  CALLDISP NUMBER,
  DISPPRIORITY NUMBER,
  HOLDS NUMBER,
  SEGMENT NUMBER,
  ANSREASON NUMBER,
  ORIGREASON NUMBER,
  DISPSKLEVEL NUMBER,
  EVENTS0 NUMBER,
  EVENTS1 NUMBER,
  EVENTS2 NUMBER,
  EVENTS3 NUMBER,
  EVENTS4 NUMBER,
  EVENTS5 NUMBER,
  EVENTS6 NUMBER,
  EVENTS7 NUMBER,
  EVENTS8 NUMBER,
  UCID VARCHAR2(21),
  DISPVDN VARCHAR2(8),
  EQLOC VARCHAR2(10),
  FIRSTVDN VARCHAR2(8),
  ORIGLOGID VARCHAR2(10),
  ANSLOGID VARCHAR2(10),
  LASTOBSERVER VARCHAR2(10),
  DIALEDNUMBER VARCHAR2(25),
  CALLINGPARTY VARCHAR2(13),
  COLLECTDIGITS VARCHAR2(17),
  CWCDIGITS VARCHAR2(17),
  CALLINGII VARCHAR2(3),
  CWCS0 VARCHAR2(17),
  CWCS1 VARCHAR2(17),
  CWCS2 VARCHAR2(17),
  CWCS3 VARCHAR2(17),
  CWCS4 VARCHAR2(17),
  VDN2 VARCHAR2(8),
  VDN3 VARCHAR2(8),
  VDN4 VARCHAR2(8),
  VDN5 VARCHAR2(8),
  VDN6 VARCHAR2(8),
  VDN7 VARCHAR2(8),
  VDN8 VARCHAR2(8),
  VDN9 VARCHAR2(8),
  ASAIUUI VARCHAR2(96)
);

ALTER TABLE PCO_ECHIRECORD ADD CONSTRAINT PCO_ECHIRECORDPK PRIMARY KEY (ID)
USING INDEX TABLESPACE PINDEX;
ALTER TABLE PCO_ECHIRECORD ENABLE CONSTRAINT PCO_ECHIRECORDPK;

CREATE SEQUENCE PCO_ECHIRECORDSEQ ORDER;

CREATE OR REPLACE TRIGGER PCO_ECHIRECORDTRG BEFORE INSERT ON PCO_ECHIRECORD
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW DECLARE
  TEMP NUMBER;
BEGIN

  SELECT PCO_ECHIRECORDSEQ.NEXTVAL
  INTO TEMP
  FROM DUAL;

  :NEW.ID:=TEMP;

END;
/