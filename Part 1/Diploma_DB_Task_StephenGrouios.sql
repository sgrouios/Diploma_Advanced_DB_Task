/*USE Diploma_DB_Task;
GO*/

IF OBJECT_ID('PURCHASEORDER9802') IS NOT NULL
DROP TABLE PURCHASEORDER9802;

IF OBJECT_ID('INVENTORY9802') IS NOT NULL
DROP TABLE INVENTORY9802;

IF OBJECT_ID('ORDERLINE9802') IS NOT NULL
DROP TABLE ORDERLINE9802;

IF OBJECT_ID('ORDER9802') IS NOT NULL
DROP TABLE [ORDER9802];

IF OBJECT_ID('AUTHORISEDPERSON9802') IS NOT NULL
DROP TABLE AUTHORISEDPERSON9802;

IF OBJECT_ID('ACCOUNTPAYMENT9802') IS NOT NULL
DROP TABLE ACCOUNTPAYMENT9802;

IF OBJECT_ID('CLIENTACCOUNT9802') IS NOT NULL
DROP TABLE CLIENTACCOUNT9802;

IF OBJECT_ID('PRODUCT9802') IS NOT NULL
DROP TABLE PRODUCT9802;

IF OBJECT_ID('LOCATION9802') IS NOT NULL
DROP TABLE [LOCATION9802];

IF OBJECT_ID('GENERALLEDGER9802') IS NOT NULL
DROP TABLE GENERALLEDGER9802;

GO

CREATE TABLE GENERALLEDGER9802(
    ITEMID INTEGER,
    DESCRIPTION NVARCHAR(100),
    AMOUNT MONEY,
    CONSTRAINT PK_GENERALLEDGER PRIMARY KEY (ITEMID),
    CONSTRAINT UQ_GENERALEDGER_DESCRIPTION UNIQUE(DESCRIPTION)
);

INSERT INTO GENERALLEDGER9802 (ITEMID, DESCRIPTION, AMOUNT) VALUES
(1, 'ASSETSCASH', 100000.00),
(2, 'ASSETSSTOCK', 0),
(3, 'ASSETSACCOUNT', 0);

CREATE TABLE [LOCATION9802](
    LOCATIONID NVARCHAR(8),
    LOCNAME NVARCHAR(50) NOT NULL,
    ADDRESS NVARCHAR(200) NOT NULL,
    MANAGER NVARCHAR(100),
    CONSTRAINT PK_LOCATION PRIMARY KEY (LOCATIONID)
);

CREATE TABLE PRODUCT9802(
    PRODUCTID INTEGER IDENTITY(10001, 1),
    PRODNAME NVARCHAR(100) NOT NULL,
    BUYPRICE MONEY,
    SELLPRICE MONEY,
    CONSTRAINT PK_PRODUCT PRIMARY KEY(PRODUCTID),
    CONSTRAINT CHK_WHOLESALE_RETAIL CHECK(BUYPRICE < SELLPRICE)
);

CREATE TABLE CLIENTACCOUNT9802(
    ACCOUNTID INTEGER IDENTITY(30001, 1),
    ACCTNAME NVARCHAR(100) NOT NULL,
    BALANCE MONEY NOT NULL,
    CREDITLIMIT MONEY NOT NULL,
    CONSTRAINT PK_CLIENTACCOUNT PRIMARY KEY(ACCOUNTID),
    CONSTRAINT CHK_CLIENTACCOUNT_BALANCE_CREDIT CHECK(BALANCE<=CREDITLIMIT),
    CONSTRAINT UQ_CLENTACCOUNT_NAME UNIQUE(ACCTNAME)
);

CREATE TABLE ACCOUNTPAYMENT9802(
    ACCOUNTID INTEGER,
    DATETIMERECEIVED DATETIME,
    AMOUNT MONEY NOT NULL,
    CONSTRAINT PK_ACCOUNTPAYMENT PRIMARY KEY(ACCOUNTID, DATETIMERECEIVED),
    CONSTRAINT FK_ACCOUNTPAYMENT_ACCOUNT FOREIGN KEY (ACCOUNTID) REFERENCES CLIENTACCOUNT9802,
    CONSTRAINT CHK_ACCOUNTPAYMENT_AMOUNT CHECK(AMOUNT >0)
);

CREATE TABLE AUTHORISEDPERSON9802(
    USERID INTEGER IDENTITY(50001, 1),
    FIRSTNAME NVARCHAR(100) NOT NULL,
    SURNAME NVARCHAR(100) NOT NULL,
    EMAIL NVARCHAR(100) NOT NULL,
    [PASSWORD] NVARCHAR(100) NOT NULL,
    ACCOUNTID INTEGER NOT NULL,
    CONSTRAINT PK_AUTHORISEDPERSON PRIMARY KEY(USERID),
    CONSTRAINT FK_AUTHORISEDPERSON_CLIENTACCOUNT FOREIGN KEY(ACCOUNTID) REFERENCES CLIENTACCOUNT9802,
    CONSTRAINT CHK_AUTHORISEDPERSON_EMAIL CHECK(EMAIL LIKE '%@%')
);

