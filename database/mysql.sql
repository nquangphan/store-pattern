-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 01, 2020 at 01:01 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `storepattern`
--
CREATE DATABASE IF NOT EXISTS `storepattern` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `storepattern`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `USP_Admin_AddAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_AddAccount` (IN `username` VARCHAR(100), IN `name` VARCHAR(100), IN `sex` INT, IN `idcard` VARCHAR(100), IN `address` VARCHAR(100), IN `number` VARCHAR(30), IN `birth` DATETIME, IN `type` VARCHAR(100), IN `pass` VARCHAR(128))  BEGIN
insert into ACCOUNT
values(username,pass,name,sex,idcard,address,number,birth,1,3);
update ACCOUNT
set ACCOUNT.IDAccountType=(select ACCOUNTTYPE.ID from ACCOUNTTYPE WHERE ACCOUNTTYPE.Name=type)
where ACCOUNT.Username=username;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_AddFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_AddFood` (IN `name` VARCHAR(100), IN `category` VARCHAR(100), IN `price` DOUBLE, IN `images` LONGTEXT)  begin
insert into IMAGE
values('',images);
insert into FOOD
values('',(select FOODCATEGORY.ID from FOODCATEGORY where FOODCATEGORY.Name=category),name,price,(SELECT max(IMAGE.ID) from IMAGE));

end$$

DROP PROCEDURE IF EXISTS `USP_Admin_AddFood2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_AddFood2` (IN `name` VARCHAR(100), IN `category` VARCHAR(100), IN `price` DOUBLE, IN `images` LONGTEXT)  begin
insert into IMAGE
values('',images);
insert into FOOD
values('',(select FOODCATEGORY.ID from FOODCATEGORY where FOODCATEGORY.Name=category),name,price,(SELECT max(IMAGE.ID) from IMAGE));

end$$

DROP PROCEDURE IF EXISTS `USP_Admin_CheckLogin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_CheckLogin` (IN `username` VARCHAR(100))  SELECT ACCOUNT.Username,ACCOUNT.Password, ACCOUNT.IDAccountType
from ACCOUNT
where ACCOUNT.Username=username$$

DROP PROCEDURE IF EXISTS `USP_Admin_DelAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_DelAccount` (IN `_name` VARCHAR(100))  BEGIN
delete from ACCOUNT
where ACCOUNT.Username=_name;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_DelBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_DelBill` (IN `_ID` INT)  BEGIN
delete from BILLINFO
where BILLINFO.IDBill=_ID;
DELETE from BILL
where BILL.ID=_ID;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_DelFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_DelFood` (IN `_ID` INT)  delete from FOOD
where FOOD.ID=_ID
and not EXISTS (select * from BILLINFO where BILLINFO.IDFood=_ID)$$

DROP PROCEDURE IF EXISTS `USP_Admin_DelFoodCategory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_DelFoodCategory` (IN `_ID` INT)  begin
delete from FOOD
where FOOD.IDCategory=_ID;
delete from FOODCATEGORY
where FOODCATEGORY.ID=_ID;
end$$

DROP PROCEDURE IF EXISTS `USP_Admin_DelTables`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_DelTables` (IN `_id` INT)  BEGIN
DELETE from `TABLE`
where `TABLE`.`ID`=_id;
end$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetAccount` ()  BEGIN
select ACCOUNT.Username,ACCOUNT.DisplayName,ACCOUNT.Sex,ACCOUNT.IDCard,ACCOUNT.BirthDay,ACCOUNT.Address,ACCOUNT.PhoneNumber,ACCOUNT.IDAccountType,ACCOUNTTYPE.Name AccountType
from ACCOUNT INNER JOIN ACCOUNTTYPE where ACCOUNT.IDAccountType=ACCOUNTTYPE.ID;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetAccountType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetAccountType` ()  BEGIN
select ACCOUNTTYPE.ID,ACCOUNTTYPE.Name
from ACCOUNTTYPE;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetBillInfo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetBillInfo` (IN `_ID` INT)  select BILLINFO.IDBill,BILLINFO.IDFood,FOOD.Name FoodName,BILLINFO.Quantity
from BILLINFO,FOOD
where BILLINFO.IDBill=_ID
and BILLINFO.IDFood=FOOD.ID$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetBills`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetBills` ()  BEGIN
select BILL.ID,BILL.IDTable,`TABLE`.Name,BILL.DateCheckIn,BILL.DateCheckOut,BILL.Discount,BILL.TotalPrice,BILL.Status,BILL.Username from BILL,`TABLE`
WHERE BILL.IDTable=`TABLE`.ID;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetDelCategory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetDelCategory` (IN `_ID` INT)  select count(*)
from BILLINFO,FOOD,FOODCATEGORY
where BILLINFO.IDFood=FOOD.ID
and FOOD.IDCategory=FOODCATEGORY.ID
and FOODCATEGORY.ID=_ID$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetDelFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetDelFood` (IN `id` INT)  select count(*)
from BILLINFO,FOOD
where BILLINFO.IDFood=FOOD.ID
and FOOD.ID=id$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetFoodFromBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetFoodFromBill` (IN `_ID` INT)  select BILL.ID,BILL.IDTable,BILL.DateCheckIn,BILL.DateCheckOut,BILL.Discount,BILL.TotalPrice,BILL.Username,FOOD.Name,FOOD.IDImage,FOOD.Price,BILLINFO.Quantity,CONVERT(IMAGE.Data USING utf8) Image
from BILL,BILLINFO,FOOD,IMAGE
where BILL.ID=BILLINFO.IDBill
and BILLINFO.IDFood=FOOD.ID
and FOOD.IDImage=IMAGE.ID
and BILL.ID=_ID$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetFoods`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetFoods` ()  SELECT FOOD.ID, FOOD.Name, FOOD.Price, FOODCATEGORY.Name NameCategory, CONVERT(IMAGE.Data USING utf8) Image, FOOD.IDCategory, FOOD.IDImage FROM FOOD
    INNER JOIN FOODCATEGORY ON FOOD.IDCategory = FOODCATEGORY.ID
    INNER JOIN IMAGE ON FOOD.IDImage = IMAGE.ID$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetIDLastCategory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetIDLastCategory` ()  BEGIN

select * from FOODCATEGORY where FOODCATEGORY.ID=(select max(id) from FOODCATEGORY);
ENd$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetIDLastFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetIDLastFood` ()  select * from FOOD
where FOOD.ID=(select max(FOOD.ID) from FOOD)$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetIDLastTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetIDLastTable` ()  BEGIN

select * from `TABLE`  where `TABLE`.ID=(select max(id) from `TABLE`);
ENd$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetOrders`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetOrders` ()  BEGIN
select BILL.ID,BILL.IDTable,`TABLE`.Name,BILL.DateCheckIn,BILL.DateCheckOut,BILL.Discount,BILL.TotalPrice,BILL.Username from BILL,`TABLE`
WHERE BILL.Status=0
and BILL.IDTable=`TABLE`.`ID`
order by BILL.DateCheckIn ASC;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetReport`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetReport` (IN `date_` DATETIME)  BEGIN
select *
from REPORT
where YEAR(REPORT._Date)=YEAR(date_)
and MONTH(REPORT._Date)=MONTH(date_);
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_GetTables`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_GetTables` ()  SELECT TABLE.ID,TABLE.Name,TABLE.Status FROM `TABLE`$$

DROP PROCEDURE IF EXISTS `USP_Admin_InsertFoodCategory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_InsertFoodCategory` (IN `_Name` VARCHAR(100))  begin
insert into FOODCATEGORY(`Name`)
values(_Name);
end$$

DROP PROCEDURE IF EXISTS `USP_Admin_ResetPass`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_ResetPass` (IN `username` VARCHAR(100), IN `pass` VARCHAR(128))  update ACCOUNT
set ACCOUNT.Password=pass 
where ACCOUNT.Username=username$$

