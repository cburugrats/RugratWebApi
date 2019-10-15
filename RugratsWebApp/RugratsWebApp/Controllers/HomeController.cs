﻿using RugratsWebApp.Models.Login;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RugratsWebApp.Controllers
{
    [_SessionController]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            HttpContext.Session.Clear();
            return View();

        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}