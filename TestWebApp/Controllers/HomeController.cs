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
            ViewBag.FileMessage = "";
            ViewBag.ExceptionMessage = "";
            ViewBag.Message = "";

            var msg1 = "";

            try
            {
                var files = Directory.GetFiles("c:\\server\\workspace\\client\\files");
                var vm = files.Select(f => new FileViewModel() { Name = WebUtility.UrlEncode(new FileInfo(f).Name) }).ToArray();
                msg1 = $"Got {vm.Length} files";
                return View("Index", vm);
            }
            catch (Exception ex)
            {
                msg1 = ex.Message;

                //return View(new FileViewModel[] { });
            }

            var msg2 = "";
            try
            {
                var files = Directory.GetFiles("z:\\");
                var vm = files.Select(f => new FileViewModel() { Name = WebUtility.UrlEncode(new FileInfo(f).Name) }).ToArray();
                msg2 = $"Got {vm.Length} files in z:\\";
                return View("Index", vm);
            }
            catch (Exception ex)
            {
                msg2 = ex.Message;

            }
            ViewBag.ExceptionMessage = msg1 + " : " + msg2;
            return View(new FileViewModel[] { });
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