DROP PROCEDURE IF EXISTS `USP_Admin_UpdateAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_UpdateAccount` (IN `username` VARCHAR(100), IN `name` VARCHAR(100), IN `sex` INT, IN `idcard` VARCHAR(100), IN `address` VARCHAR(100), IN `number` VARCHAR(30), IN `birth` DATETIME, IN `type` VARCHAR(100))  BEGIN
update ACCOUNT
set ACCOUNT.DisplayName=name,ACCOUNT.Sex=sex,ACCOUNT.IDCard=idcard,ACCOUNT.Address=address,ACCOUNT.PhoneNumber=number,ACCOUNT.BirthDay=birth,ACCOUNT.IDAccountType=(select ACCOUNTTYPE.ID from ACCOUNTTYPE WHERE ACCOUNTTYPE.Name=type)
WHERE ACCOUNT.Username=username;

END$$

DROP PROCEDURE IF EXISTS `USP_Admin_UpdateBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_UpdateBill` (IN `_ID` INT, IN `_Date` DATETIME)  update BILL
set BILL.Status=1, BILL.DateCheckOut=_Date
where BILL.ID=_ID$$

DROP PROCEDURE IF EXISTS `USP_Admin_UpdateFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_UpdateFood` (IN `_ID` INT, IN `name` VARCHAR(100), IN `_foodcategory` VARCHAR(100), IN `price` DOUBLE, IN `_image` LONGTEXT)  BEGIN
DECLARE idimage int;
SELECT FOOD.IDImage into idimage from FOOD where FOOD.ID=_ID;
update IMAGE
set IMAGE.Data=_image
where IMAGE.ID=idimage;
update FOOD
set FOOD.Name=name,FOOD.Price=price,FOOD.IDCategory=(select FOODCATEGORY.ID from FOODCATEGORY where FOODCATEGORY.Name=_foodcategory)
where FOOD.ID=_ID;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_UpdateFoodCategory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_UpdateFoodCategory` (IN `_ID` INT, IN `_Name` VARCHAR(100))  BEGIN
update FOODCATEGORY
set FOODCATEGORY.Name=_Name
where FOODCATEGORY.ID=_ID;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_UpdateInfoFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_UpdateInfoFood` (IN `_ID` INT, IN `name` VARCHAR(100), IN `_foodcategory` VARCHAR(100), IN `price` DOUBLE)  BEGIN
update FOOD
set FOOD.Name=name,FOOD.Price=price,FOOD.IDCategory=(select FOODCATEGORY.ID from FOODCATEGORY where FOODCATEGORY.Name=_foodcategory)
where FOOD.ID=_ID;
END$$

DROP PROCEDURE IF EXISTS `USP_Admin_UpdatePassword`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_UpdatePassword` (IN `username` VARCHAR(100), IN `pass` VARCHAR(128))  update `ACCOUNT`
set `ACCOUNT`.Password=pass
where `ACCOUNT`.Username=username$$

DROP PROCEDURE IF EXISTS `USP_Admin_UpdateTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Admin_UpdateTable` (IN `_ID` INT, IN `_Name` VARCHAR(100))  update `TABLE`
    set `Name`=_Name
    where `ID`=_ID$$

DROP PROCEDURE IF EXISTS `USP_CheckToken`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_CheckToken` (`token1` VARCHAR(100))  SELECT * FROM `AUTHENTICATION` WHERE `Token` = `token1`$$

DROP PROCEDURE IF EXISTS `USP_DelBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_DelBill` (`id` INT)  BEGIN
    DELETE FROM BILLINFO
    WHERE BILLINFO.IDBill = id;
    DELETE FROM BILL
    WHERE BILL.ID = id;
END$$

DROP PROCEDURE IF EXISTS `USP_DeleteAcc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_DeleteAcc` (`username` VARCHAR(32))  DELETE FROM ACCOUNT
    WHERE ACCOUNT.Username = username$$

DROP PROCEDURE IF EXISTS `USP_DeleteAccType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_DeleteAccType` (`id` INT(11))  DELETE FROM ACCOUNTTYPE
WHERE ACCOUNTTYPE.ID = id$$

DROP PROCEDURE IF EXISTS `USP_DeleteCategory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_DeleteCategory` (`id` INT(11))  DELETE FROM FOODCATEGORY
WHERE FOODCATEGORY.ID = id$$

DROP PROCEDURE IF EXISTS `USP_DeleteFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_DeleteFood` (`id` INT(11))  DELETE FROM FOOD
WHERE FOOD.ID = id$$

DROP PROCEDURE IF EXISTS `USP_DeleteTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_DeleteTable` (`id` INT(11))  DELETE from `TABLE`
WHERE TABLE.ID = id$$