CREATE TABLE [ORDER9802](
    ORDERID INTEGER IDENTITY(70001, 1),
    SHIPPINGADDRESS NVARCHAR(200) NOT NULL,
    DATETIMECREATED DATETIME NOT NULL,
    DATETIMEDISPATCHED DATETIME,
    TOTAL MONEY NOT NULL,
    USERID INTEGER NOT NULL,
    CONSTRAINT PK_ORDER PRIMARY KEY(ORDERID),
    CONSTRAINT FK_ORDER_AUTHORISEDPERSON FOREIGN KEY(USERID) REFERENCES AUTHORISEDPERSON9802,
    CONSTRAINT CHK_ORDER_TOTAL CHECK(TOTAL >= 0)
);


CREATE TABLE ORDERLINE9802(
    ORDERID INTEGER,
    PRODUCTID INT,
    QUANTITY INT NOT NULL,
    DISCOUNT DECIMAL(3,2) DEFAULT 0,
    SUBTOTAL MONEY NOT NULL,
    CONSTRAINT PK_ORDERLINE PRIMARY KEY(ORDERID, PRODUCTID),
    CONSTRAINT FK_ORDERLINE_ORDER FOREIGN KEY(ORDERID) REFERENCES [ORDER9802],
    CONSTRAINT FK_ORDERLINE_PRODUCT FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT9802,
    CONSTRAINT CHK_ORDER_DISCOUNT CHECK(DISCOUNT >=0 AND DISCOUNT <= 0.25),
    CONSTRAINT CHK_ORDERLINE_SUBTOTAL CHECK(SUBTOTAL > 0)
);

CREATE TABLE INVENTORY9802(
    PRODUCTID INT,
    LOCATIONID NVARCHAR(8),
    NUMINSTOCK INTEGER NOT NULL,
    CONSTRAINT PK_INVENTORY PRIMARY KEY(PRODUCTID, LOCATIONID),
    CONSTRAINT FK_INVENTORY_PRODUCT FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT9802,
    CONSTRAINT FK_INVENTORY_LOCATION FOREIGN KEY(LOCATIONID) REFERENCES LOCATION9802,
    CONSTRAINT CHK_INVENTORY_NUMINSTOCK CHECK(NUMINSTOCK >=0)
);

CREATE TABLE PURCHASEORDER9802(
    PRODUCTID INT,
    LOCATIONID NVARCHAR(8),
    DATETIMECREATED DATETIME,
    QUANTITY INTEGER,
    TOTAL MONEY,
    CONSTRAINT PK_PURCHASEORDER PRIMARY KEY(PRODUCTID, LOCATIONID, DATETIMECREATED),
    CONSTRAINT FK_PURCHASEORDER_PRODUCT FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT9802,
    CONSTRAINT FK_PURCHASEORDER_LOCATION FOREIGN KEY(LOCATIONID) REFERENCES LOCATION9802,
    CONSTRAINT CHK_PURCHASEORDER_QUANTITY CHECK(QUANTITY > 0)
);

GO


--SELECT * FROM SYS.TABLES;

--------------------------

