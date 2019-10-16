﻿using Newtonsoft.Json;
using RugratsWebApp.Models;
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
    [AllowAnonymous]
    public class RegisterController : Controller
    {
        // GET: Register
        public ActionResult Index()
        {
            if (String.IsNullOrEmpty(HttpContext.User.Identity.Name))
            {
                FormsAuthentication.SignOut();
                return View();
            }
            return Redirect("/Home");
        }
        [HttpPost]
        public async System.Threading.Tasks.Task<ActionResult> IndexAsync(FormCollection collection)
        {
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
                    // Post Request to the URI
                    HttpResponseMessage result = await client.PostAsync("https://localhost:44329/api/register", content);
                    // Check for result
                    if (result.IsSuccessStatusCode)
                    {
                        result.EnsureSuccessStatusCode();
                        string response = await result.Content.ReadAsStringAsync();
                        if (response =="2")
                        {
                            //Aynı Mail Mevcut
                            ViewBag.RegisterResponse = "Sign up with the same mail. Please try a different email address.";
                            return View("Index");
                        }
                        else if (response=="3")
                        {
                            //Aynı TC Mevcut
                            ViewBag.RegisterResponse = "Registered with the same TC. please try a different TC.";
                            return View("Index");
                        }
                        else if (response=="0")
                        {
                            //Bilinmeyen Hata
                            ViewBag.RegisterResponse = "Unknown error occurred";
                            return View("Index");
                        }
                    }
                    return RedirectToAction("Index", "Home");
                }
            }
            catch
            {
                return View();
            }
        }
    }
}