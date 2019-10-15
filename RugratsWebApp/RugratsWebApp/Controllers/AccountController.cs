using RugratsWebApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RugratsWebApp.Controllers
{
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
        public ActionResult List()
        {
            List<AccountModel> accounts = new List<AccountModel>();
            AccountModel HesapOrnek = new AccountModel
            {
                Id = 1,
                customerId=1,
                accountNo="1",
                balance=1,
                blockageAmount=1,
                netBalance=1
                
            };
            HesapOrnek.status = true;
            accounts.Add(HesapOrnek);
            HesapOrnek.status = false;
            accounts.Add(HesapOrnek);
            accounts.Add(HesapOrnek);
            return View(accounts);
        }
        public ActionResult Details()
        {
            return View();
        }
    }
}