-- SET UP LOCATION, PRODUCT AND INVENTORY
BEGIN

    INSERT INTO LOCATION9802(LOCATIONID, LOCNAME, ADDRESS, MANAGER)VALUES
    ('MLB3931', 'Melbourne South East', '123 Demon Street, Mornington, 3931', 'Bruce Wayne');

    INSERT INTO PRODUCT9802(PRODNAME, BUYPRICE, SELLPRICE) VALUES
    ('APPLE ME PHONE X', '890.00', 1295.00 );

    DECLARE @PRODID INT = @@IDENTITY;

    INSERT INTO INVENTORY9802(PRODUCTID, LOCATIONID, NUMINSTOCK) VALUES
    (@PRODID, 'MLB3931', 0);

    -- ADD A NEW CLIENT ACCOUNT AND A NEW AUTHORISED USER FOR THAT ACCOUNT

    INSERT INTO CLIENTACCOUNT9802(ACCTNAME, BALANCE, CREDITLIMIT) VALUES
    ('FREDS LOCAL PHONE STORE', '0', 10000.00 );

    DECLARE @ACCOUNTID INT = @@IDENTITY;

    INSERT INTO AUTHORISEDPERSON9802(FIRSTNAME, SURNAME, EMAIL, [PASSWORD], ACCOUNTID) VALUES
    ('Fred', 'Flintstone', 'fred@fredsphones.com', 'secret', @ACCOUNTID);

    DECLARE @USERID INT = @@IDENTITY;

    -----------

    -- BUY SOME STOCK

    -- ADD A PURCHASE ORDER ROW
    INSERT INTO PURCHASEORDER9802(PRODUCTID, LOCATIONID, DATETIMECREATED, QUANTITY, TOTAL) VALUES
    (@PRODID,  'MLB3931', '10-Apr-2020', 50, 44500.00);

    -- UPDATE OUR INVENTORY FOR THAT STOCK
    UPDATE INVENTORY9802 SET NUMINSTOCK = 50 WHERE PRODUCTID = @PRODID AND LOCATIONID = 'MLB3931';

    -- UPDATE THE GENERAL LEDGER INCREASING THE VALUE OF OUR STOCK ASSETS AND DECREASING THE CASH ASSETS
    UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT - 44500.00 WHERE DESCRIPTION = 'ASSETSCASH';
    UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT + 44500.00 WHERE DESCRIPTION = 'ASSETSSTOCK';

    -----------

    -- CUSTOMER MAKES AN ORDER - (INITIALLY THE ORDER IS NOT FULFILLED)

    INSERT INTO ORDER9802(SHIPPINGADDRESS, DATETIMECREATED, DATETIMEDISPATCHED, TOTAL, USERID) VALUES
    ('7 Lucky Strike, Bedrock, USB, 1111', '20-Apr-2020', NULL, 6151.25, @USERID);

    DECLARE @ORDERID INT = @@IDENTITY;

    INSERT INTO ORDERLINE9802(ORDERID, PRODUCTID, QUANTITY, DISCOUNT, SUBTOTAL) VALUES
    (@ORDERID, @PRODID, 5, 0.05, '6151.25');

    -- WE FULLFILL THE ORDER

    -- UPDATE THE ORDER TO GIVE IT A FULLFUILLED DATE
    UPDATE ORDER9802 SET DATETIMEDISPATCHED = '21-Apr-2020' WHERE ORDERID = @ORDERID;

    -- UPDATE THE CLIENTS ACCOUNT BALANCE TO INCLUDE THE VALUE OF THE ORDER
    UPDATE CLIENTACCOUNT9802 SET BALANCE = BALANCE + 6151.25 WHERE ACCOUNTID = @ACCOUNTID;

    -- UPDATE THE GENERAL LEDGER INCREASING VALUE OF ACCOUNTS, DECEASING VALUE OF STOCK
    UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT + 6151.25  WHERE DESCRIPTION = 'ASSETSACCOUNT';
    UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT - (5*890) WHERE DESCRIPTION = 'ASSETSSTOCK';

    -------------

    -- CLIENT MAKES AN ACCOUNT OFF THIER ACCOUNT BALANCE

    -- ADD A ROW TO ACCOUNTPAYMENT9802
    INSERT INTO ACCOUNTPAYMENT9802(ACCOUNTID, DATETIMERECEIVED, AMOUNT) VALUES
        (@ACCOUNTID, '25-Apr-2020', '2000.00');

    -- UPDATE THE CLIENT ACCOUNT TO REFLECT THE BALANCE CHANGE
    UPDATE CLIENTACCOUNT9802 SET BALANCE = BALANCE - 2000.00 WHERE ACCOUNTID = @ACCOUNTID;

    -- UPDATE THE GENERAL LEDGER - INCREASE ASSETSCASH AND DECREASE ASSETS ACCOUNT
    UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT + 2000.00 WHERE DESCRIPTION = 'ASSETSCASH';
    UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT - 2000.00 WHERE DESCRIPTION = 'ASSETSACCOUNT';
END;
GO


IF OBJECT_ID('ADD_LOCATION') IS NOT NULL
DROP PROCEDURE ADD_LOCATION;
GO

CREATE PROCEDURE ADD_LOCATION 
@PLOCID NVARCHAR(10), 
@PLOCNAME NVARCHAR(50), 
@PLOCADDRESS NVARCHAR(200), 
@PMANAGER NVARCHAR(100),
@LOCIDRETURN NVARCHAR(10) OUTPUT
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY
            INSERT INTO LOCATION9802 VALUES(@PLOCID, @PLOCNAME, @PLOCADDRESS, @PMANAGER);
 
            DECLARE @My_Cursor CURSOR;
            DECLARE @PRODUCTID INT;
 
            SET @My_Cursor = CURSOR FOR
            SELECT PRODUCTID
            FROM PRODUCT9802;

            OPEN @My_Cursor
            FETCH NEXT FROM @My_Cursor
            INTO @PRODUCTID;

            WHILE @@FETCH_STATUS = 0    
                BEGIN    
                    INSERT INTO INVENTORY9802 
                    VALUES(@PRODUCTID, @PLOCID, 0); 
                    FETCH NEXT FROM @My_Cursor
                    INTO @PRODUCTID;
                END    

                CLOSE @My_Cursor;
                DEALLOCATE @My_Cursor;
                
                SET @LOCIDRETURN = @PLOCID;

                COMMIT TRAN  

    END TRY          
    BEGIN CATCH
        ROLLBACK TRAN
            IF ERROR_NUMBER()=2627
                THROW 51001, 'Duplicate Location ID', 1
            ELSE
                BEGIN
                    DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE(); 
                        THROW 50000, @ERRORMSG, 1
                END
    END CATCH
