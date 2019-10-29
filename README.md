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

 