DROP PROCEDURE IF EXISTS `USP_GetAccounts`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetAccounts` ()  SELECT *
FROM ACCOUNT A, ACCOUNTTYPE B, IMAGE C
WHERE A.IDAccountType = B.ID and A.IDImage = C.ID$$

DROP PROCEDURE IF EXISTS `USP_GetAccountTypes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetAccountTypes` ()  SELECT *
    FROM ACCOUNTTYPE$$

DROP PROCEDURE IF EXISTS `USP_GetBillDetailByBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetBillDetailByBill` (IN `id` INT(11))  SELECT *
    FROM BILLINFO A, BILL B, FOOD C
    WHERE A.IDBill = B.ID and C.ID = A.IDFood and B.ID = `id`$$

DROP PROCEDURE IF EXISTS `USP_GetBills`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetBills` (IN `currentDate` DATETIME)  SELECT A.*, B.ID as IDTable, B.Name, C.*
    FROM BILL AS A, `TABLE` AS B, ACCOUNT as C
    WHERE A.IDTable = B.ID AND YEAR(A.DateCheckOut) = YEAR(currentDate) and MONTH(A.DateCheckOut) = MONTH(currentDate) and DAY(A.DateCheckOut) = DAY(currentDate) and A.Status = 1 and C.Username = A.Username
    ORDER BY A.DateCheckOut DESC$$

DROP PROCEDURE IF EXISTS `USP_GetFoodCategories`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetFoodCategories` ()  SELECT * from FOODCATEGORY$$

DROP PROCEDURE IF EXISTS `USP_GetFoods`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetFoods` ()  SELECT FOOD.ID, FOOD.IDCategory, FOOD.Name, FOOD.Price, FOOD.IDImage
FROM FOOD$$

DROP PROCEDURE IF EXISTS `USP_GetFoods1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetFoods1` ()  SELECT *
FROM FOOD$$

DROP PROCEDURE IF EXISTS `USP_GetFoodsPlus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetFoodsPlus` ()  SELECT A.ID `IdFood`, A.Name `FoodName`, C.Name `CategoryName`, A.Price `Price`, B.ID `IdImage`, B.Data `Image`, A.IDCategory `IDCategory`
FROM FOOD A, IMAGE B, FOODCATEGORY C
WHERE A.IDCategory = C.ID and A.IDImage = B.ID$$

DROP PROCEDURE IF EXISTS `USP_GetFoodsPlusByIDBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetFoodsPlusByIDBill` (`idBill` INT(11))  SELECT A.ID `IdFood`, A.Name `FoodName`, C.Name `CategoryName`, A.Price `Price`, B.ID `IdImage`, B.Data `Image`, A.IDCategory `IDCategory`
FROM FOOD A, IMAGE B, FOODCATEGORY C, BILLINFO D
WHERE A.IDCategory = C.ID and A.IDImage = B.ID and A.ID = D.IDFood and D.IDBill = idBill$$

DROP PROCEDURE IF EXISTS `USP_GetIdAccTypeMax`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetIdAccTypeMax` ()  SELECT MAX(ACCOUNTTYPE.ID) as ID
from ACCOUNTTYPE$$

DROP PROCEDURE IF EXISTS `USP_GetIdCategoryMax`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetIdCategoryMax` ()  SELECT MAX(FOODCATEGORY.ID) as ID
from FOODCATEGORY$$

DROP PROCEDURE IF EXISTS `USP_GetIdFoodMax`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetIdFoodMax` ()  SELECT MAX(ID) as ID
    from FOOD$$

DROP PROCEDURE IF EXISTS `USP_GetIDImages`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetIDImages` ()  SELECT ID FROM IMAGE$$

DROP PROCEDURE IF EXISTS `USP_GetIdMax`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetIdMax` ()  SELECT MAX(ID) as ID
    from BILL$$

DROP PROCEDURE IF EXISTS `USP_GetIdTableMax`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetIdTableMax` ()  SELECT MAX(`TABLE`.`ID`) as ID
from `TABLE`$$

DROP PROCEDURE IF EXISTS `USP_GetImageByID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetImageByID` (IN `_id` INT(11))  SELECT CONVERT(DATA USING utf8) "Image" FROM IMAGE WHERE IMAGE.ID = `_id` LIMIT 1$$

DROP PROCEDURE IF EXISTS `USP_GetImages`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetImages` ()  SELECT ID , CONVERT(DATA USING utf8) Data FROM IMAGE$$

DROP PROCEDURE IF EXISTS `USP_GetTables`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GetTables` ()  SELECT TABLE.ID,TABLE.Name,TABLE.Status FROM `TABLE`$$

DROP PROCEDURE IF EXISTS `USP_HasBillDetailOfBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_HasBillDetailOfBill` (`idBill` INT(11), `idFood` INT(11))  SELECT *
FROM BILLINFO
WHERE BILLINFO.IDBill = idBill and BILLINFO.IDFood = idFood$$

DROP PROCEDURE IF EXISTS `USP_HasBillOfTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_HasBillOfTable` (`idTable` INT(11))  SELECT *
FROM BILL
WHERE BILL.Status = 0 and BILL.IDTable = idTable$$

DROP PROCEDURE IF EXISTS `USP_InsertAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_InsertAccount` (IN `username` VARCHAR(32), IN `password` VARCHAR(128), IN `displayname` VARCHAR(100), IN `sex` INT(11), IN `idCard` VARCHAR(30), IN `address` VARCHAR(100), IN `phoneNumber` VARCHAR(30), IN `birthday` DATETIME, IN `idAccountType` INT(11), IN `image` LONGTEXT)  BEGIN
    DECLARE idImage int ;

	INSERT INTO IMAGE(IMAGE.Data)
    VALUES (image) ;
    
    select MAX(IMAGE.ID) into idImage
    FROM IMAGE ;
    
    INSERT INTO ACCOUNT(ACCOUNT.Username, ACCOUNT.Password, ACCOUNT.DisplayName, ACCOUNT.Sex, ACCOUNT.IDCard, ACCOUNT.Address, ACCOUNT.PhoneNumber, ACCOUNT.BirthDay, ACCOUNT.IDAccountType, ACCOUNT.IDImage)
    VALUES(`username`, `password`, `displayname`, `sex`, `idCard`, `address`, `phoneNumber`, `birthday`, `idAccountType`, `idImage`) ;
END$$

DROP PROCEDURE IF EXISTS `USP_InsertAccType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_InsertAccType` (IN `_Name` VARCHAR(100))  BEGIN
	insert into ACCOUNTTYPE(`Name`)
    values(_Name);
END$$

DROP PROCEDURE IF EXISTS `USP_InsertBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_InsertBill` (IN `_IDTable` INT(11), IN `_DateCheckIn` DATETIME, IN `_DateCheckOut` DATETIME, IN `_Discount` DOUBLE, `_TotalPrice` INT, IN `_Status` INT, `_Username` VARCHAR(32))  BEGIN
	insert into `BILL`(`IDTable`, `DateCheckIn`,`DateCheckOut`, `Discount`, BILL.TotalPrice, `Status`, `Username`)
		values(_IDTable, _DateCheckIn, _DateCheckOut, _Discount,_TotalPrice, _Status, _Username);
	update `TABLE` 
	set `Status` = 1
	WHERE `ID` = _IDTable;
