using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RugratsWebApp.Controllers
{
    public class denemeController : Controller
    {
        // GET: deneme
        public ActionResult Index()
        {
            return View();
        }

        // GET: deneme/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: deneme/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: deneme/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: deneme/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: deneme/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: deneme/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: deneme/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
