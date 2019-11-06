# RugratWebApi

**UserController**
----

**Get User By UserId**

  Returns json data about a single user.

* **URL**

  /user/:id

* **Method:**

  `GET`
  
*  **URL Params**

   **Required:**
 
   `id=[integer]`

* **Data Params**

  None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{"id":2,"tcIdentityKey":12345678901,"customerId":2,"userName":"12345678901","userPassword":"1","createdDate":"2019-10-23T05:49:10.587","updatedDate":"2019-10-23T05:49:10.587"}`
 
* **Error Response:**

  * **Code:** 404 NOT FOUND <br />


## Title

### Place 1

Hello, this is some text to fill in this, [here](#place-2), is a link to the second place.

### Place 2

<<<<<<< HEAD
Place one has the fun times of linking here, but I can also link back [here](#place-1).
=======
### Get Hgs User By HgsNo

  Returns json data about a single user.

* **URL**

  api/hgs/user/:HgsNo

* **Method:**

  `GET`
  
*  **URL Params**

   **Required:**
 
   `HgsNo=[integer]`

* **Data Params**

    None
 

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{"id":2,"customerId":7,"balance":83.0000}`
 
* **Error Response:**

  * **Content:** `null` <br />
  
  
[Back to Top](#Controllers)

### To Deposit Money Hgs

  Returns json data about a request.

* **URL**

  api/hgs/toDepositMoney

* **Method:**

  `PUT`
  
*  **URL Params**

   **Required:**
 
   None

* **Data Params**

   `accountNo=[string]` //Paranın çekileceği hesap
   
   `balance=[decimal]`
   
   `HgsNo=[integer]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `1`
 
* **Error Response:**

  * **Content:** `0` CustomerId boş bırakılamaz!<br />
  * **Content:** `2` Bu customerId'ye bağlı bir hgs kaydı bulunamadı!<br />
  * **Content:** `3` Geçersiz bir para miktarı girdiniz!<br />
  * **Content:** `4` Veritabanına kaydedilirken hata oluştu!<br />  
  * **Content:** `5` Paranın çekileceği hesapta yeterli bakiye yok!<br />
  * **Content:** `6` AccountNo^ya kayıtlı bir hesap bulunamadı!<br />
  
[Back to Top](#Controllers) 
>>>>>>> parent of b158a2e... Update README.md
