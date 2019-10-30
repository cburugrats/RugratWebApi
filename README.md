## RugratWebApi


[UserController](#UserController)

[HgsController](#HgsController)

### UserController
----

[Get User By UserId](#Get-User-By-UserId)

**Get User By UserId**

  Returns json data about a single user.

* **URL**

  api/user/:id

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


### HgsController
----

[Register Hgs User](#Register-Hgs-User)

[Get Hgs User By accountNo With CustomerId](#Get-Hgs-User-By-accountNo-With-CustomerId)

[To Deposit Money Hgs](#To-Deposit-Money-Hgs)

[With Draw Money Hgs](#With-Draw-Money-Hgs)

### Register Hgs User

  Returns json data about a request.

* **URL**

  api/hgs/user

* **Method:**

  `POST`
  
*  **URL Params**

   **Required:**
 
   None

* **Data Params**

   `customerId=[integer]`
   
   `balance=[decimal]`
 

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `1`
 
* **Error Response:**

  * **Content:** `0` CustomerId boş bırakılamaz!<br />
  * **Content:** `2` Balance boş bırakılamaz!<br />
  * **Content:** `3` Geçersiz bir para miktarı girdiniz!<br />
  * **Content:** `4` Veritabanına kaydedilirken hata oluştu!<br />
  

### Get Hgs User By accountNo With CustomerId

  Returns json data about a single user.

* **URL**

  api/hgs/user/:customerId

* **Method:**

  `GET`
  
*  **URL Params**

   **Required:**
 
   `customerId=[integer]`

* **Data Params**

    None
 

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{"id":2,"customerId":7,"balance":83.0000}`
 
* **Error Response:**

  * **Content:** `null` <br />
  
  
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

   `customerId=[integer]`
   
   `balance=[decimal]`
 

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `1`
 
* **Error Response:**

  * **Content:** `0` CustomerId boş bırakılamaz!<br />
  * **Content:** `2` Bu customerId'ye bağlı bir hgs kaydı bulunamadı!<br />
  * **Content:** `3` Geçersiz bir para miktarı girdiniz!<br />
  * **Content:** `4` Veritabanına kaydedilirken hata oluştu!<br />  
  
  
### With Draw Money Hgs

  Returns json data about a request.

* **URL**

  api/hgs/withDrawMoney

* **Method:**

  `PUT`
  
*  **URL Params**

   **Required:**
 
   None

* **Data Params**

   `customerId=[integer]`
   
   `balance=[decimal]`
 

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `1`
 
* **Error Response:**

  * **Content:** `0` Geçersiz bir customerId girdiniz!<br />
  * **Content:** `2` Bu customerId'ye bağlı bir hgs kaydı bulunamadı!<br />
  * **Content:** `3` Geçersiz bir para miktarı girdiniz!<br />
  * **Content:** `4` Veritabanına kaydedilirken hata oluştu!<br />    

## Title

### Place 1

Hello, this is some text to fill in this, [here](#place-2), is a link to the second place.

### Place 2

Place one has the fun times of linking here, but I can also link back [here](#place-1).
