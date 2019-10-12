using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BankAppCoreWebApi.Models;
using Microsoft.AspNetCore.Mvc;

namespace BankAppCoreWebApi.Controllers
{
	[Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
	{

		#region getUsers

		// GET api/user
		[HttpGet]
		[Route("getUsers")]
		public IEnumerable<User> Get()
		{
			using (var db = new WebApiContext())
			{
				var temp = db.Users.ToList(); 
				return temp;
			}
		}
		#endregion



		// GET api/user/5
		[HttpGet("{id}")]
		public async Task<ActionResult<User>> GetAsync(int id)
		{
			var db = new WebApiContext();
			var tempUser = await db.Users.FindAsync(id);

			if (tempUser == null)
			{
				return NotFound();
			}

			return tempUser;
		}

		// POST api/user
		[HttpPost]
		[Route("register")]
		public int PostRegister([FromBody] Register registerModel)
		{
			var db = new WebApiContext();
			Customer customer = new Customer() ;
			customer.firstname = registerModel.firstname;
			customer.surname = registerModel.surname;
			customer.dateOfBirth = registerModel.dateOfBirth;
			customer.phoneNumber = registerModel.phoneNumber;
			customer.eMail = registerModel.eMail;
			customer.createdDate = registerModel.createdDate;
			customer.updatedDate = registerModel.updatedDate;
			try
			{
				db.Customers.Add(customer);
				db.SaveChanges();
				int customerId = customer.Id;
				User user = new User();
				user.TcIdentityKey = registerModel.TcIdentityKey;
				user.updatedDate = registerModel.updatedDate;
				user.createdDate = registerModel.createdDate;
				user.customerId = customerId;
				user.userName = registerModel.userName;
				user.userPassword = registerModel.userPassword;
				db.Users.Add(user);
				db.SaveChanges();
			}
			catch (System.Exception)
			{
				return 0;
			}
			return 1;
		}

		[HttpPost]
		[Route("login")]
		public User PostLogin([FromBody] User user)
		{
			var db = new WebApiContext();
			var isUserValid = db.Users.FirstOrDefault(x => x.userName == user.userName && x.userPassword == user.userPassword);
			
			if (isUserValid!=null)
			{
				return isUserValid;
			}
			return null;
		}

		// PUT api/user/5
		[HttpPut("{id}")]
		public void Put(int id, [FromBody] string value)
		{

		}

		// DELETE api/values/5
		[HttpDelete("{id}")]
		public void Delete(int id)
		{

		}
	}
}