END
GO


IF OBJECT_ID('GET_LOCATION_BY_ID') IS NOT NULL
DROP PROCEDURE GET_LOCATION_BY_ID ;
GO

CREATE PROCEDURE GET_LOCATION_BY_ID 
@PLOCID NVARCHAR(8)
AS
BEGIN
    BEGIN TRY
        
        IF EXISTS (SELECT LOCNAME, [ADDRESS]
            FROM LOCATION9802
            WHERE LOCATIONID = @PLOCID)     
            BEGIN           
                SELECT * FROM LOCATION9802 
                WHERE LOCATIONID = @PLOCID;
            END
        ELSE
            BEGIN
                ;THROW 51002, 'Location Doesn''t Exist', 1
            END
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 51002
            THROW;
        ELSE
            DECLARE @ERRORMSG NVARCHAR(MAX)= ERROR_MESSAGE();
            THROW 50000, @ERRORMSG, 1;
    END CATCH
END
GO


IF OBJECT_ID('ADD_PRODUCT') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT ;
GO


CREATE PROCEDURE ADD_PRODUCT 
@PPRODNAME NVARCHAR(100), 
@PBUYPRICE MONEY, 
@PSELLPRICE MONEY
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY
            INSERT INTO PRODUCT9802(PRODNAME, BUYPRICE, SELLPRICE)
            VALUES(@PPRODNAME, @PBUYPRICE, @PSELLPRICE)

            DECLARE @PRODID INT = @@IDENTITY;
            DECLARE @MY_CURSOR CURSOR;
            DECLARE @LOCID NVARCHAR(8);

            SET @MY_CURSOR = CURSOR FOR
            SELECT LOCATIONID FROM 
            LOCATION9802;

            OPEN @MY_CURSOR
            FETCH NEXT FROM @MY_CURSOR
            INTO @LOCID;

            WHILE @@FETCH_STATUS = 0
                BEGIN
                    INSERT INTO INVENTORY9802
                    VALUES(@PRODID, @LOCID, 0);
                    FETCH NEXT FROM @MY_CURSOR
                    INTO @LOCID;
                END

            CLOSE @MY_CURSOR;
            DEALLOCATE @MY_CURSOR;

            COMMIT TRAN
            RETURN @PRODID;

        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
                DECLARE @ERROR_MSG NVARCHAR(MAX);
                SET @ERROR_MSG = ERROR_MESSAGE();
                THROW 50000, @ERROR_MSG, 1
        END CATCH
END;
GO


IF OBJECT_ID('GET_PRODUCT_BY_ID') IS NOT NULL
DROP PROCEDURE GET_PRODUCT_BY_ID ;
GO


CREATE PROCEDURE GET_PRODUCT_BY_ID 
@PPRODID INT
AS
BEGIN
    BEGIN TRY
            IF EXISTS (SELECT * FROM PRODUCT9802 WHERE PRODUCTID = @PPRODID)
                BEGIN
                    SELECT * FROM PRODUCT9802 
                    WHERE PRODUCTID = @PPRODID
                END
            ELSE
                THROW 52002, 'Product Doesn''t exist', 1
    END TRY
    BEGIN CATCH
            IF ERROR_NUMBER()=52002
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE(); 
                        THROW 50000, @ERRORMSG, 1
                END
    END CATCH
END
GO


IF OBJECT_ID('PURCHASE_STOCK') IS NOT NULL
DROP PROCEDURE PURCHASE_STOCK;
GO


