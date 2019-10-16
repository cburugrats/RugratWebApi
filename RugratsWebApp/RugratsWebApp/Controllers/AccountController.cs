using Newtonsoft.Json;
using RugratsWebApp.Models;
using RugratsWebApp.Models.Login;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Mvc;

namespace RugratsWebApp.Controllers
{
    [_SessionController]
    public class AccountController : Controller
	{
		// GET: Account
		public ActionResult Index()
		{
			return View();
		}
		public ActionResult Create()
		{
			return View();
		}
		public async System.Threading.Tasks.Task<ActionResult> List()
		{
			List<AccountModel> accounts = new List<AccountModel>();
			AccountModel HesapOrnek = new AccountModel
			{
				Id = 1,
				customerId = 1,
				accountNo = "1",
				balance = 1,
				blockageAmount = 1,
				netBalance = 1

			};
			HesapOrnek.status = true;
			accounts.Add(HesapOrnek);
			HesapOrnek.status = false;
			accounts.Add(HesapOrnek);
			accounts.Add(HesapOrnek);
			using (var client = new HttpClient())
			{
				System.Net.ServicePointManager.ServerCertificateValidationCallback +=
				(se, cert, chain, sslerror) =>
				{
					return true;
				};
				var task = client.GetAsync("https://localhost:44329/api/account/424244")
				  .ContinueWith((taskwithresponse) =>
				  {
					  var response = taskwithresponse.Result;
					  var jsonString = response.Content.ReadAsStringAsync();
					  jsonString.Wait();
					  accounts = JsonConvert.DeserializeObject<List<AccountModel>>(jsonString.Result);

				  });
				task.Wait();
			}

			return View(accounts);
		}
		public ActionResult Details()
		{
			return View();
		}
	}
}