using System;
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
            var files = Directory.GetFiles("c:\\server\\workspace\\client\\files");
            var vm = files.Select(f => new FileViewModel() { Name = WebUtility.UrlEncode(new FileInfo(f).Name) }).ToArray();
            return View(vm);
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