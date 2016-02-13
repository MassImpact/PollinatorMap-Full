namespace Pollinator.Common
{
    public class EmailConfiguration
    {
        public EmailConfiguration()
        {
            //Set default value
            SmtpServer = "smtp.gmail.com";
            UserName = "sharepollinator@gmail.com";
            Password = "matkhauquangan";
            WebMasterEmail = "SHARE@polinator.com";
        }

        public EmailConfiguration(string smtpServer, string usrName, string pass, string webMasterEmail)
        {
            SmtpServer = smtpServer;
            UserName = usrName;
            Password = pass;
            WebMasterEmail = webMasterEmail;
        }

        public string SmtpServer
        {
            set;
            get;
        }

        public string UserName
        {
            set;
            get;
        }

        public string Password
        {
            set;
            get;
        }

        public string EncriptedPassword
        {
            set;
            get;
        }

        public string WebMasterEmail
        {
            set;
            get;
        }
    }
}
