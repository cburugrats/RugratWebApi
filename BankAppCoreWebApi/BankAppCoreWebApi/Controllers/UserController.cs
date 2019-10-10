using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace BankAppCoreWebApi.Controllers
{
	[Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
		// GET api/values
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

		// GET api/values/5
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

		// POST api/values
		[HttpPost]
		[Route("register")]
		public int PostRegister([FromBody] User user)
		{
			var db = new WebApiContext();
			try
			{
				db.Add(user);
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

		// PUT api/values/5
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