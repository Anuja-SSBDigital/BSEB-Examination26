using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PayExamFormFee : System.Web.UI.Page
{
    DBHelper db = new DBHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["CollegeId"] != null)
        {
            if (!IsPostBack)
            {
                Binddropdown();

                divpayment.Visible = false;
                divstudentdetails.Visible = false;
                rdo_makepayment.Checked = true;


                if (Session["CollegeName"].ToString() == "Admin")
                {
                    txt_collegename.Text = "";
                }
                else
                {
                    txt_collegename.Text = Session["CollegeCode"].ToString() + " | " + Session["CollegeName"].ToString();
                    txt_collegename.ReadOnly = true;
                }
            }

        }
        else
        {
            Response.Redirect("Login.aspx");
        }
    }

   

    public void Binddropdown()
    {
        DataTable dtstate = db.getFacultyfordropdown();
        if (dtstate.Rows.Count > 0)
        {
            ddlFaculty.DataSource = dtstate;
            ddlFaculty.DataTextField = "FacultyName";
            ddlFaculty.DataValueField = "Pk_FacultyId";
            ddlFaculty.DataBind();
            ddlFaculty.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Faculty", "0"));
        }
        else
        {
            ddlFaculty.Items.Clear();
            ddlFaculty.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Faculty", "0"));
        }
        DataTable dtExamcat = db.getExamCatfordropdown();
        var filtered = dtExamcat.AsEnumerable().Where(row => row.Field<int>("Pk_ExamTypeId") != 5);

        if (filtered.Any())
        {
            ddlExamcat.DataSource = filtered.CopyToDataTable();
            ddlExamcat.DataTextField = "ExamTypeName";
            ddlExamcat.DataValueField = "Pk_ExamTypeId";
            ddlExamcat.DataBind();
        }
        else
        {
            ddlExamcat.Items.Clear();
        }

       // ddlExamcat.Items.Insert(0, new ListItem("Select Exam Category", "0"));

    }

    protected void btn_getdetails_Click(object sender, EventArgs e)
    {
      
        string Collegename = Session["CollegeName"].ToString();
     //   string CategoryName = ddl_category.SelectedValue;
        int facultyId = Convert.ToInt32(ddlFaculty.SelectedValue);
        int ExamId = Convert.ToInt32(ddlExamcat.SelectedValue);
        if (rdo_payemntstatus.Checked == true)
        {
            int collegeid = 0;
            string collegecode = "";
         
          
            if (Collegename != "Admin")
            {


                collegeid = Convert.ToInt32(Session["CollegeId"]);

            }
            else
            {
                collegecode = txt_collegename.Text;
            }
            DataTable result = db.GetExamPaymentDetails(collegeid, collegecode,ExamId);
            rpt_getpayemnt.DataSource = result;
            rpt_getpayemnt.DataBind();
            divpayment.Visible = true;
            divstudentdetails.Visible = false;
        }
        else
        {
            //string faculty = "";
            string CollegeName = "";
            if (Collegename == "Admin")
            {

                CollegeName = txt_collegename.Text;

            }
            else
            {

                string CollegeNameAndCode = txt_collegename.Text.Trim();
                string[] CollegeNameSplit = CollegeNameAndCode.Split('|');
                CollegeName = CollegeNameSplit[0].Trim();
            }

            string CollegeCode = "";
            string CollegeId = "";
            if (Session["CollegeName"].ToString() == "Admin")
            {
                CollegeCode = txt_collegename.Text;
                CollegeId = "";
            }
            else
            {
                CollegeCode = "";
                CollegeId = Session["CollegeId"].ToString();
            }

            DataTable result = db.getExamDwnldStudentData(CollegeId, CollegeCode, "", facultyId, ExamId, "Private", "makepayment");
          //  DataTable result = db.getExamDwnldStudentData(CollegeId, CollegeCode, "", facultyId, ExamId, "makepayment");

            if (result != null && result.Rows.Count > 0)
            {
                rptStudents.DataSource = result;
                rptStudents.DataBind();
                divpayment.Visible = false;
                divstudentdetails.Visible = true;
                divpnlNoRecords.Visible = false;
                pnlStudentTable.Visible = true;
                pnlPager.Visible = true;
                searchInputDIV.Visible = true;
                pnlPager.Visible = true;
            }
            else
            {
                rptStudents.DataSource = null;
                rptStudents.DataBind();
                divpayment.Visible = false;
                divstudentdetails.Visible = true;
                pnlStudentTable.Visible = false;
                pnlPager.Visible = false;
                searchInputDIV.Visible = false;
                divpnlNoRecords.Visible = true;
            }
        }

    }

     protected void btn_paynow_Click(object sender, EventArgs e)
    {

        string collegeCode = "";
        string collegeName = "";
        int collegeId = 0;
        string Mobileno = "";
        string EmailId = "";

        if (Session["CollegeName"].ToString() == "Admin")
        {
            DataTable dtres = db.getcollegeidbasedonCollegecode(txt_collegename.Text);

            if (dtres.Rows.Count > 0)
            {
                collegeCode = dtres.Rows[0]["CollegeCode"].ToString();
                collegeName = dtres.Rows[0]["CollegeName"].ToString();
                collegeId = Convert.ToInt32(dtres.Rows[0]["Pk_CollegeId"]);
                Mobileno = dtres.Rows[0]["PrincipalMobileNo"].ToString();
                EmailId = dtres.Rows[0]["EmailId"].ToString();
            }
        }
        else
        {
            Mobileno = Session["PrincipalMobileNo"].ToString();
            collegeCode = Session["CollegeCode"].ToString();
            collegeName = Session["CollegeName"].ToString();
            collegeId = Convert.ToInt32(Session["CollegeId"]);
            EmailId = Session["EmailId"].ToString();
        }

        string username = Session["username"].ToString();

        // ✅ Get selected IDs from hidden field
        string selectedStudentIds = hfSelectedIds.Value;

        if (string.IsNullOrEmpty(selectedStudentIds))
        {
            string script = @"
            swal({
                title: 'Failed',
                text: 'Please select at least one student',
                icon: 'error',
                button: 'Retry'
            });";
            ScriptManager.RegisterStartupScript(this, GetType(), "PaymentFailedBank", script, true);
            return;
        }

        // ✅ Calculate total amount from selected students
        //long totalAmount = 0;
        //string[] selectedIdsArray = selectedStudentIds.Split(',');

        //foreach (RepeaterItem item in rptStudents.Items)
        //{
        //    HiddenField hfStudentID = (HiddenField)item.FindControl("hfStudentID");
        //    Label lblFee = (Label)item.FindControl("lblFee");

        //    if (hfStudentID != null && lblFee != null && selectedIdsArray.Contains(hfStudentID.Value))
        //    {
        //        totalAmount += Convert.ToInt64(lblFee.Text);
        //    }
        //}

        string payerName = collegeName + " | " + collegeCode;
        string payerMobile = ""; // optional
        string payerEmail = "";  // optional

        string clientTxnId = "N/A";

        // ✅ Insert payment details into DB
        string message = db.InsertStudentPaymentDetails(
            collegeId,
            2, 
            ddl_paymode.SelectedValue,
            Convert.ToDecimal(hfTotalAmount.Value),
            selectedStudentIds
        );

        if (message.Contains("Seat limit exceeded"))
        {
            string script = @"
            swal({
                title: 'Failed!',
                text: '" + message.Replace("'", "\\'") + @"',
                icon: 'error',
                button: 'OK'
            });";
            ScriptManager.RegisterStartupScript(this, GetType(), "PaymentSeatLimit", script, true);
            return;
        }
        else if (message.StartsWith("Success"))
        {
            int txnIndex = message.IndexOf("Transaction ID:");
            if (txnIndex != -1)
            {
                clientTxnId = message.Substring(txnIndex + "Transaction ID:".Length).Trim();
            }

            string script = @"
            swal({
                title: 'Success!',
                text: 'Payment completed successfully.',
                icon: 'success',
                button: 'OK'
            });";
            ScriptManager.RegisterStartupScript(this, GetType(), "PaymentSuccess", script, true);
        }
        else
        {
            string script = @"
            swal({
                title: 'Failed!',
                text: '" + message.Replace("'", "\\'") + @"',
                icon: 'error',
                button: 'OK'
            });";
            ScriptManager.RegisterStartupScript(this, GetType(), "PaymentFail", script, true);
            return;
        }

        // ✅ Prepare SabPaisa redirect values
        string clientCode = ConfigurationManager.AppSettings["Clientcode"];
        string transUserName = ConfigurationManager.AppSettings["transUserName"];
        string transUserPassword = ConfigurationManager.AppSettings["transUserPassword"];
        string authKey = ConfigurationManager.AppSettings["AuthenticationKey"];
        string authIV = ConfigurationManager.AppSettings["AuthenticationIV"];
        string callbackUrl = ConfigurationManager.AppSettings["callbackUrl"];

        string encryptedData = forwardToSabPaisa(
            clientCode,
            transUserName,
            transUserPassword,
            authKey,
            authIV,
            payerName,
            payerEmail,
            payerMobile,
            "",
            clientTxnId,
           hfTotalAmount.Value,
            "INR",
            "W",
            "8795",
            callbackUrl
        );

        string respString = "<html>" +
            "<body onload='document.forms[\"sabPaisaForm\"].submit()'>" +
            "<form name='sabPaisaForm' method='post' action='https://stage-securepay.sabpaisa.in/SabPaisa/sabPaisaInit?v=1'>" +
            "<input type='hidden' name='encData' value='" + encryptedData + "' />" +
            "<input type='hidden' name='clientCode' value='" + clientCode + "' />" +
            "</form>" +
            "</body>" +
            "</html>";

        Response.Clear();
        Response.Write(respString);
        Response.End();



    }


    public string forwardToSabPaisa(
      string clientCode, string transUserName, string transUserPassword,
      string authKey, string authIV, string payerName, string payerEmail, string payerMobile,
      string payerAddress, string clientTxnId, string amount, string amountType,
      string channelId, string mcc, string callbackUrl)
    {
        string query = "?clientCode=" + HttpUtility.UrlEncode(clientCode) +
                       "&transUserName=" + HttpUtility.UrlEncode(transUserName) +
                       "&transUserPassword=" + HttpUtility.UrlEncode(transUserPassword) +
                       "&authKey=" + HttpUtility.UrlEncode(authKey) +
                       "&authIV=" + HttpUtility.UrlEncode(authIV) +
                       "&payerName=" + HttpUtility.UrlEncode(payerName) +
                       "&payerEmail=" + HttpUtility.UrlEncode(payerEmail) +
                       "&payerMobile=" + HttpUtility.UrlEncode(payerMobile) +
                       "&payerAddress=" + HttpUtility.UrlEncode(payerAddress) +
                       "&clientTxnId=" + HttpUtility.UrlEncode(clientTxnId) +
                       "&amount=" + HttpUtility.UrlEncode(amount) +
                       "&amountType=" + HttpUtility.UrlEncode(amountType) +
                       "&channelId=" + HttpUtility.UrlEncode(channelId) +
                       "&mcc=" + HttpUtility.UrlEncode(mcc) +
                       "&callbackUrl=" + HttpUtility.UrlEncode(callbackUrl);

        return EncryptString(query, authIV, authKey);
    }
    public static string EncryptString(string plainText, string iv, string key)
    {
        using (var csp = new AesCryptoServiceProvider())
        {
            csp.Mode = CipherMode.CBC;
            csp.Padding = PaddingMode.PKCS7;
            csp.IV = Encoding.UTF8.GetBytes(iv);
            csp.Key = Encoding.UTF8.GetBytes(key);

            ICryptoTransform encryptor = csp.CreateEncryptor();
            byte[] inputBuffer = Encoding.UTF8.GetBytes(plainText);
            byte[] encryptedBytes = encryptor.TransformFinalBlock(inputBuffer, 0, inputBuffer.Length);

            return Convert.ToBase64String(encryptedBytes);
        }
    }

    private static ICryptoTransform GetCryptoTransform(AesCryptoServiceProvider csp, bool encrypting, String AuthIV, String AuthKey)
    {
        csp.Mode = CipherMode.CBC;
        csp.Padding = PaddingMode.PKCS7;
        String iv = AuthIV;
        String AESKey1 = AuthKey;
        csp.IV = Encoding.UTF8.GetBytes(iv);
        byte[] inputBuffer = Encoding.UTF8.GetBytes(AESKey1);
        csp.Key = Encoding.UTF8.GetBytes(AESKey1);
        if (encrypting)
        {
            return csp.CreateEncryptor();
        }
        return csp.CreateDecryptor();
    }



    protected void rpt_getpayemnt_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "lnk_Delete")
        {
            string clientTxnId = e.CommandArgument.ToString();

            int result = db.DeletePaymentDetails(clientTxnId);
            if (result == 0)
            {
                //string script = "alert('Payment record deleted successfully.'); window.location=window.location.href;";
                //ClientScript.RegisterStartupScript(this.GetType(), "DeleteSuccess", script, true);

                string script = @"
swal({
    title: 'Success!',
    text: 'Payment record deleted successfully.',
    icon: 'success',
    button: 'OK'
}).then(function() {
    window.location = 'PayExamFormFee.aspx'; 
});";

                ScriptManager.RegisterStartupScript(this, GetType(), "RecordDeleted", script, true);


            }
            else
            {


                string script = @"
    swal({
        title: 'Failed!',
        text: 'Payment record not found or deletion failed',
        icon: 'error',
        button: 'OK'
    });";

                ScriptManager.RegisterStartupScript(this, GetType(), "DeleteFail", script, true);



                //string script = "alert('Payment record not found or deletion failed.');";
                //ClientScript.RegisterStartupScript(this.GetType(), "DeleteFail", script, true);
            }
        }
    }

    protected void rpt_getpayemnt_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            LinkButton lnkDelete = (LinkButton)e.Item.FindControl("lnkDelete");
            HiddenField hf_status = (HiddenField)e.Item.FindControl("hf_status");

            // Check user's role from Session or any auth source
            string Collegename = Session["CollegeName"] as string;
            string status = hf_status.Value;

            if (Collegename == "Admin")
            {
                // Admin sees delete button always
                lnkDelete.Visible = true;
            }
            else
            {
                // Colleges see delete only if status is Failure or Aborted
                if (status == "FAILED" || status == "ABORTED")
                {
                    lnkDelete.Visible = true;
                }
                else
                {
                    lnkDelete.Visible = false;
                }
            }
        }
    }
}