CREATE PROCEDURE PURCHASE_STOCK 
@PPRODID INT, 
@PLOCID NVARCHAR(8), 
@PQTY INT 
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY
            DECLARE @BUYPRICE MONEY;  
                
            IF NOT EXISTS(SELECT * FROM PRODUCT9802 WHERE PRODUCTID = @PPRODID) 
                THROW 52002, 'Product Doesn''t Exist', 1
            IF NOT EXISTS(SELECT * FROM LOCATION9802 WHERE LOCATIONID = @PLOCID) 
                THROW 51002, 'Location Doesn''t exist', 1

            SET @BUYPRICE = (SELECT BUYPRICE FROM PRODUCT9802 WHERE PRODUCTID = @PPRODID)

            IF(@BUYPRICE * @PQTY > (SELECT AMOUNT FROM GENERALLEDGER9802 WHERE ITEMID = 1))   
                THROW 59001, 'INSUFICCIENT CASH', 1 
            
            INSERT INTO PURCHASEORDER9802 VALUES
            (@PPRODID, @PLOCID, GETDATE(), @PQTY, 
            (@PQTY * @BUYPRICE));

            UPDATE INVENTORY9802 SET NUMINSTOCK = NUMINSTOCK + @PQTY WHERE PRODUCTID = @PPRODID
            AND LOCATIONID = @PLOCID;

            UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT - (@PQTY * @BUYPRICE) WHERE ITEMID = 1;

            UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT + (@PQTY * @BUYPRICE) WHERE ITEMID = 2;

        COMMIT TRAN
        END TRY
    BEGIN CATCH
        ROLLBACK TRAN
            IF ERROR_NUMBER()=51002 OR ERROR_NUMBER()=52002 OR ERROR_NUMBER()=59001
                THROW
            ELSE 
                DECLARE @ERRORMSG NVARCHAR(MAX)= ERROR_MESSAGE();
                THROW 50000, @ERRORMSG, 1
    END CATCH
END;
GO


IF OBJECT_ID('ADD_CLIENT_ACCOUNT') IS NOT NULL
DROP PROCEDURE ADD_CLIENT_ACCOUNT;
GO

CREATE PROCEDURE ADD_CLIENT_ACCOUNT 
@PACCTNAME NVARCHAR(100), 
@PBALANCE MONEY, 
@PCREDITLIMIT MONEY
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY
            INSERT INTO CLIENTACCOUNT9802 VALUES
            (@PACCTNAME, @PBALANCE, @PCREDITLIMIT)

            COMMIT TRAN

            RETURN @@IDENTITY;
            
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
            IF ERROR_NUMBER()=2627
                THROW 53001, 'DUPLICATE ACCOUNT NAME', 1
            ELSE
                BEGIN
                    DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMSG, 1
                END
        END CATCH
END;
GO


IF OBJECT_ID('ADD_AUTHORISED_PERSON') IS NOT NULL
DROP PROCEDURE ADD_AUTHORISED_PERSON;

GO

CREATE PROCEDURE ADD_AUTHORISED_PERSON 
@PFIRSTNAME NVARCHAR(100), 
@PSURNAME NVARCHAR(100), 
@PEMAIL NVARCHAR(100), 
@PPASSWORD NVARCHAR(100), 
@PACCOUNTID INT 
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY

            IF CHARINDEX('@', @PEMAIL) > 0
                BEGIN
                    INSERT INTO AUTHORISEDPERSON9802 
                    (FIRSTNAME, SURNAME, EMAIL, [PASSWORD], ACCOUNTID)
                    VALUES(@PFIRSTNAME, @PSURNAME, @PEMAIL, @PPASSWORD, @PACCOUNTID)
                    
                    COMMIT TRAN  
                    
                    RETURN @@IDENTITY
                END
            ELSE
                THROW 53003, 'INVALID EMAIL ADDRESS', 1
       
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
            IF ERROR_NUMBER()=53003
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMSG, 1
                END
        END CATCH
END;
GO


IF OBJECT_ID('MAKE_ACCOUNT_PAYMENT') IS NOT NULL
DROP PROCEDURE MAKE_ACCOUNT_PAYMENT;

GO


CREATE PROCEDURE MAKE_ACCOUNT_PAYMENT 
@PACCOUNTID INT, 
@PAMOUNT MONEY 
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY

            INSERT INTO ACCOUNTPAYMENT9802
            VALUES (@PACCOUNTID, GETDATE(), @PAMOUNT)

            UPDATE CLIENTACCOUNT9802 SET BALANCE = BALANCE - @PAMOUNT
            WHERE ACCOUNTID = @PACCOUNTID 

            UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT - @PAMOUNT
            WHERE ITEMID = 3

            UPDATE GENERALLEDGER9802 SET AMOUNT = AMOUNT + @PAMOUNT
            WHERE ITEMID = 1

            COMMIT TRAN
        END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        IF ERROR_NUMBER()=547
            BEGIN 
                IF @PAMOUNT < 0
                    THROW 53004, 'ACCOUNT PAYMENT MUST BE POSITIVE', 1
                ELSE
                    THROW 53002, 'ACCOUNT DOES NOT EXIST', 1   
            END
        ELSE
            DECLARE @ERROR_MSG NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERROR_MSG, 1;
    END CATCH
END;
GO


IF OBJECT_ID('GET_CLIENT_ACCOUNT_BY_ID') IS NOT NULL
DROP PROCEDURE GET_CLIENT_ACCOUNT_BY_ID;