END$$

DROP PROCEDURE IF EXISTS `USP_InsertBillInfo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_InsertBillInfo` (`_IDBill` INT, `_IDFood` INT, `_Quantity` INT)  insert into `BILLINFO`(`IDBill`, `IDFood`, `Quantity`)
    values(_IDBill, _IDFood, _Quantity)$$

DROP PROCEDURE IF EXISTS `USP_InsertBin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_InsertBin` (IN `IDCollect` INT, IN `ID` INT)  BEGIN
		insert BIN(`IDCollection`,`IDElement`)
		values(IDCollect,ID);
END$$

DROP PROCEDURE IF EXISTS `USP_InsertFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_InsertFood` (`name` VARCHAR(100), `price` DOUBLE, `idCategory` INT(11), `image` LONGTEXT)  BEGIN
    DECLARE idImage int ;

	INSERT INTO IMAGE(IMAGE.Data)
    VALUES (image) ;
    
    select MAX(IMAGE.ID) into idImage
    FROM IMAGE ;
    
	INSERT INTO FOOD(FOOD.Name, FOOD.Price, FOOD.IDCategory, FOOD.IDImage)
    VALUES(name, price, idCategory, idImage) ;
END$$

DROP PROCEDURE IF EXISTS `USP_InsertFoodCatetory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_InsertFoodCatetory` (IN `_Name` VARCHAR(100))  BEGIN
	insert into FOODCATEGORY(`Name`)
    values(_Name);
END$$

DROP PROCEDURE IF EXISTS `USP_InsertPending`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_InsertPending` (IN `ID` INT)  BEGIN
	insert PENDING(`IDBill`)
    values(ID);
END$$

DROP PROCEDURE IF EXISTS `USP_InsertTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_InsertTable` (IN `Nametable` VARCHAR(100))  BEGIN
	insert into `TABLE`(`Name`,`Status`)
    values (Nametable,-1);
END$$

DROP PROCEDURE IF EXISTS `USP_IsAccExists`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_IsAccExists` (`username` VARCHAR(32))  SELECT *
    FROM BILL
    WHERE BILL.Username = username$$

DROP PROCEDURE IF EXISTS `USP_IsAccTypeExists`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_IsAccTypeExists` (`id` INT(11))  SELECT *
from ACCOUNT
WHERE ACCOUNT.IDAccountType = id$$

DROP PROCEDURE IF EXISTS `USP_IsCategoryExists`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_IsCategoryExists` (`id` INT(11))  SELECT *
from FOOD
WHERE FOOD.IDCategory = id$$

DROP PROCEDURE IF EXISTS `USP_IsFoodExists`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_IsFoodExists` (`id` INT(11))  SELECT *
FROM BILLINFO
WHERE BILLINFO.IDFood = id$$

DROP PROCEDURE IF EXISTS `USP_IsTableExists`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_IsTableExists` (`id` INT(11))  SELECT *
from BILL
WHERE BILL.IDTable = id$$

DROP PROCEDURE IF EXISTS `USP_Login`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Login` (IN `username` VARCHAR(32))  SELECT A.Username, A.Password, A.DisplayName, A.Sex, A.IDCard, A.Address, A.PhoneNumber, A.IDAccountType, A.IDImage, CONVERT(B.Data USING utf8) `Data`, C.Name, A.BirthDay, C.Name
    FROM ACCOUNT A, IMAGE B, ACCOUNTTYPE C
    WHERE A.IDAccountType = C.ID and A.IDImage = B.ID and A.Username = `username`$$

DROP PROCEDURE IF EXISTS `USP_Login1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_Login1` (IN `user` VARCHAR(32))  SELECT * FROM `ACCOUNT` WHERE `Username` = `user`$$

DROP PROCEDURE IF EXISTS `USP_LoginAdmin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_LoginAdmin` (IN `username` VARCHAR(32))  SELECT A.Username, A.Password, A.DisplayName, A.Sex, A.IDCard, A.Address, A.PhoneNumber, A.IDAccountType, A.IDImage, CONVERT(B.Data USING utf8) `Data`, C.Name, A.BirthDay, C.Name
    FROM ACCOUNT A, IMAGE B, ACCOUNTTYPE C
    WHERE A.IDAccountType = C.ID and C.ID = 1 and A.IDImage = B.ID and A.Username = username$$

DROP PROCEDURE IF EXISTS `USP_SaveToken`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_SaveToken` (IN `user` VARCHAR(32), IN `token1` VARCHAR(100), IN `timeOut1` DATETIME)  BEGIN
 	DECLARE count1 INT;
    SELECT count(*) INTO count1 FROM AUTHENTICATION WHERE AUTHENTICATION.Username = user LIMIT 1;
    IF count1 < 1 THEN
        	INSERT INTO AUTHENTICATION(`Username`, `Token`, `TimeOut`) VALUES(user, token1, timeOut1);
        ELSE
            UPDATE AUTHENTICATION 
            SET `Token` = token1 , `TimeOut` = timeOut1 
            WHERE `Username` = user;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `USP_ShowReport`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_ShowReport` (IN `_Date` DATE)  select * from REPORT
    where REPORT._Date = _Date$$

DROP PROCEDURE IF EXISTS `USP_TVC12_DeleteBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_TVC12_DeleteBill` (`id1` INT)  BEGIN
	DELETE FROM BILLINFO
    WHERE BILLINFO.IDBill = id1;
	DELETE FROM BILL
    WHERE BILL.ID = id1;
END$$

DROP PROCEDURE IF EXISTS `USP_TVC12_GetBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_TVC12_GetBill` ()  SELECT BILL.ID, BILL.IDTable, BILL.DateCheckIn, BILL.DateCheckOut,
    	BILL.Discount, BILL.TotalPrice, BILL.Status, BILL.Username, TABLE.Name
    FROM 
    BILL INNER JOIN `TABLE` on BILL.IDTable = `TABLE`.`ID`$$

DROP PROCEDURE IF EXISTS `USP_TVC12_GetFoodFromBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_TVC12_GetFoodFromBill` (IN `_id` INT)  BEGIN
	SELECT BILLINFO.IDFood, BILLINFO.Quantity, FOOD.Name
    FROM BILLINFO INNER JOIN FOOD ON BILLINFO.IDFood = FOOD.ID
    WHERE BILLINFO.IDBill = _id;
END$$

DROP PROCEDURE IF EXISTS `USP_TVC12_GetOrders`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_TVC12_GetOrders` ()  BEGIN
	SELECT BILL.ID, BILL.IDTable, BILL.DateCheckIn, BILL.Username, TABLE.Name, BILL.DateCheckOut, BILL.Discount, BILL.TotalPrice
    FROM BILL INNER JOIN `TABLE` ON `TABLE`.ID = BILL.IDTable
    WHERE BILL.Status = 0
    ORDER BY BILL.DateCheckIn ASC;
