using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BankAppCoreWebApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;



namespace BankAppCoreWebApi.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class AccountController : ControllerBase
	{

		#region getAccounts

		// GET api/user
		[HttpGet]
		[Route("{customerId}")]
		public IEnumerable<Account> Get(int customerId)
		{
			using (var db = new WebApiContext())
			{
				var temp = db.Accounts.Where(x => x.customerId == customerId).ToList();
				return temp;
			}
		}
		#endregion


		// GET api/user/5
		[HttpGet("{customerId}/{accountId}")]
		public Account GetAccount(int customerId, int accountId)
		{
			using (var db = new WebApiContext())
			{
				Account tempAccount = null;
				tempAccount = db.Accounts.FirstOrDefault(x => x.Id == accountId && x.customerId == customerId);
				if (tempAccount == null)
				{
					return null;
				}
				return tempAccount;
			}
		}

		// POST api/user
		[HttpPost]
		[Route("openAnAccount")]
		public int PostRegister([FromBody] Account account)
		{
			using (var db = new WebApiContext())
			{
				account.createdDate = DateTime.Now;
				account.updatedDate = DateTime.Now;
				Account tempAccount = db.Accounts.OrderByDescending(p => p.createdDate).FirstOrDefault(x => x.customerId == account.customerId);
				if (tempAccount != null)
				{
					account.accountNo = (Convert.ToInt64(tempAccount.accountNo) + 1).ToString();
				}
				else
				{
					User user = db.Users.FirstOrDefault(x => x.customerId == account.customerId);
					account.accountNo = user.TcIdentityKey.ToString() + 1001;
				}
				db.Accounts.Add(account);
				db.SaveChanges();
			}
			return 1;
		}

		// PUT api/user/5
		[HttpPut("{id}")]
		public void Put(int id, [FromBody] string value)
		{

		}

		// DELETE api/values/5
		[HttpDelete("{id}")]
		public int Delete(int id)
		{
			using (var db = new WebApiContext())
			{
				try
				{
					var tempAccount = db.Accounts.FirstOrDefault(x => x.Id == id);
					tempAccount.status = false;
					db.SaveChanges();
				}
				catch (Exception)
				{
					return 0;
				}
				return 1;
			}
		}
	}
}