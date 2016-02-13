using System;
using System.Configuration;
using System.Data.Entity.Validation;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Pollinator.Common;
using Pollinator.DataAccess;

public partial class Admin_PollinatorInformation : System.Web.UI.Page
{

    PollinatorEntities mydb = new PollinatorEntities();
    Utility utility = new Utility();
    #region Events
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // If querystring value is missing, send the user to ManageUsers
            string sQuery = Request.QueryString["user"];
            if (string.IsNullOrEmpty(sQuery))
                Response.Redirect("Users");
            try
            {
                UserID = new Guid(sQuery);
            }
            catch
            {
                Response.Redirect("Users");
            }

            // Get information about this user
            MembershipUser usr = System.Web.Security.Membership.GetUser(UserID);

            if (usr != null)
            {
                UserName = usr.UserName;
                this.txtPassword.Text = usr.GetPassword();
            }

            var userDetail = GetUser();

            if (userDetail == null)
                Response.Redirect("Users");

            var polinatorInformation = GetPolinatorInfo();

            if (polinatorInformation == null)
                Response.Redirect("Users");
            if (polinatorInformation.IsNew)
            {
                try
                {
                    polinatorInformation.IsNew = false;
                    mydb.SaveChanges();
                }
                catch (Exception ex)
                {
                    Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_PollinatorInformation).Name + ".Page_Load. ", ex);
                    GoToAlertMessage(panelErrorMessage);
                }
            }

            if (polinatorInformation.IsApproved.HasValue)
                IsApproved.Checked = polinatorInformation.IsApproved.Value;

            SetInfoForMap(userDetail, polinatorInformation);

            if (polinatorInformation.Latitude.HasValue && polinatorInformation.Longitude.HasValue)
            {
                hdnLat.Value = polinatorInformation.Latitude.Value.ToString();
                hdnLng.Value = polinatorInformation.Longitude.Value.ToString();
            }

            if (userDetail.MembershipLevel == 0)//Normal user
            {
                this.dontDeletePreImage.Value = "0";
                SetValueToControlNormal(usr, userDetail, polinatorInformation);

                this.mulUploadImage.Visible = false;
                this.mulUploadVideo.Visible = false;
            }
            else//Premium user
            {
                //Temp code: get user Folder
                string userFolder = string.Empty;
                if (polinatorInformation.PhotoUrl != null)
                {
                    userFolder = Utility.GetUserFolder(polinatorInformation.PhotoUrl);
                }
                if (string.IsNullOrEmpty(userFolder))
                    userFolder = UserName;
                if (string.IsNullOrEmpty(userFolder))
                    userFolder = UserID.ToString();

                this.mulUploadImage.UserFolder = userFolder;
                this.mulUploadImage.PhotoUrl = polinatorInformation.PhotoUrl;
                this.mulUploadImage.UserID = polinatorInformation.UserId;

                this.mulUploadVideo.UserFolder = userFolder + "video";
                this.mulUploadVideo.YoutubeUrl = polinatorInformation.YoutubeUrl;
                this.mulUploadVideo.UserID = polinatorInformation.UserId;

                SetValueToControlPremium(usr, userDetail, polinatorInformation);
            }
        }
    }

    private void SetInfoForMap(UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        string sAddress = string.Empty;
        if (!string.IsNullOrEmpty(polinatorInformation.LandscapeStreet))
            sAddress += ", " + polinatorInformation.LandscapeStreet;
        if (!string.IsNullOrEmpty(polinatorInformation.LandscapeCity))
            sAddress += ", " + polinatorInformation.LandscapeCity;
        if (!string.IsNullOrEmpty(polinatorInformation.LandscapeState))
            sAddress += ", " + polinatorInformation.LandscapeState;
        if (!string.IsNullOrEmpty(polinatorInformation.LandscapeZipcode))
            sAddress += ", " + polinatorInformation.LandscapeZipcode;
        if (sAddress.Length > 2)
        {
            sAddress = sAddress.Substring(2);
        }

        this.Address = Server.HtmlEncode(sAddress);
        this.PollinatorName = Server.HtmlEncode(userDetail.FirstName);
    }


    protected void btnDelete_Click(object sender, EventArgs e)
    {

        if (!string.IsNullOrEmpty(UserName))
        {
            System.Web.Security.Membership.DeleteUser(UserName, true);
        }

        var userDetail = GetUser();

        var polinatorInformation = GetPolinatorInfo();

        if (userDetail != null)
            mydb.UserDetails.Remove(userDetail);

        if (polinatorInformation != null)
        {
            mydb.PolinatorInformations.Remove(polinatorInformation);
            if (!string.IsNullOrEmpty(polinatorInformation.PhotoUrl))
            {
                if (userDetail.MembershipLevel == 0)
                {
                    string sFilePath = Request.MapPath("~/" + polinatorInformation.PhotoUrl);
                    if (File.Exists(sFilePath))
                    {
                        var path = Path.GetDirectoryName(sFilePath);
                        Directory.Delete(path, true);
                    }
                }
                else
                {
                    var userFolder = Utility.GetUserFolder(polinatorInformation.PhotoUrl);
                    if (string.IsNullOrEmpty(userFolder))
                        userFolder = UserName;
                    if (string.IsNullOrEmpty(userFolder))
                        userFolder = UserID.ToString();
                    var path = ConfigurationManager.AppSettings["FolderPath"] + "/" + userFolder;
                    string sDirPath = Request.MapPath("~/" + path).Replace(@"//", "/");
                    if (Directory.Exists(sDirPath))
                        Directory.Delete(sDirPath, true);

                }
            }
        }

        mydb.SaveChanges();
        Response.Redirect("Users");
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            MembershipUser usr = System.Web.Security.Membership.GetUser(UserID);

            var userDetail = GetUser();

            var polinatorInformation = GetPolinatorInfo();

            bool IsApprovedOrg = false;
            if (polinatorInformation.IsApproved.HasValue)
                IsApprovedOrg = polinatorInformation.IsApproved.Value;

            polinatorInformation.IsApproved = IsApproved.Checked;
            polinatorInformation.IsNew = false;
            polinatorInformation.LastUpdated = DateTime.Now;
            polinatorInformation.Latitude = decimal.Parse(hdnLat.Value);
            polinatorInformation.Longitude = decimal.Parse(hdnLng.Value);

            if (userDetail.MembershipLevel == 0)
            {
                GetValueFromControlNormal(usr, userDetail, polinatorInformation);
            }
            else
            {
                GetValueFromControlPrenium(usr, userDetail, polinatorInformation);
            }

            if (usr != null)
            {
                //  usr.IsApproved = IsApproved.Checked;
                System.Web.Security.Membership.UpdateUser(usr);
            }

            try
            {
                mydb.SaveChanges();
            }
            catch (DbEntityValidationException ex)
            {
                Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_PollinatorInformation).Name + ".btnUpdate_Click(). ", ex);
                foreach (var eve in ex.EntityValidationErrors)
                {
                    foreach (var ve in eve.ValidationErrors)
                    {
                        Pollinator.Common.Logger.Error(string.Format("- Property: \"{0}\", Error: \"{1}\"", ve.PropertyName, ve.ErrorMessage));
                    }
                }
                GoToAlertMessage(panelErrorMessage);
                return;
            }

            //Load photo image
            if (userDetail.MembershipLevel == 0)
            {
                this.linAddPhoto.InnerText = "Change photo";
                this.dontDeletePreImage.Value = "1";
                string photoUrl = Utility.ValidateImage(polinatorInformation.PhotoUrl);
                if (!string.IsNullOrEmpty(photoUrl))
                    imgPhoto.ImageUrl = photoUrl;
                else
                    imgPhoto.Style["display"] = "none";
            }
            else
            {
                PremiumSetPhoto(polinatorInformation);
                PreniumSetVideo(polinatorInformation);
            }
            SetInfoForMap(userDetail, polinatorInformation);

            if (!IsApprovedOrg && IsApproved.Checked)
            {
                SendApprovedEmail(usr);
            }

            GoToAlertMessage(panelSuccessMessage);
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_PollinatorInformation).Name + ".btnUpdate_Click(). ", ex);
            GoToAlertMessage(panelErrorMessage);
        }
    }
    #endregion

    #region Private methods

    private void BindPollinatorSize(DropDownList control)
    {
        var pollinatorSizes = (from ps in mydb.PollinatorSizes
                               select new { ps.ID, ps.Name }).ToList();
        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = pollinatorSizes;
        control.DataBind();
    }

    private void BindPollinatorType(DropDownList control)
    {
        var pollinatorTypes = mydb.PollinatorTypes.ToList().OrderBy(t => t.Name).ToList();
        pollinatorTypes.Insert(0, new PollinatorType { ID = 0, Name = "Type of Pollinator Location" });

        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = pollinatorTypes;
        control.DataBind();
    }

    private void BindCountry(DropDownList control)
    {
        var countries = (from ps in mydb.Countries
                         orderby ps.SortOder
                         select new { ps.ID, ps.Name }
                               ).ToList();
        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = countries;
        control.DataBind();
    }

    private PolinatorInformation GetPolinatorInfo()
    {
        var polinatorInformation = (from pi in mydb.PolinatorInformations
                                    where pi.UserId == UserID
                                    select pi).FirstOrDefault();
        return polinatorInformation;
    }

    private UserDetail GetUser()
    {
        var userDetail = (from ud in mydb.UserDetails
                          where ud.UserId == UserID
                          select ud).FirstOrDefault();
        return userDetail;
    }

    private void SetValueToControlNormal(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        divRowRegPremium.Visible = false;
        txtUserName.Text = UserName;
        if (usr != null)
            txtEmail.Text = usr.Email;

        //Table 1 :user detail
        txtFirstName.Text = userDetail.FirstName;
        txtLastName.Text = userDetail.LastName;
        txtPhoneNumber.Text = userDetail.PhoneNumber;

        //Table 2: polinatorInformation
        txtOrganizationName.Text = polinatorInformation.OrganizationName;
        BindPollinatorType(drPollinatorType);
        drPollinatorType.SelectedValue = polinatorInformation.PollinatorType.ToString();

        BindPollinatorSize(drPollinatorSize);
        drPollinatorSize.SelectedValue = polinatorInformation.PollinatorSize.ToString();

        txtLandscapeStreet.Text = polinatorInformation.LandscapeStreet;
        txtLandscapeCity.Text = polinatorInformation.LandscapeCity;
        txtLandscapeState.Text = polinatorInformation.LandscapeState;
        txtLandscapeZipcode.Text = polinatorInformation.LandscapeZipcode;
        BindCountry(drCountry);
        drCountry.SelectedValue = polinatorInformation.LandscapeCountry;

        txtYoutubeUrl.Text = polinatorInformation.YoutubeUrl;

        string photoUrl = Utility.ValidateImage(polinatorInformation.PhotoUrl);
        this.txtPhotoUrl.Text = photoUrl;
        imgPhoto.ImageUrl = photoUrl;
        if (!string.IsNullOrEmpty(photoUrl))
        {
            this.linAddPhoto.InnerText = "Change photo";
            this.dontDeletePreImage.Value = "1";
        }

    }

    private void SetValueToControlPremium(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        divRowRegNormal.Visible = false;

        if (usr != null)
        {
            txtUserNameP.Text = usr.UserName;
            txtEmailP.Text = usr.Email;
        }

        //Table 1 :user detail
        txtFirstNameP.Text = userDetail.FirstName;
        txtLastNameP.Text = userDetail.LastName;
        //txtPhoneNumberP.Text = userDetail.PhoneNumber;

        //Table 2: polinatorInformation
        txtOrganizationNameP.Text = polinatorInformation.OrganizationName;
        txtLandscapeStreetP.Text = polinatorInformation.LandscapeStreet;
        txtLandscapeCityP.Text = polinatorInformation.LandscapeCity;
        txtLandscapeStateP.Text = polinatorInformation.LandscapeState;
        txtLandscapeZipcodeP.Text = polinatorInformation.LandscapeZipcode;
        BindCountry(drCountryP);
        drCountryP.SelectedValue = polinatorInformation.LandscapeCountry;

        txtPhotoUrlP.Attributes.Add("readonly", "readonly");
        txtPhotoUrlP.Attributes.Add("tabindex", "-1");
        PremiumSetPhoto(polinatorInformation);

        txtYoutubeUrlP.Attributes.Add("readonly", "readonly");
        txtYoutubeUrlP.Attributes.Add("tabindex", "-1");
        PreniumSetVideo(polinatorInformation);

        //premium info
        txtWebsiteP.Text = polinatorInformation.Website;

        BindPollinatorSize(drPollinatorSizeP);
        drPollinatorSizeP.SelectedValue = polinatorInformation.PollinatorSize.ToString();

        BindPollinatorType(drPollinatorTypeP);
        drPollinatorTypeP.SelectedValue = polinatorInformation.PollinatorType.ToString();

        txtOrganizationDescriptionP.Text = polinatorInformation.Description;
        txtBillingAddress.Text = polinatorInformation.BillingAddress;
        txtBillingCity.Text = polinatorInformation.BillingCity;
        txtBillingState.Text = polinatorInformation.BillingState;
        txtBillingZipcode.Text = polinatorInformation.BillingZipcode;

    }

    private void PreniumSetVideo(PolinatorInformation polinatorInformation)
    {
        string youtubeUrls = string.Empty;
        if (polinatorInformation.YoutubeUrl != null)
            youtubeUrls = polinatorInformation.YoutubeUrl.Trim();

        txtYoutubeUrlP.Text = youtubeUrls;
        if (!string.IsNullOrEmpty(youtubeUrls))
        {
            string[] arrVideo = youtubeUrls.Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
            numVideo.Text = String.Format("({0} {1})", arrVideo.Length.ToString(), arrVideo.Length > 1 ? "videos" : "video");
        }
        else
        {
            numVideo.Style["display"] = "none";
        }
    }

    private void PremiumSetPhoto(PolinatorInformation polinatorInformation)
    {
        string photoUrls = string.Empty;
        if (polinatorInformation.PhotoUrl != null)
            photoUrls = polinatorInformation.PhotoUrl.Trim();
        txtPhotoUrlP.Text = photoUrls;

        if (!string.IsNullOrEmpty(photoUrls))
        {
            string[] arrPhoto = photoUrls.Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
            numPhoto.Text = String.Format("({0} {1})", arrPhoto.Length.ToString(), arrPhoto.Length > 1 ? "photos" : "photo");

            var firstUrl = Utility.ValidateImage(arrPhoto[0].Trim());
            imgPhotoP.ImageUrl = firstUrl;
            if (string.IsNullOrEmpty(firstUrl))
            {
                imgPhotoP.Style["display"] = "none";
            }
        }
        else
        {
            numPhoto.Style["display"] = "none";
        }
    }



    private void GetValueFromControlNormal(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        if (usr != null)
            usr.Email = txtEmail.Text;

        //Table 1 :user detail     
        userDetail.FirstName = txtFirstName.Text;
        userDetail.LastName = txtLastName.Text;
        userDetail.PhoneNumber = txtPhoneNumber.Text;
        polinatorInformation.PollinatorType = Int32.Parse(drPollinatorType.SelectedValue);

        //Table 2: polinatorInformation
        polinatorInformation.OrganizationName = txtOrganizationName.Text;
        polinatorInformation.PollinatorSize = Int32.Parse(drPollinatorSize.SelectedValue);
        polinatorInformation.LandscapeStreet = txtLandscapeStreet.Text;
        polinatorInformation.LandscapeCity = txtLandscapeCity.Text;
        polinatorInformation.LandscapeState = txtLandscapeState.Text;
        polinatorInformation.LandscapeZipcode = txtLandscapeZipcode.Text;
        polinatorInformation.LandscapeCountry = drCountry.SelectedValue;
        polinatorInformation.PhotoUrl = txtPhotoUrl.Text;
        polinatorInformation.YoutubeUrl = txtYoutubeUrl.Text;
    }

    private void GetValueFromControlPrenium(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        if (usr != null)
            usr.Email = txtEmailP.Text;

        //Table 1 :user detail      
        userDetail.FirstName = txtFirstNameP.Text;
        userDetail.LastName = txtLastNameP.Text;
        userDetail.PhoneNumber = txtPhoneNumberP.Text;

        //Table 2: polinatorInformation
        polinatorInformation.OrganizationName = txtOrganizationNameP.Text;
        polinatorInformation.PollinatorSize = Int32.Parse(drPollinatorSizeP.SelectedValue);
        polinatorInformation.LandscapeStreet = txtLandscapeStreetP.Text;
        polinatorInformation.LandscapeCity = txtLandscapeCityP.Text;
        polinatorInformation.LandscapeState = txtLandscapeStateP.Text;
        polinatorInformation.LandscapeZipcode = txtLandscapeZipcodeP.Text;
        polinatorInformation.LandscapeCountry = drCountryP.SelectedValue;
        polinatorInformation.PhotoUrl = txtPhotoUrlP.Text;
        polinatorInformation.YoutubeUrl = txtYoutubeUrlP.Text;

        //premium info
        polinatorInformation.Website = txtWebsiteP.Text;
        polinatorInformation.PollinatorType = Int32.Parse(drPollinatorTypeP.SelectedValue);
        polinatorInformation.Description = txtOrganizationDescriptionP.Text;
        polinatorInformation.BillingAddress = txtBillingAddress.Text;
        polinatorInformation.BillingCity = txtBillingCity.Text;
        polinatorInformation.BillingState = txtBillingState.Text;
        polinatorInformation.BillingZipcode = txtBillingZipcode.Text;

    }


    private void SendApprovedEmail(MembershipUser usr)
    {
        if (usr == null)
            return;

        String path = Request.PhysicalApplicationPath + "\\EmailTemplates\\ApprovedPollinator.txt";
        using (StreamReader reader = File.OpenText(path))
        {
            MailMessage myMail = new MailMessage();

            myMail.To.Add(usr.Email);
            myMail.Subject = "Approved Pollinator";
            //  myMail.BodyFormat = MailFormat.Html;   

            String content = reader.ReadToEnd();  // Load the content from your file...   
            content = content.Replace("<%UserName%>", usr.UserName);
            myMail.Body = content;
            SmtpClient smtp = new SmtpClient();

            smtp.Send(myMail);
        }
    }

    private void GoToAlertMessage(Control alert)
    {
        alert.Visible = true;

        //This script will scroll page to the location of message
        string scrollIntoView = @"
             $(document).ready(function () {
                //The element doesn't show up immediately, must set latency for it to bring up
                setTimeout(goToAlertMessage, 10);
            });

            function goToAlertMessage()
            {
                var el = document.getElementById('" + alert.ClientID + @"');
                el.scrollIntoView(true);
            }
        ";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "scrollIntoView_script", scrollIntoView, true);
    }

    #endregion

    #region Properties
    private string UserName
    {
        get
        {
            string text = (string)ViewState["UserName"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["UserName"] = value;
        }
    }

    public Guid UserID
    {
        get
        {
            return (Guid)ViewState["UserID"];

        }
        set
        {
            ViewState["UserID"] = value;
        }
    }

    public string Address
    {
        get
        {
            string text = (string)ViewState["Address"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["Address"] = value;
        }
    }

    public string PollinatorName
    {
        get
        {
            string text = (string)ViewState["PollinatorName"];
            if (text != null)
                return text;
            else
                return string.Empty;
        }
        set
        {
            ViewState["PollinatorName"] = value;
        }
    }
    #endregion
}