END$$

DROP PROCEDURE IF EXISTS `USP_TVC12_GetReport_Month`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_TVC12_GetReport_Month` ()  SELECT SQL_NO_CACHE DATE_FORMAT(_Date, '%Y-%m-01') '_Date', SUM(TotalPrice) 'TotalPrice'
	FROM REPORT
    WHERE YEAR(REPORT._Date) = YEAR(Now())
	GROUP BY DATE_FORMAT(_Date, '%Y%m')$$

DROP PROCEDURE IF EXISTS `USP_TVC12_GetReport_Today`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_TVC12_GetReport_Today` ()  BEGIN
DECLARE check1 int DEFAULT 0;
SELECT COUNT(*) INTO check1
FROM REPORT
WHERE Date(Now()) = _Date;
IF check1 = 0 THEN
	INSERT INTO REPORT(_Date, TotalPrice) VALUES(NOW(), 0);
END IF;
SELECT * FROM REPORT
	WHERE Date(Now()) = _Date
    ORDER BY ID DESC
    LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `USP_TVC12_GetReport_Week`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_TVC12_GetReport_Week` ()  SELECT * FROM (SELECT DISTINCT *
	FROM REPORT
	ORDER BY REPORT.ID DESC
    LIMIT 7) as tb
ORDER BY tb._Date ASC$$

DROP PROCEDURE IF EXISTS `USP_TVC12_GetReport_Year`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_TVC12_GetReport_Year` ()  SELECT SQL_NO_CACHE _Date, SUM(TotalPrice) 'TotalPrice'
	FROM REPORT
	GROUP BY YEAR(_Date)$$

DROP PROCEDURE IF EXISTS `USP_UpdateAccAvatar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateAccAvatar` (IN `username` VARCHAR(32), IN `_image` LONGTEXT)  BEGIN
	DECLARE idImage int ;
	SELECT ACCOUNT.IDImage into idImage
    FROM ACCOUNT
    WHERE ACCOUNT.Username = username ;
    UPDATE IMAGE
    SET IMAGE.Data = _image
    WHERE IMAGE.ID = idImage ;
END$$

DROP PROCEDURE IF EXISTS `USP_UpdateAccInfo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateAccInfo` (`username` VARCHAR(32), `displayName` VARCHAR(100), `sex` INT(11), `birthday` DATETIME, `idCard` VARCHAR(30), `address` VARCHAR(100), `phone` VARCHAR(30))  UPDATE ACCOUNT
    SET ACCOUNT.DisplayName = displayName, ACCOUNT.Sex = sex, ACCOUNT.BirthDay = birthday, ACCOUNT.IDCard = idCard, ACCOUNT.Address = address, ACCOUNT.PhoneNumber = phone
    WHERE ACCOUNT.Username = username$$

DROP PROCEDURE IF EXISTS `USP_UpdateAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateAccount` (IN `username` VARCHAR(32), IN `displayname` VARCHAR(100), IN `sex` INT(11), IN `idCard` VARCHAR(30), IN `address` VARCHAR(100), IN `phoneNumber` VARCHAR(30), IN `birthday` DATETIME, IN `idAccountType` INT(11), IN `image` LONGTEXT)  BEGIN
	DECLARE idImageDelete, idImage int ;
    
    SELECT ACCOUNT.IDImage into idImageDelete
    FROM ACCOUNT
    WHERE ACCOUNT.Username = username ;
    
	INSERT INTO IMAGE(IMAGE.Data)
    VALUES (image) ;
    
    select MAX(IMAGE.ID) into idImage
    FROM IMAGE ;
    
    UPDATE ACCOUNT
    SET ACCOUNT.DisplayName = displayname, ACCOUNT.Sex = sex, ACCOUNT.IDCard = idCard, ACCOUNT.Address = address, ACCOUNT.PhoneNumber = phoneNumber, ACCOUNT.BirthDay = birthday, ACCOUNT.IDAccountType = idAccountType, ACCOUNT.IDImage = idImage
    WHERE ACCOUNT.Username = username ;
    
    DELETE FROM IMAGE
    WHERE IMAGE.ID = idImageDelete ;
END$$

DROP PROCEDURE IF EXISTS `USP_UpdateAccPass`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateAccPass` (`username` VARCHAR(32), `newPass` VARCHAR(128))  UPDATE ACCOUNT
    SET ACCOUNT.Password = newPass
    WHERE ACCOUNT.Username = username$$

DROP PROCEDURE IF EXISTS `USP_UpdateAccType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateAccType` (IN `_ID` INT, IN `_Name` VARCHAR(100))  BEGIN
	update ACCOUNTTYPE
    set `Name`=_Name
    where `ID`=_ID;
END$$

DROP PROCEDURE IF EXISTS `USP_UpdateBill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateBill` (IN `_ID` INT(11), IN `_IDTable` INT(11), IN `_DateCheckIn` DATETIME, IN `_DateCheckOut` DATETIME, IN `_Discount` DOUBLE, `_TotalPrice` INT, IN `_Status` INT, `_Username` VARCHAR(32))  BEGIN
        IF(_DateCheckIn IS NULL) THEN
    UPDATE
        BILL
    SET
        BILL.IDTable = _IDTable,
        BILL.DateCheckOut = _DateCheckOut,
        BILL.Discount = _Discount,
        BILL.TotalPrice = _TotalPrice,
        BILL.Status = _Status,
        BILL.Username = _Username
    WHERE
        BILL.ID = _ID ; ELSE
    UPDATE
        BILL
    SET
        BILL.IDTable = _IDTable,
        BILL.DateCheckIn = _DateCheckIn,
        BILL.DateCheckOut = _DateCheckOut,
        BILL.Discount = _Discount,
        BILL.TotalPrice = _TotalPrice,
        BILL.Status = _Status,
        BILL.Username = _Username
    WHERE
        BILL.ID = _ID ;
    END IF ; IF _TotalPrice = 0 THEN
UPDATE
    `TABLE`
SET
    `Status` = -1
WHERE
    `ID` = _IDTable ;
UPDATE
    BILL
SET
    BILL.Status = 1
WHERE
    BILL.ID = _ID ;
END IF ; IF _Status = 1 THEN
UPDATE
    `TABLE`
SET
    `Status` = -1
WHERE
    `ID` = _IDTable ; ELSE
UPDATE
    `TABLE`
SET
    `Status` = 1
WHERE
    `ID` = _IDTable ;
END IF ;
END$$

DROP PROCEDURE IF EXISTS `USP_UpdateBillInfo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateBillInfo` (`_IDBill` INT, `_IDFood` INT, `_Quantity` INT)  BEGIN
        IF _Quantity > 0 THEN
    UPDATE
        BILLINFO
    SET
        BILLINFO.Quantity = _Quantity
    WHERE
        BILLINFO.IDBill = _IDBill AND BILLINFO.IDFood = _IDFood ; ELSE
    DELETE
FROM
    BILLINFO
WHERE
    BILLINFO.IDBill = _IDBill AND BILLINFO.IDFood = _IDFood ;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `USP_UpdateFood`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateFood` (`id` INT(11), `name` VARCHAR(100), `price` DOUBLE, `idCategory` INT(11), `image` LONGTEXT)  BEGIN
	DECLARE idImageDelete, idImage int ;
    
    SELECT FOOD.IDImage into idImageDelete
    FROM FOOD
    WHERE FOOD.ID = id ;
    
	INSERT INTO IMAGE(IMAGE.Data)
    VALUES (image) ;
    
    select MAX(IMAGE.ID) into idImage
    FROM IMAGE ;
    
    UPDATE FOOD
    SET FOOD.Name = name, FOOD.Price = price, FOOD.IDCategory = idCategory, FOOD.IDImage = idImage
    WHERE FOOD.ID = id ;
    
    DELETE FROM IMAGE
    WHERE IMAGE.ID = idImageDelete ;
