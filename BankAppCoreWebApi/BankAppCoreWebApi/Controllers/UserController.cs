using System;
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

		// GET api/getUsers
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

		#region GetUserById
		// GET api/user/5
		[HttpGet("{id}")]
		public async Task<ActionResult<User>> GetAsync(int id)
		
        {
            try
            {
                var db = new WebApiContext();
                var tempUser = await db.Users.FindAsync(id);

                if (tempUser == null)
                {
                    return NotFound();
                }

                return tempUser;
            }
            catch (Exception e)
            {
                return Redirect();
                throw;
            }
			
		} 
		#endregion

		#region HttpPut
		// PUT api/user/5
		[HttpPut("{id}")]
		public void Put(int id, [FromBody] string value)
		{

		}
		#endregion

		#region Delete
		// DELETE api/values/5
		[HttpDelete("{id}")]
		public void Delete(int id)
		{

		}
        #endregion

        // GET api/user/5
        [HttpGet("deneme")]
        public string deneme(int id)

        {

            return "AtAdam";
        }
        [HttpGet]
        public ActionResult hata()
        {

        }
    }
}