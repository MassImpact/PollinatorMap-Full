using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Web;
using System.Web.UI;

namespace Pollinator.Common
{
    public class Utility
    {
        //The initial default seting used for all users. This should be set in early stage of Web page (PreInit), or a base page which Web page is inherited from.
        public static EmailConfiguration EmailConfiguration = new EmailConfiguration();

        /// <summary>
        /// Role name
        /// </summary>
        public enum RoleName
        {
            Administrator,
            Members,
        }

        /// <summary>
        /// This method reads IP address of client.
        /// On localhost, it returns "::1". It is local_host in IPv6.
        /// What you're seeing when calling 'localhost' is valid. ::1 is the IPv6 loopback address. Equivalent to 127.0.0.1 for IPv4.
        /// </summary>
        /// <example>
        /// var ipAddress = GetIPAddress();
        /// if(ipAddress == "::1")
        ///    ipAddress = "127.0.0.1"; //This value will be saved into DB
        /// </example>
        public static string GetIPAddress()
        {
            System.Web.HttpContext context = System.Web.HttpContext.Current;
            string ipAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (!string.IsNullOrEmpty(ipAddress))
            {
                string[] addresses = ipAddress.Split(',');
                if (addresses.Length != 0)
                {
                    return addresses[0];
                }
            }

            return context.Request.ServerVariables["REMOTE_ADDR"];
        }

        /// <summary>
        /// Send exception via email
        /// </summary>
        /// <param name="mailTo"></param>
        /// <param name="mailCC"></param>
        /// <param name="subject"></param>
        /// <param name="ex"></param>
        /// <param name="htmlBody"></param>
        /// <returns></returns>
        public static bool SendExceptionViaEmail(string mailTo, string mailCC, string subject, Exception ex)
        {
            return SendExceptionViaEmail(mailTo, mailCC, subject, ex.Message, ex.StackTrace);
        }

        public static bool SendExceptionViaEmail(string mailTo, string mailCC, string subject, string exceptionMsg, string additionalInfo)
        {
            var smtp = new SmtpClient();

            if (EmailConfiguration.SmtpServer != null)
                smtp.Host = EmailConfiguration.SmtpServer;// Example: "smtp.gmail.com";
            else
                return false; //No SMTP setting found, stop sending email here

            //Traditionally, plain SMTP uses port 25, but SMTP over SSL uses port 587. 
            //smtp.Port = 25;
            smtp.Port = 587;
            smtp.EnableSsl = true;
            smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
            //smtp.UseDefaultCredentials = true;
            smtp.Credentials = new System.Net.NetworkCredential(EmailConfiguration.UserName, EmailConfiguration.Password);

            var mail = new MailMessage();
            mail.From = new MailAddress(EmailConfiguration.WebMasterEmail);

            if (mailTo != null && mailTo.Trim().Length > 0)
            {
                foreach (string mt in mailTo.Split(';'))
                {
                    if (!string.IsNullOrEmpty(mt.Trim())) mail.To.Add(new MailAddress(mt.Trim()));
                }
            }
            else
                throw new Exception();

            if (mailCC != null)
            {
                if (mailCC.Trim().Length > 0)
                {
                    foreach (string mcc in mailCC.Split(';'))
                    {
                        if (!string.IsNullOrEmpty(mcc.Trim())) mail.CC.Add(new MailAddress(mcc.Trim()));
                    }
                }
            }

            string emailBody = File.ReadAllText(HttpContext.Current.Request.PhysicalApplicationPath + @"EmailTemplates\ExceptionTemplate.html");

            emailBody = emailBody.Replace("{URL}", HttpContext.Current.Request.Url.AbsoluteUri);
            emailBody = emailBody.Replace("{IP_Address}", GetIPAddress());
            emailBody = emailBody.Replace("{WorkStation}", GetUserIdentity());
            emailBody = emailBody.Replace("{Exception}", exceptionMsg);
            emailBody = emailBody.Replace("{Details}", additionalInfo);

            //Note: It is Release mode when you set config item "debug" in web.config
            //<compilation debug="false">
            emailBody = emailBody.Replace("{RunningMode}", (HttpContext.Current.IsDebuggingEnabled) ? "DEBUG" : "RELEASE");

            mail.Subject = subject;
            mail.Body = emailBody;
            mail.IsBodyHtml = true;

            smtp.Send(mail);

            mail.Dispose();

            return true;
        }

        public static string GetPhysicalWebPath()
        {
            Page page = HttpContext.Current.Handler as Page;
            return page.Server.MapPath("~");
        }

        private static string GetUserIdentity()
        {
            if (HttpContext.Current.User != null && HttpContext.Current.User.Identity.IsAuthenticated)
                return HttpContext.Current.User.Identity.Name;
            else
            {
                var windowsIdentity = System.Security.Principal.WindowsIdentity.GetCurrent();

                if (windowsIdentity != null && windowsIdentity.IsAuthenticated == true)
                    return windowsIdentity.Name;
                else
                    return "";
            }
        }