END$$

DROP PROCEDURE IF EXISTS `USP_UpdateFoodCategory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateFoodCategory` (IN `_ID` INT, IN `_Name` VARCHAR(100))  BEGIN
	update FOODCATEGORY
    set `Name`=_Name
    where `ID`=_ID;
END$$

DROP PROCEDURE IF EXISTS `USP_UpdateReport`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateReport` (IN `_Date` DATE, IN `Price` DOUBLE)  BEGIN
	declare _count int;
    select count(*) into _count
    from REPORT
    where REPORT._Date=_Date;
	if(_count>0) then
		update REPORT
		set REPORT.TotalPrice=REPORT.TotalPrice+Price
		where REPORT._Date=_Date;
	end if;
END$$

DROP PROCEDURE IF EXISTS `USP_UpdateTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UpdateTable` (IN `_ID` INT, IN `_Name` VARCHAR(100), IN `_Status` INT)  BEGIN
	update `TABLE`
    set `Name`=_Name , `Status`=_Status
    where `ID`=_ID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
CREATE TABLE IF NOT EXISTS `account` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `Password` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `DisplayName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Sex` int(11) DEFAULT NULL,
  `IDCard` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneNumber` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BirthDay` datetime DEFAULT NULL,
  `IDAccountType` int(11) DEFAULT NULL,
  `IDImage` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDAccountType` (`IDAccountType`),
  KEY `IDImage` (`IDImage`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`ID`, `Username`, `Password`, `DisplayName`, `Sex`, `IDCard`, `Address`, `PhoneNumber`, `BirthDay`, `IDAccountType`, `IDImage`) VALUES
(1, 'abc', '$2a$12$y/LcCe4dcYZQztVb/I.Op.aP.n2ZRmjYzccunqiskETZdPG4rjSZe', 'a', 1, '111', '1414', '123', '2019-01-15 00:00:00', 1, 0),
(2, 'admin', '$2a$12$3GnsmKfVT1Okpmp2ZOMGAOvOJ0M9WhLT0pp8nuyTFx5rENV4XdQ3O', 'admin', 1, '111', '221', '113', '2018-12-12 00:00:00', 1, 0),
(4, 'test', '$2b$10$EQ9YE9xlVOssaH6HsQClnuW4Dopwm6qY0wJAxm0F88ev7PC9TjUXK', 'Quang', 1, '', 'fdfhjj', '0982774446', '1994-12-06 00:00:00', 10, 0);

-- --------------------------------------------------------

--
-- Table structure for table `accounttype`
--

DROP TABLE IF EXISTS `accounttype`;
CREATE TABLE IF NOT EXISTS `accounttype` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `accounttype`
--

INSERT INTO `accounttype` (`ID`, `Name`) VALUES
(1, 'Admin'),
(10, 'Staff');

-- --------------------------------------------------------

--
-- Table structure for table `authentication`
--

