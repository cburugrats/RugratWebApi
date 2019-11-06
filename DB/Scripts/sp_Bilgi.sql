CREATE PROC sp_Bilgi(
	@customerId int,
	@userName nvarchar(20),
	@userPassword nvarchar(20),
	@firstname nvarchar(20),
	@surname nvarchar(20),
	@dateofBirth bigint,
	@phoneNumber bigint,
	@eMail nvarchar(20)
)
AS
UPDATE Customers
SET firstname=@firstname, surname=@surname, dateofBirth=@dateofBirth, phoneNumber=@phoneNumber, eMail=@eMail WHERE Id=@customerId

UPDATE Users
SET userName=@userName, userPassword=@userPassword WHERE customerId=@customerId