GO

CREATE PROCEDURE GET_CLIENT_ACCOUNT_BY_ID 
@PACCOUNTID INT
AS
BEGIN
    BEGIN TRY
        BEGIN
            IF NOT EXISTS (SELECT * FROM CLIENTACCOUNT9802 
            WHERE ACCOUNTID = @PACCOUNTID)
                THROW 53002, 'ACCOUNT DOES NOT EXIST', 1
            ELSE IF EXISTS (SELECT * FROM AUTHORISEDPERSON9802 WHERE ACCOUNTID = @PACCOUNTID)    
                    BEGIN
                        SELECT CLIENTACCOUNT9802.ACCOUNTID, ACCTNAME, 
                        BALANCE, CREDITLIMIT, USERID, FIRSTNAME, SURNAME, EMAIL
                        FROM CLIENTACCOUNT9802 INNER JOIN AUTHORISEDPERSON9802
                        ON CLIENTACCOUNT9802.ACCOUNTID = AUTHORISEDPERSON9802.ACCOUNTID
                        WHERE CLIENTACCOUNT9802.ACCOUNTID = @PACCOUNTID
                    END
            ELSE
                BEGIN
                    SELECT CLIENTACCOUNT9802.ACCOUNTID, ACCTNAME, 
                    BALANCE, CREDITLIMIT, (SELECT NULL) AS USERID,  (SELECT 'null') AS FIRSTNAME,
                    (SELECT 'null') AS SURNAME, (SELECT 'null') AS EMAIL FROM CLIENTACCOUNT9802 WHERE 
                    ACCOUNTID = @PACCOUNTID;
                END
        END
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER()=53002
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMSG, 1
            END    
    END CATCH
END;
GO


IF OBJECT_ID('CREATE_ORDER') IS NOT NULL
DROP PROCEDURE CREATE_ORDER;
GO

CREATE PROCEDURE CREATE_ORDER  
@PSHIPPINGADDRESS NVARCHAR(200),
@PUSERID INT 
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY

            INSERT INTO ORDER9802 (SHIPPINGADDRESS, DATETIMECREATED, TOTAL, USERID)
            VALUES(@PSHIPPINGADDRESS, GETDATE(), 0, @PUSERID)
            
            COMMIT TRAN

            RETURN @@IDENTITY;

        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
                IF ERROR_NUMBER()=547
                    THROW 55002, 'USER DOES NOT EXIST', 1
                ELSE
                    BEGIN
                        DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE();
                        THROW 50000, @ERRORMSG, 1
                    END 
        END CATCH
END;
GO


IF OBJECT_ID('GET_ORDER_BY_ID') IS NOT NULL
DROP PROCEDURE GET_ORDER_BY_ID;

GO

CREATE PROCEDURE GET_ORDER_BY_ID 
@PORDERID INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM ORDER9802 WHERE ORDERID = @PORDERID)
            IF EXISTS (SELECT * FROM ORDERLINE9802 WHERE ORDERID = @PORDERID)
                BEGIN
                    SELECT ORDER9802.*, ORDERLINE9802.PRODUCTID, 
                    ORDERLINE9802.QUANTITY, ORDERLINE9802.DISCOUNT,
                    ORDERLINE9802.SUBTOTAL FROM ORDER9802 INNER JOIN
                    ORDERLINE9802 ON ORDER9802.ORDERID = ORDERLINE9802.ORDERID
                    WHERE ORDER9802.ORDERID = @PORDERID; 
                END
            ELSE
                BEGIN
                    SELECT ORDER9802.*, (SELECT NULL) AS PRODUCTID, 
                    (SELECT NULL) AS QUANTITY, (SELECT NULL) AS DISCOUNT,
                    (SELECT NULL) AS SUBTOTAL FROM ORDER9802 WHERE ORDERID = @PORDERID
                END
        ELSE
            THROW 54002, 'ORDER DOES NOT EXIST', 1  
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER()=54002
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMSG, 1
            END    
    END CATCH  
END;
GO

IF OBJECT_ID('ADD_PRODUCT_TO_ORDER') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT_TO_ORDER;
GO