        /// <summary>
        /// Valdiate Image 
        /// </summary>
        /// <param name="photoUrl">updload image url</param>
        /// <returns>valid url, empty if image not exits</returns>
        public static string ValidateImage(string photoUrl)
        {        
            if (String.IsNullOrWhiteSpace(photoUrl))
                return string.Empty;

            photoUrl = photoUrl.Trim();

            string uploadFolder = System.Configuration.ConfigurationManager.AppSettings["FolderPath"].Replace(@"\", "");
            if (photoUrl.StartsWith(uploadFolder))//internal link
            {
                photoUrl = HttpContext.Current.Request.ApplicationPath + "/" + photoUrl;
                photoUrl = photoUrl.Replace(@"//", @"/");
                try
                {
                    String physicalPath = HttpContext.Current.Request.MapPath(photoUrl);
                    if (File.Exists(physicalPath))
                        return photoUrl;
                }
                catch
                {
                }
                return string.Empty;
            }
            else//external link
            {
                if (!photoUrl.StartsWith("http://") && !photoUrl.StartsWith("https://"))
                    photoUrl = "http://" + photoUrl;
                if (RemoteImageExists(photoUrl))
                    return photoUrl;
            }

            return string.Empty;


        }

        public static bool RemoteImageExists(string url)
        {
            try
            {
                Uri myUri;
                if (Uri.TryCreate(url, UriKind.RelativeOrAbsolute, out myUri))
                {
                    //Creating the HttpWebRequest
                    HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;

                    //Setting the Request method HEAD, you can also use GET too.
                  //  request.Method = "HEAD";

                    //Getting the Web Response.
                    HttpWebResponse response = request.GetResponse() as HttpWebResponse;
                    //Returns TRUE if the Status code == 200
                    return (response.StatusCode == HttpStatusCode.OK
                        /*&& response.ContentType.StartsWith("image/")*/);
                }
                Logger.Error("RemoteImageExists: !TryCreate:" + url);     
                return false;
            }
            catch (Exception ex)
            {             
                Logger.Error("RemoteImageExists: Exception:" + url, ex);
                string mess = ex.ToString();
                if (mess.Contains("404") || mess.Contains("The remote name could not be resolved"))//404 not found return false
                    return false;


                return true;
            }
        }

        /// <summary>
        /// Get UserFolder name of User
        /// </summary>
        /// <param name="photoUrl"></param>
        /// <returns></returns>
        public static string GetUserFolder(string photoUrls)
        {
            string userFolder = string.Empty;
            if (!string.IsNullOrEmpty(photoUrls))
            {
                string[] arrPhoto = photoUrls.Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
                string UploadFolder = ConfigurationManager.AppSettings["FolderPath"];
                for (int i = 0; i < arrPhoto.Length; i++)
                {
                    var photoUrl = arrPhoto[i];
                    int index = photoUrl.LastIndexOf("/");
                    if (index > -1 && photoUrl.Contains(UploadFolder.Replace("\\", "")) && !photoUrl.ToLower().StartsWith("http:") && !photoUrl.ToLower().StartsWith("https:"))
                    {
                        string tempUrl = photoUrl.Substring(0, index);
                        index = tempUrl.LastIndexOf("/");
                        if (index > -1)
                            userFolder = tempUrl.Substring(index + 1);
                    }
                }
            }
            return userFolder;
        }

        /// <summary>
        /// create a ramdam number that can use create folder name
        /// </summary>
        /// <returns></returns>
        public static string CreateRanNumber()
        {
            Random random = new Random();
            return DateTime.Now.Ticks + Convert.ToString(random.Next(1, 1000000000));//RanNumber
        }

        /// <summary>
        /// Des: Create Random Password
        /// CreateBy: Vinh.Ngo
        /// </summary>
        /// <param name="PasswordLength">length of password</param>
        /// <returns>password string</returns>
        public static string CreateRandomPassword(int PasswordLength)
        {
            string _allowedChars = "!@#$&0123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ";
            Random randNum = new Random();
            char[] chars = new char[PasswordLength];
            int allowedCharCount = _allowedChars.Length;
            for (int i = 0; i < PasswordLength; i++)
            {
                chars[i] = _allowedChars[(int)((_allowedChars.Length) * randNum.NextDouble())];
            }
            return new string(chars);
        }

        /// <summary>
        /// Create Random UserName
        /// </summary>
        /// <param name="UserNameLength">length of UserName, default 0 is unlimit</param>
        /// <returns>UserName string</returns>
        public static string CreateRandomUserName(int UserNameLength)
        {
            return System.Guid.NewGuid().ToString("N");
        }

        /// <summary>
        /// Find ClientID of elememt in user controls
        /// </summary>
        /// <param name="root"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static Control FindControlRecursive(Control root, string id)
        {
            if (root.ID == id)
            {
                return root;
            }

            foreach (Control c in root.Controls)
            {
                Control t = FindControlRecursive(c, id);
                if (t != null)
                {
                    return t;
                }
            }

            return null;
        }

    }
}
