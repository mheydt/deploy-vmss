using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
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

        public ActionResult GetFileViaSymLink(string name)
        {
            var filename = WebUtility.UrlDecode(name);
            return File("c:\\server\\workspace\\client\\files\\" + filename, MimeMapping.GetMimeMapping(filename));
        }

        [HttpPost]
        public ActionResult UploadFile(HttpPostedFileBase file)
        {
            try
            {
                if (file!=null && file.ContentLength > 0)
                {
                    string _FileName = Path.GetFileName(file.FileName);
                    string _path = Path.Combine("c:\\server\\workspace\\client\\files", _FileName);
                    file.SaveAs(_path);
                }
                ViewBag.Message = "File Uploaded Successfully!!";
            }
            catch (Exception ex)
            {
                ViewBag.Message = "File upload failed!!";
            }
            return RedirectToAction("Index", "Home");
        }

    }
}