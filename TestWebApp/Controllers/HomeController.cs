﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace TestWebApp.Controllers
{
    public class FileViewModel
    {
        public string Name { get; set; }
    }

    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.FileMessage = "";
            ViewBag.ExceptionMessage = "";
            ViewBag.Message = "";

            try
            {
                var files = Directory.GetFiles("c:\\server\\workspace\\client\\files");
                var vm = files.Select(f => new FileViewModel() { Name = WebUtility.UrlEncode(new FileInfo(f).Name) }).ToArray();
                ViewBag.FileMessage = $"Got {vm.Length} files";
                return View(vm);
            }
            catch (Exception ex)
            {
                ViewBag.ExceptionMessage = ex.Message;

                return View(new FileViewModel[] { });
            }
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