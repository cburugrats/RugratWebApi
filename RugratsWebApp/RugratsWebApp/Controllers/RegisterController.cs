using Newtonsoft.Json;
using RugratsWebApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace RugratsWebApp.Controllers
{
    public class RegisterController : Controller
    {
        // GET: Register
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public async System.Threading.Tasks.Task<ActionResult> IndexAsync(FormCollection collection)
        {
            ViewBag.deneme = collection["firstname"].ToString();
            //return RedirectToAction("Index","Register");
            string b;
            var a = collection["TcIdentityKey"];

            RegisterModel nRegister = new RegisterModel
            {
                TcIdentityKey = Int64.Parse(collection["TcIdentityKey"].ToString()),
                userName = collection["TcIdentityKey"].ToString(),
                surname = collection["surname"].ToString(),
                firstname = collection["firstname"].ToString(),
                phoneNumber = Int64.Parse(collection["phoneNumber"].ToString()),
                userPassword = collection["userPassword"].ToString(),
                eMail = collection["eMail"].ToString(),
                dateOfBirth = Convert.ToDateTime(collection["dateOfBirth"].ToString())
            };
            try
            {

                // TODO: Add insert logic here
                // Create a HttpClient
                using (var client = new HttpClient())
                {

                    // Create post body object
                    // Serialize C# object to Json Object
                    var serializedProduct = JsonConvert.SerializeObject(nRegister);
                    // Json object to System.Net.Http content type
                    var content = new StringContent(serializedProduct, Encoding.UTF8, "application/json");
                    b = content.ToString();
                    // Post Request to the URI
                    HttpResponseMessage result = await client.PostAsync("https://localhost:44329/api/register", content);
                    // Check for result
                    return RedirectToAction("Index", "Home");
                    //return null;
                }
            }
            catch
            {
                return View();
            }
        }
    }
}