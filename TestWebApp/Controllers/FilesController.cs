using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TestWebApp.Controllers
{
    public class FilesController : Controller
    {
        // GET: File
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetFileViaSymLink(string filename)
        {
            return File("c:\\server\\workspace\\client\\files\\" + filename, MimeMapping.GetMimeMapping(filename));
        }
    }
}