CREATE PROCEDURE ADD_PRODUCT_TO_ORDER 
@PORDERID INT, 
@PPRODIID INT, 
@PQTY INT, 
@DISCOUNT DECIMAL (3,2) 
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY

            DECLARE @SUBTOTAL MONEY;

            IF (SELECT DATETIMEDISPATCHED FROM ORDER9802 
            WHERE ORDERID = @PORDERID) IS NULL
                IF EXISTS (SELECT PRODUCTID FROM PRODUCT9802 
                WHERE PRODUCTID = @PPRODIID)
                    IF NOT EXISTS (SELECT * FROM ORDERLINE9802 
                    WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODIID)
                        BEGIN
                            SET @SUBTOTAL = (@PQTY * 
                            (SELECT SELLPRICE FROM PRODUCT9802 
                            WHERE PRODUCTID = @PPRODIID)) * (1 - @DISCOUNT);

                            INSERT INTO ORDERLINE9802 VALUES
                            (@PORDERID, @PPRODIID, @PQTY, @DISCOUNT, @SUBTOTAL)

                            UPDATE ORDER9802 SET TOTAL += @SUBTOTAL WHERE ORDERID = @PORDERID
   
                        END
                    ELSE
                        BEGIN
                            SET @SUBTOTAL = (@PQTY * 
                            (SELECT SELLPRICE FROM PRODUCT9802 
                            WHERE PRODUCTID = @PPRODIID)) * (1 - @DISCOUNT);
                            
                            DECLARE @UPDATEDDISCOUNT DECIMAL (3,2);

                            DECLARE @TOTALQUANTITY INT  = (SELECT QUANTITY FROM ORDERLINE9802 
                            WHERE ORDERID = @PORDERID) + @PQTY;

                            DECLARE @FULLPRICE MONEY =  @TOTALQUANTITY * 
                            (SELECT SELLPRICE FROM PRODUCT9802 WHERE PRODUCTID = @PPRODIID);

                            DECLARE @NEWTOTAL MONEY = (SELECT TOTAL FROM ORDER9802 WHERE ORDERID = @PORDERID) + @SUBTOTAL;

                            SET @UPDATEDDISCOUNT = (@FULLPRICE - @NEWTOTAL) / @FULLPRICE;
                            
                            UPDATE ORDERLINE9802 SET QUANTITY += @PQTY, DISCOUNT = @UPDATEDDISCOUNT, SUBTOTAL += @SUBTOTAL
                            WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODIID;

                            UPDATE ORDER9802 SET TOTAL += @SUBTOTAL WHERE ORDERID = @PORDERID;
                        END
                    ELSE
                        THROW 52002, 'PRODUCT DOES NOT EXIST', 1

            ELSE
                THROW 54002, 'ORDER HAS ALREADY BEEN FULFILLED', 1

            COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
                IF ERROR_NUMBER()=54002 OR ERROR_NUMBER()=52002
                    THROW
                IF ERROR_NUMBER()=547
                    BEGIN
                        IF NOT EXISTS (SELECT ORDERID FROM ORDER9802 WHERE ORDERID = @PORDERID)
                            THROW 54002, 'ORDER DOES NOT EXIST', 1
                        ELSE IF (@DISCOUNT < 0 OR @DISCOUNT > 0.25)
                            THROW 54004, 'DISCOUNT OUT OF RANGE', 1
                    END
                ELSE
                    BEGIN
                        DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE();
                        THROW 50000, @ERRORMSG, 1
                    END           
        END CATCH
END;
GO

IF OBJECT_ID('REMOVE_PRODUCT_FROM_ORDER') IS NOT NULL
DROP PROCEDURE REMOVE_PRODUCT_FROM_ORDER;
GO

CREATE PROCEDURE REMOVE_PRODUCT_FROM_ORDER 
@PORDERID INT, 
@PPRODIID INT 
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY

            IF NOT EXISTS (SELECT * FROM ORDER9802 WHERE ORDERID = @PORDERID)
                THROW 54002, 'ORDER DOES NOT EXIST', 1

            IF (SELECT DATETIMEDISPATCHED FROM ORDER9802 
            WHERE ORDERID = @PORDERID) IS NOT NULL
                THROW 54002, 'ORDER HAS ALREADY BEEN FULFILLED', 1
            
            IF NOT EXISTS (SELECT PRODUCTID FROM PRODUCT9802 WHERE PRODUCTID = @PPRODIID)
                THROW 52002, 'PRODUCT DOES NOT EXIST', 1

            IF NOT EXISTS (SELECT * FROM ORDERLINE9802 
            WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODIID)
                THROW 54005, 'PRODUCT NOT ON ORDER', 1
                    
            DECLARE @SUBTOTAL MONEY = (SELECT SUBTOTAL FROM 
            ORDERLINE9802 WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODIID);

            UPDATE ORDER9802 SET TOTAL -= @SUBTOTAL WHERE ORDERID = @PORDERID

            DELETE FROM ORDERLINE9802 WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODIID

        COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
                IF ERROR_NUMBER()=54002 OR ERROR_NUMBER()=52002 OR ERROR_NUMBER()=54005
                    THROW
                ELSE
                    BEGIN
                        DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE();
                        THROW 50000, @ERRORMSG, 1
                    END           
        END CATCH
END;
GO


