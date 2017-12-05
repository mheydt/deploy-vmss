using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.File;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace TestWebApp.Controllers
{
    public class FilesAccessController : Controller
    {
        // GET: File
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetFileViaSymLink(string name)
        {
            //return File("c:\\server\\workspace\\client\\files\\" + filename, MimeMapping.GetMimeMapping(filename));
            var filename = WebUtility.UrlDecode(name);
            //return Redirect("https://" + ipAddress + "/" + filename);
            return this.Redirect("/files/" + filename);
        }

        public ActionResult GetFile(string name)
        {
            //var ipHostInfo = Dns.GetHostEntry(Dns.GetHostName()); 
            //var ipAddress = ipHostInfo.AddressList[0];
            var filename = WebUtility.UrlDecode(name);
            //return Redirect("https://" + ipAddress + "/" + filename);
            return this.Redirect("/files/" + filename);
        }

        [HttpPost]
        public ActionResult UploadFile(HttpPostedFileBase file, bool useAPI)
        {
            try
            {
                if (file!=null && file.ContentLength > 0)
                {
                    var filename = Path.GetFileName(file.FileName);
                    if (!useAPI)
                    {
                        try
                        {
                            var path = Path.Combine("c:\\server\\workspace\\client\\files", filename);
                            file.SaveAs(path);
                            ViewBag.Message = "File saved successfully via symlink!!";
                        }
                        catch (Exception ex)
                        {
                            ViewBag.Message = ex.Message;
                        }
                    }
                    else
                    {
                        try
                        {
                            var cs = ConfigurationManager.AppSettings["StorageConnectionString"];
                            var account = CloudStorageAccount.Parse(cs);
                            var fileClient = account.CreateCloudFileClient();
                            var share = fileClient.GetShareReference("workspace-file-storage-pri");
                            if (share.Exists())
                            {
                                var rootDir = share.GetRootDirectoryReference();
                                if (rootDir.Exists())
                                {
                                    var cloudFile = rootDir.GetFileReference(filename);
                                    cloudFile.UploadFromStream(file.InputStream);
                                    ViewBag.Message = "File saved successfully via API!!";
                                }
                            }
                        }
                        catch (Exception ex2)
                        {
                            ViewBag.Message = ex2.Message;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ViewBag.Message = "File upload failed!!";
            }
            return RedirectToAction("Index", "Home");
        }

    }
}