DROP TABLE IF EXISTS `authentication`;
CREATE TABLE IF NOT EXISTS `authentication` (
  `Username` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `Token` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TimeOut` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
CREATE TABLE IF NOT EXISTS `bill` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDTable` int(11) NOT NULL,
  `DateCheckIn` datetime DEFAULT NULL,
  `DateCheckOut` datetime DEFAULT NULL,
  `Discount` double DEFAULT 0,
  `TotalPrice` double DEFAULT 0,
  `Status` int(11) DEFAULT -1,
  `Username` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDTable` (`IDTable`),
  KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`ID`, `IDTable`, `DateCheckIn`, `DateCheckOut`, `Discount`, `TotalPrice`, `Status`, `Username`) VALUES
(13, 8, '2020-06-01 17:07:32', '2020-06-01 17:07:38', 0, 0, 1, 'test'),
(14, 10, '2020-06-01 17:10:13', '2020-06-01 17:10:19', 0, 0, 1, 'test'),
(15, 1, '2020-06-01 17:15:06', '2020-06-01 17:15:27', 0, 0, 1, 'test'),
(16, 6, '2020-06-01 17:23:00', '2020-06-01 17:23:32', 0, 0, 1, 'test'),
(17, 7, '2020-06-01 17:34:01', '2020-06-01 17:34:03', 0, 54000, 0, 'test'),
(18, 10, '2020-06-01 17:34:44', '2020-06-01 17:54:53', 0, 111000, 1, 'test'),
(19, 8, '2020-06-01 17:36:30', '2020-06-01 17:36:34', 0, 0, 1, 'test'),
(20, 8, '2020-06-01 17:51:41', '2020-06-01 17:51:42', 0, 27000, 0, 'test'),
(21, 11, '2020-06-01 17:49:30', '2020-06-01 17:51:50', 0, 57000, 1, 'test'),
(22, 12, '2020-06-01 17:51:31', '2020-06-01 17:51:33', 0, 54000, 0, 'test');

--
-- Triggers `bill`
--
DROP TRIGGER IF EXISTS `UTG_Report_Delete`;
DELIMITER $$
CREATE TRIGGER `UTG_Report_Delete` BEFORE DELETE ON `bill` FOR EACH ROW BEGIN
	IF old.Status = 1 THEN
    	UPDATE REPORT
        SET REPORT.TotalPrice = REPORT.TotalPrice - old.TotalPrice
        WHERE DATE(REPORT._Date) = DATE(old.DateCheckIn);
    END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `UTG_Report_Update`;
DELIMITER $$
CREATE TRIGGER `UTG_Report_Update` BEFORE UPDATE ON `bill` FOR EACH ROW BEGIN
	DECLARE id1 int;
    SET id1 = 0;
	IF OLD.Status <> NEW.Status THEN 
        SELECT REPORT.ID
        INTO id1
        FROM 
        	REPORT
        WHERE 
        	DATE(REPORT._Date) = DATE(NEW.DateCheckIn);
        IF id1 = 0 THEN
            INSERT INTO REPORT(, TotalPrice) VALUES(DATE(NEW.DateCheckIn), NEW.TotalPrice);
            ELSE
            UPDATE
                REPORT
            SET
                REPORT.TotalPrice = REPORT.TotalPrice + (IF(NEW.Status > 0,NEW.TotalPrice,-NEW.TotalPrice))
            WHERE ID = id1;
       	END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `billinfo`
--

DROP TABLE IF EXISTS `billinfo`;
CREATE TABLE IF NOT EXISTS `billinfo` (
  `IDBill` int(11) NOT NULL,
  `IDFood` int(11) NOT NULL,
  `Quantity` int(11) DEFAULT 0,
  KEY `IDBill` (`IDBill`),
  KEY `IDFood` (`IDFood`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `billinfo`
--

INSERT INTO `billinfo` (`IDBill`, `IDFood`, `Quantity`) VALUES
(13, 0, 3),
(13, 1, 2),
(14, 0, 3),
(14, 1, 2),
(15, 1, 2),
(15, 0, 2),
(16, 0, 1),
(17, 0, 2),
(17, 1, 2),
(18, 1, 3),
(18, 0, 6),
(19, 0, 1),
(20, 1, 1),
(21, 1, 1),
(21, 0, 4),
(22, 0, 2),
(22, 1, 2),
(20, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `food`
--

DROP TABLE IF EXISTS `food`;
CREATE TABLE IF NOT EXISTS `food` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDCategory` int(11) NOT NULL,
  `Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT 'No Name',
  `Price` double DEFAULT 0,
  `IDImage` int(11) DEFAULT 1,
  PRIMARY KEY (`ID`),
  KEY `IDImage` (`IDImage`),
  KEY `IDCategory` (`IDCategory`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `food`
--

INSERT INTO `food` (`ID`, `IDCategory`, `Name`, `Price`, `IDImage`) VALUES
(0, 10, 'Cà phê đá', 10000, 0),
(1, 10, 'Nuoc cam', 17000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `foodcategory`
--

DROP TABLE IF EXISTS `foodcategory`;
CREATE TABLE IF NOT EXISTS `foodcategory` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT 'No Name',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `foodcategory`
--

INSERT INTO `foodcategory` (`ID`, `Name`) VALUES
(6, 'Dessert Bar'),
(10, 'Cà phê');

-- --------------------------------------------------------

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
CREATE TABLE IF NOT EXISTS `image` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Data` longblob DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `image`
--

INSERT INTO `image` (`ID`, `Data`) VALUES
(0, 0x6956424f5277304b47676f414141414e535568455567414141454141414142414341594141414371615848654141414142484e4353565149434167496641686b6941414141416c7753466c7a4141414275774141416273424f757a6a3467414141426c30525668305532396d64486468636d5541643364334c6d6c7561334e6a5958426c4c6d39795a35767550426f4141416f795355524256486a6137567437554258584852627542533667676b4551454147682b41414a7950584b753242396745474549716954456750564342464b53536e56466f4e6d4e435732386767454d53534b4436535a51523532444a44534e4b596d5566796e74544d6b76744a32314d6b455a3849306f424168384f76356e58336376647a4837743137735536486e666c6d594f2f7532664e39653837357663374f416f425a30776c794f424f6b4570515156424b304546776975456b777a4f496d6536364676616145766364353276733354615239436659516442474d456f424d6a4c4a745946752b5437554135464378622b373656434a4c3356575171334744736e5765554a2b78434470794171437661436e63657a575541762f47632f6862325159767949326544307339565959457563342b512f58554345414f4263457567767463523557324e7041594f4163715533336731723451674b4d52706c4774426a69754154675a4358424b69317448777142797579386b4c70744c32785149635a393970754a2f4b6741354d67692b3444726d2f3477396e4e6a7142344f487773524a49366f49476a5136704931687346344e4a33594767503938423645512b4f794d4a7934414f667749726e4164635a2b74684a6f30483368385a4b55303470554578776a78706b684a354956342f4f357171486e6544397a6e32416d46774c373450524542794246484d4941506e753167432b58727657446f64596c76484646446876754a315759546e347168343675675047306836594f4345774837464465744170416a31326257724446386f4e724843653775587947644f4f4b7456624c6575696e6372566f4a616e396e546f54483245657243384175644658636b4e7357506739474b734b6c453863682f3762477173534647476e55774c5a494e2b4755714a4b3651456f6c33346b4e32396a4d6773504a337561396453542f7a75707049792f453453302b74492b73434a3153524a41694148337a7a766132304a6b62614237356f302b4f5049664f6f695867544e596d626952594a41444f4a2b374e79794c664b426a323735483136654936674e356b674c3838422f44585451436670544841762f45632f6f6258344c556d534e37355852693142715a454549794558466b433449724b4c58686d443373454f6a5a497047634477436570414666547a515065672f644f45654e677567386c6c72664751335136434262474f4c4d45594f3338414c666747534e356332384937467a74426c654a4b36767a57373247655a766d6b6a5947624f74634442784958386776644764324234704f423848434f47444d547a416d7742584f314a6c6137574e5938344f322b484c424575326376377a5a6575525a484e69356a4364665452776871645a4259434b7653424b4164572b706b32504b7a6e3965477177547146415279736e3137362b7a50766c64417649467751444e305a546750654944484d727767613971496b7a3643514a6e4b634f6b414b7a4a6f373439656e696d357667375762364d543742744779516c4a5445697149674962386450482f6e69554f623835565434562b307138484e6a346f49616b52474248714d67646c4359456d41583539754c75626335476d5a2b6e547835456b5a48523755694f4371744a6f4a423867542f624e38416670354f395077794c30643455426368366a594c596f64644267566734336b61306d4a674937624b522f6b786336753174525877734c59497237316b6e4c797670794d39763978764e6e786476346f6e326c636551742f326f305a3972784e486953435556686b536f49514c61615645645a7444584769444451304e77423357457546695a5a53572f4374682f506b76323962446f67554d2b654446632b4472726f3041483655416e493643442f637542796437786748714c56316d4d496f55684e496c686753676d52794d353658592b627745443972592f763337515868594b734a3378494a347a474d367569662f702f7a354f3150494433527635482f37384130315433377a796e6b7762695461784877436c316e534559444e346447736936526b426c6d413369304d6f6f304642676243354f536b3155543475434765336d647662772f333739384475485545376e7851434434657a4a7750435a68432f7131596346497871337861784477594d78467159314a466b466e79465171415355656178704c6b355a324e676d2f6669775a4856765775726936596573675634576a52436e7050566c59576257647362417a382f663370755257424c764367787a4435394e67464a736c7a775051614b3841656f5143596561553550456e3575777645732f786a484779506436654e7061536b674b46446a6769483870597a726d3565486d316a5a475145664831395161505277494f50387779532f33476946347839736c6b30686b42676a7045566f49766c547650324e4855744b59463549704b53522f796a6269556f4654596b384c434237753575693055592f7a514e6b714d573047754c693476354e73624878356b2f62687a5749352b52364d3251787a59776468415241424f746770513763716346434a71366c6a543832324a354152436c57786654426c31645865483237647579525544796d542f79707463344f446a4174577658394e735a65516a4871672b436b364d397657374c476d39366e3034414a6346464671546355336e7a68336c3755664b597942535168383434654851706c58644b676f4f4459586834574a59496e4e31587156545130394e44372b6e74375957436767496f4c4379452f50783838504477344d316a3174714675755135534a674775657a555a626e5455685174576f674b674447345549447a73665368667a757a427559344b5a6e464b4431647a7970494565465537537351464254456b32397562676146517146584846485a4b36686a4e486e46794471432b515152416370536564635975644e36484b334b694170774f6e4b4b41484838677a39344d7762736c4978564b43307442574f486e67694e436644394e35646737442b5859654c78562f53616c7059576e7678573871595035792b6e6148386a6b6e462b78454a6e45514871582f446e424544757443684a53314f69417252454778574176735658492f684d7a4c35392b36534a344f7749482f58555577453445647a646d53483663735a6934322f614744437a4a434a41523945535467446b5469757a7444346e4b6b42726a4b344162542f55363843785834565a4c4d4b70717065677275525a38386b6a4d4c306d49674447444b7741794a325770326d52556c5341546c304c4142304a426a746869516754417863746979497878796769414f59525741474770305541533053774f4a53574959425670344446496c676153737559416c5a62424a384b45575173676c597867365a512f316f47645a656e696a41344f416831645858556a5a36596d4c434f43444c4d6f4d574f6b4345302f6a6f636e6b2f79675a4562745444323757645156316e43693543516b4141354f546e67364f6a494f7a6a52306445774e44526b755167794843474c584746446e616a596f383059392f2b39687a647678327633456a39667036345071584765344f374b4a454351754d585451595972624645774248394f4e6b712b6f754b33684d346b66502f6f42692f433961746e3457445a6269683555513164316448306e76342f7241553346796241366576726b792b437a474249646a6a4d6d4d4a45492b5172424576634a4578386435634938436d6444704e666c4f7431486a4d39644d543039387466474f57457735596b524368613430544961342b47597a5677726e71377763357a7764544468772f6c57776335435247354b5448744349694669706646795263582f357a2b376a56667064647864486b44466a4a703971616d4a6e6b6d55734c7162796f6c5a6e5a536c427346465476384a5a417670722f626b76597859444c30396b3658712f6c6b3649554c4638775441574f47637a475364706f5a5449724b5359756a53545358664a4d52386f674a34734c2b4a476b527664624f7a6734364f7a756c6939433958744c624e356f576c314d59655450647832726b68534a6b4a327446364f6a6f4542576872794757466b616b624b38544b3478494c6f33316c77614467394c47346d4676544951584e6d7046614739764e796c434544467049343369473742455332506d4645642f733961544e6859664879394b48756532756534736972446a4f6130496257317465732f41334b4f4c43314f65612f2f5a4573754c6f2b6155787a4f666461574e56565a576d69522f356f4261646c534849727959777067737056494a35382b6631337457646e59322f6633314c59757355783658756b4843324167516b6a39375547317865527846794247497746576975597152747a6554526d2f4a2f3446314e6b684933534c7a7557414e7749704e65586b3568496147307638566848797a47584e65696769356d7867524d4647616d5a6b4a746257316f46597a5a744e6a726831385138796231626249534e306b6458713750366955746a71427a567956416c7033424668396b3954456e354b674b4d6c4c4c30574f4f314c652f38565336322b536b72704e446b6643675131656b4b312b42673652612f3564746d4a6174386c68335839336f676473436e6546583237306769392f487a3439322b5365396f3253556e614c57727852636d6172374d786d365a6e74386a4d66544d78384d6a507a3064544d5a334d7a4830374f66446f37382f48302f2f666e382f3846394b4f7769542b35325a5141414141415355564f524b35435949493d);

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
CREATE TABLE IF NOT EXISTS `report` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `_Date` date NOT NULL,
  `TotalPrice` double DEFAULT 0,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `report`
--

INSERT INTO `report` (`ID`, `_Date`, `TotalPrice`) VALUES
(1, '2020-05-28', 0),
(2, '2020-05-29', 0),
(3, '2020-06-01', 168000);

-- --------------------------------------------------------

--
-- Table structure for table `table`
--

DROP TABLE IF EXISTS `table`;
CREATE TABLE IF NOT EXISTS `table` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT 'No Name',
  `Status` int(11) DEFAULT -1,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `table`
--

INSERT INTO `table` (`ID`, `Name`, `Status`) VALUES
(1, 'Table 1', -1),
(2, 'Table 2', -1),
(3, 'Table 3', -1),
(4, 'Table 4', -1),
(5, 'Table 5', -1),
(6, 'Table 6', -1),
(7, 'Table 7', 1),
(8, 'Table 8', 1),
(9, 'Table 9', -1),
(10, 'Table 10', -1),
(11, 'Table 11', -1),
(12, 'Table 12', 1),
(13, 'Table 14', -1),
(14, 'Table 15', -1),
(15, 'Table 17', -1);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