IF OBJECT_ID('GET_OPEN_ORDERS') IS NOT NULL
DROP PROCEDURE GET_OPEN_ORDERS;
GO

CREATE PROCEDURE GET_OPEN_ORDERS 
AS
BEGIN
    BEGIN TRY
        SELECT * FROM ORDER9802 
        WHERE DATETIMEDISPATCHED IS NULL;

    END TRY
    BEGIN CATCH
        DECLARE @ERRORMSG NVARCHAR(MAX ) = ERROR_MESSAGE();
        THROW 50000, @ERRORMSG, 1 
    END CATCH

END;
GO

IF OBJECT_ID('FULLFILL_ORDER') IS NOT NULL
DROP PROCEDURE FULLFILL_ORDER;

GO

CREATE PROCEDURE FULLFILL_ORDER 
@PORDERID INT 
AS
BEGIN
    BEGIN TRAN
        BEGIN TRY

            IF NOT EXISTS (SELECT * FROM ORDER9802 WHERE ORDERID = @PORDERID)
                THROW 54002, 'ORDER DOES NOT EXIST', 1

            IF (SELECT DATETIMEDISPATCHED FROM ORDER9802 
            WHERE ORDERID = @PORDERID) IS NOT NULL
                THROW 54002, 'ORDER HAS ALREADY BEEN FULFILLED', 1

            DECLARE @ACCOUNTID INT = (SELECT ACCOUNTID FROM AUTHORISEDPERSON9802 
            INNER JOIN ORDER9802 ON AUTHORISEDPERSON9802.USERID = 
            ORDER9802.USERID WHERE ORDERID = @PORDERID)

            UPDATE ORDER9802 SET DATETIMEDISPATCHED = GETDATE()
            WHERE ORDERID = @PORDERID;

            DECLARE @PRODUCTS CURSOR;
            SET @PRODUCTS = CURSOR FOR SELECT PRODUCTID, QUANTITY, SUBTOTAL FROM ORDERLINE9802 
            WHERE ORDERID = @PORDERID;

            DECLARE @CURRENTPRODUCT INT;
            DECLARE @QUANTITY INT;
            DECLARE @SUBTOTAL MONEY;
            OPEN @PRODUCTS;
            FETCH NEXT FROM @PRODUCTS INTO @CURRENTPRODUCT, @QUANTITY, @SUBTOTAL;

            WHILE @@FETCH_STATUS=0
                BEGIN
                    DECLARE @LOCID NVARCHAR(8) = (SELECT TOP 1 LOCATIONID FROM INVENTORY9802 
                    WHERE PRODUCTID = @CURRENTPRODUCT
                    ORDER BY NUMINSTOCK DESC);

                    UPDATE INVENTORY9802 SET NUMINSTOCK -= @QUANTITY
                    WHERE PRODUCTID = @CURRENTPRODUCT AND
                    LOCATIONID = @LOCID;

                    UPDATE CLIENTACCOUNT9802 SET BALANCE += @SUBTOTAL WHERE ACCOUNTID = @ACCOUNTID;

                    UPDATE GENERALLEDGER9802 SET AMOUNT += @SUBTOTAL WHERE ITEMID = 3;

                    UPDATE GENERALLEDGER9802 SET AMOUNT -= @QUANTITY * 
                    (SELECT BUYPRICE FROM PRODUCT9802 WHERE PRODUCTID = @CURRENTPRODUCT) 
                    WHERE ITEMID = 2;

                    FETCH NEXT FROM @PRODUCTS INTO @CURRENTPRODUCT, @QUANTITY, @SUBTOTAL; 
                END

            COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
                IF ERROR_NUMBER()=54002
                    THROW
                ELSE IF ERROR_NUMBER()=547
                    BEGIN
                        IF((SELECT NUMINSTOCK FROM INVENTORY9802 WHERE LOCATIONID = @LOCID 
                        AND PRODUCTID = @CURRENTPRODUCT) < @QUANTITY)
                            THROW 54006, 'UNSUFFICIENT INVENTORY TO FULFILL', 1

                        IF(SELECT BALANCE FROM CLIENTACCOUNT9802 WHERE ACCOUNTID = @ACCOUNTID) 
                        + (SELECT TOTAL FROM ORDER9802 WHERE ORDERID = @PORDERID)
                        > (SELECT CREDITLIMIT FROM CLIENTACCOUNT9802 
                        WHERE ACCOUNTID = @ACCOUNTID)
                            THROW 53005, 'CLIENT ACCOUNT DOES NOT HAVE SUFFICIENT 
                            CREDIT REMAINING TO PAY FOR ORDER', 1
                    END
                ELSE 
                    DECLARE @ERRORMSG NVARCHAR(MAX) = ERROR_MESSAGE();
                    THROW 50000, @ERRORMSG, 1 
        END CATCH
END;
GO