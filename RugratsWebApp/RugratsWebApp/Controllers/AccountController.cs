using Newtonsoft.Json;
using RugratsWebApp.Models;
using RugratsWebApp.Models.Login;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace RugratsWebApp.Controllers
{
    [_SessionController]
    public class AccountController : Controller
	{
		// GET: Account
		public async System.Threading.Tasks.Task<ActionResult> CreateAsync()
		{
            try
            {
                // TODO: Add insert logic here
                // Create a HttpClient
                using (var client = new HttpClient())
                {

                    // Create post body object
                    // Serialize C# object to Json Object
                    var serializedProduct = JsonConvert.SerializeObject(User.Identity.Name);
                    // Json object to System.Net.Http content type
                    var content = new StringContent(serializedProduct, Encoding.UTF8, "application/json");
                    // Post Request to the URI
                    HttpResponseMessage result = await client.PostAsync("https://localhost:44329/api/account/openAnAccount", content);
                    // Check for result
                    if (result.IsSuccessStatusCode)
                    {
                        result.EnsureSuccessStatusCode();
                        string response = await result.Content.ReadAsStringAsync();
                        if (response == "0")
                        {
                            return RedirectToAction("LogOff", "Login");
                        }
                        else if (response == "1")
                        {
                            //Bilinmeyen Hata
                            ViewBag.AccountResponse = "Succes";
                            return RedirectToAction("List", "Account");
                        }
                        else
                        {
                            ViewBag.AccountResponse = "Unknown error occurred";
                            return RedirectToAction("List", "Account");
                        }
                    }
                    else
                    {
                        ViewBag.AccountResponse = "Unknown error occurred";
                        return RedirectToAction("List", "Account");
                    }
                }
            }
            catch
            {
                ViewBag.AccountResponse = "Unknown error occurred";
                return RedirectToAction("List", "Account");
            }
		}
		public async System.Threading.Tasks.Task<ActionResult> List()
		{
            if (string.IsNullOrEmpty(User.Identity.Name))
            {
                return RedirectToAction("Index", "Login");
            }
            List<AccountModel> accounts = new List<AccountModel>();
			using (var client = new HttpClient())
			{
				System.Net.ServicePointManager.ServerCertificateValidationCallback +=
				(se, cert, chain, sslerror) =>
				{
					return true;
				};
				var task = client.GetAsync("https://localhost:44329/api/account/"+ User.Identity.Name)
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
        [HttpPost]
		public ActionResult Delete(string AccountNo)
		{
            List<AccountModel> accounts = new List<AccountModel>();
            using (var client = new HttpClient())
            {
                System.Net.ServicePointManager.ServerCertificateValidationCallback +=
                (se, cert, chain, sslerror) =>
                {
                    return true;
                };
                var task = client.GetAsync("https://localhost:44329/api/account/closeAccount/" + AccountNo)
                  .ContinueWith((taskwithresponse) =>
                  {
                      var response = taskwithresponse.Result;
                      var jsonString = response.Content.ReadAsStringAsync();
                      jsonString.Wait();

                  });
                task.Wait();
            }

            return RedirectToAction("List", "Account");
        }
	}
}