using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

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
            ddlExamcat.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Exam Category", "0"));
        }
        else
        {
            ddlExamcat.Items.Clear();
        }

        // ddlExamcat.Items.Insert(0, new ListItem("Select Exam Category", "0"));

    }

    protected void btn_getdetails_Click(object sender, EventArgs e)
    {
        try
        {

            string Collegename = Session["CollegeName"].ToString();
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
                // Force TLS 1.2 for secure API calls
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                DataTable result = db.GetExamPaymentDetails(collegeid, collegecode, ExamId);
                if (result != null && result.Rows.Count > 0)
                {

                    foreach (DataRow row in result.Rows)
                    {
                        string clientTxnId = row["ClientTxnId"].ToString();
                        string rowStatus = row.Table.Columns.Contains("PaymentStatus") && row["PaymentStatus"] != DBNull.Value
                   ? row["PaymentStatus"].ToString()
                   : string.Empty;

                        if (string.IsNullOrEmpty(rowStatus) ||
       rowStatus.Equals("FAILED", StringComparison.OrdinalIgnoreCase) ||
       rowStatus.Equals("INITIATED", StringComparison.OrdinalIgnoreCase) ||
       rowStatus.Equals("CHALLAN_GENERATED", StringComparison.OrdinalIgnoreCase))
                        {
                            string clientCode = ConfigurationManager.AppSettings["Clientcode"];
                            string url = "https://txnenquiry.sabpaisa.in/SPTxtnEnquiry/TransactionEnquiryServlet?clientCode=" + clientCode + "&clientXtnId=" + clientTxnId;

                            string responseString = "";
                            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                            request.Method = "GET";

                            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                            using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                            {
                                responseString = reader.ReadToEnd();
                            }

                            XmlDocument xmlDoc = new XmlDocument();
                            xmlDoc.LoadXml(responseString);
                            XmlNode txnNode = xmlDoc.SelectSingleNode("/transaction");

                            if (txnNode != null)
                            {
                                string apiStatus = txnNode.Attributes["status"] != null
                            ? txnNode.Attributes["status"].Value
                            : "";

                                string paymentStatusCode = txnNode.Attributes["sabPaisaRespCode"] != null
                                                            ? txnNode.Attributes["sabPaisaRespCode"].Value
                                                            : "";

                                string bankTxnId = txnNode.Attributes["txnId"] != null
                                                            ? txnNode.Attributes["txnId"].Value
                                                            : "";

                                string paidAmount = txnNode.Attributes["payeeAmount"] != null
                                                            ? txnNode.Attributes["payeeAmount"].Value
                                                            : "";

                                string paymentUpdateddate = txnNode.Attributes["transCompleteDate"] != null
                                                            ? txnNode.Attributes["transCompleteDate"].Value
                                                            : "";

                                string paymentmode = txnNode.Attributes["paymentMode"] != null
                                                            ? txnNode.Attributes["paymentMode"].Value
                                                            : "";

                                string errorcode = txnNode.Attributes["errorCode"] != null
                                                            ? txnNode.Attributes["errorCode"].Value
                                                            : "";


                                if (errorcode == "400")
                                {
                                    
                                    continue; // go to next txnNode
                                }

                                // Update database
                                db.UpdateChallanInquiry(clientTxnId, apiStatus, paymentStatusCode, bankTxnId, paidAmount, paymentmode, paymentUpdateddate);

                                // Update student fees if SUCCESS
                                if (apiStatus.Equals("SUCCESS", StringComparison.OrdinalIgnoreCase))
                                {
                                    DataSet dsStudents = db.GetStdntPaymntDetailsTxnIdwise(clientTxnId);
                                    if (dsStudents != null && dsStudents.Tables.Count > 0)
                                    {
                                        DataTable dtStudents = dsStudents.Tables[1];
                                        foreach (DataRow rowst in dtStudents.Rows)
                                        {
                                            int studentId = Convert.ToInt32(rowst["Fk_StudentId"]);
                                            db.UpdateStudentExamFeeSubmit(studentId);
                                        }
                                    }
                                }

                                // Show alert only if errorCode exists AND is not 400
//                                if (!string.IsNullOrEmpty(errorcode) && errorcode != "400")
//                                {
//                                    string script = @"
//swal({{
//    title: 'Failed',
//    text: 'Transaction ID: {clientTxnId}\nError Code: {errorcode}',
//    icon: 'error',
//    button: 'Retry'
//}});";
//                                    ScriptManager.RegisterStartupScript(this, GetType(), "PaymentFailedBank", script, true);
//                                    System.Diagnostics.Debug.WriteLine("Transaction error for " + clientTxnId + ": " + errorcode);
//                                }
                            }
                            else
                            {
                                // txnNode is null
                                string script = @"
swal({{
    title: 'Failed',
    text: 'No transaction data found for Transaction ID: {clientTxnId}',
    icon: 'error',
    button: 'Retry'
}});";
                                ScriptManager.RegisterStartupScript(this, GetType(), "PaymentFailedBank", script, true);
                                System.Diagnostics.Debug.WriteLine("No transaction data found for " + clientTxnId);
                            }
                        }

                    }




                    
                  
                }
                //else
                //{
                //    rpt_getpayemnt.DataSource = null;
                //    rpt_getpayemnt.DataBind();
                //    divpnlNoRecords.Visible = true;
                //    divstudentdetails.Visible = false;
                //    //pnlStudentTable.Visible = false;
                //}
                // Rebind fresh data
                DataTable result1 = db.GetExamPaymentDetails(collegeid, collegecode, ExamId);
                if (result1 != null && result1.Rows.Count > 0)
                {
                    rpt_getpayemnt.DataSource = result1;
                    rpt_getpayemnt.DataBind();

                    divpayment.Visible = true;
                    divstudentdetails.Visible = false;
                    divpnlNoRecords.Visible = false;
                    pnlStudentTable.Visible = false;
                }
                else
                {
                    rpt_getpayemnt.DataSource = null;
                    rpt_getpayemnt.DataBind();
                    divpnlNoRecords.Visible = true;
                    pnlStudentTable.Visible = false;
                }

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


                string CollegeId = "";
                if (Session["CollegeName"].ToString() == "Admin")
                {
                    DataTable dt = db.getcollegeidbasedonCollegecode(txt_collegename.Text);

                    if (dt.Rows.Count > 0)
                    {
                        CollegeId = dt.Rows[0]["Pk_CollegeId"].ToString();
                    }
                }
                else if (Session["CollegeId"] != null)
                {
                    CollegeId = Session["CollegeId"].ToString();
                }

                DataTable result = db.getExamDwnldStudentData(CollegeId, "", facultyId, ExamId, "", "makepayment");
                if (result != null && result.Rows.Count > 0)
                {
                    rptStudents.DataSource = result;
                    rptStudents.DataBind();
                    divpayment.Visible = false;
                    divstudentdetails.Visible = true;
                    pnlStudentTable.Visible = true;
                    divpnlNoRecords.Visible = false;
                    pnlPager.Visible = true;
                    searchInputDIV.Visible = true;
                    pnlPager.Visible = true;

                }
                else
                {
                    rptStudents.DataSource = null;
                    rptStudents.DataBind();
                    divpayment.Visible = false;
                    divstudentdetails.Visible = false;
                    pnlStudentTable.Visible = false;
                    divpnlNoRecords.Visible = true;
                    pnlPager.Visible = false;
                    searchInputDIV.Visible = false;
                }
            }
        }
        catch (Exception exOuter)
        {
            string script = string.Format(@"
    swal({{
        title: 'Failed',
        text: '{0}',
        icon: 'error',
        button: 'Retry'
    }});", exOuter.Message.Replace("'", "\\'"));

            ScriptManager.RegisterStartupScript(this, GetType(), "PaymentFailedBank", script, true);
            System.Diagnostics.Debug.WriteLine("General Error: " + exOuter.Message);
        }
    }

    protected void btn_paynow_Click(object sender, EventArgs e)
    {
        try
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

            string payerName = collegeCode;
            string payerMobile = Mobileno;
            string payerEmail = EmailId;

            string clientTxnId = "N/A";
            string studentFeeMapping = hfSelectedStudentFees.Value;
            decimal totalAmount = 0;

            if (!string.IsNullOrEmpty(studentFeeMapping))
            {
                foreach (string item in studentFeeMapping.Split(','))
                {
                    string[] parts = item.Split(':');
                    decimal fee;
                    if (parts.Length == 2 && decimal.TryParse(parts[1], out fee))
                    {
                        totalAmount += fee;
                    }
                }
            }

            // ✅ Insert payment details into DB
            string message = db.InsertExamStudentPayment(
                collegeId,
                2,
                ddl_paymode.SelectedValue,
                totalAmount,
                selectedStudentIds
            );

            if (message.StartsWith("Success"))
            {
                int txnIndex = message.IndexOf("Transaction ID:");
                if (txnIndex != -1)
                {
                    clientTxnId = message.Substring(txnIndex + "Transaction ID:".Length).Trim();
                }

                //string script = @"
                //swal({
                //    title: 'Success!',
                //    text: 'Payment completed successfully.',
                //    icon: 'success',
                //    button: 'OK'
                //});";
                //ScriptManager.RegisterStartupScript(this, GetType(), "PaymentSuccess", script, true);
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


            string clientCode = ConfigurationManager.AppSettings["Clientcode"];
            string transUserName = ConfigurationManager.AppSettings["transUserName"];
            string transUserPassword = ConfigurationManager.AppSettings["transUserPassword"];
            string authKey = ConfigurationManager.AppSettings["AuthenticationKey"];
            string authIV = ConfigurationManager.AppSettings["AuthenticationIV"];
            string callbackUrl = ConfigurationManager.AppSettings["callbackUrl"];
            string mcc = ConfigurationManager.AppSettings["mcc"];
            string AmountType = ConfigurationManager.AppSettings["AmountType"];
            string channelid = ConfigurationManager.AppSettings["channelid"];



            string query = "";
            string address = "";

            query = query + "payerName=" + payerName.Trim() + "";
            query = query + "&payerEmail=" + payerEmail.Trim() + "";
            query = query + "&payerMobile=" + payerMobile.Trim() + "";
            query = query + "&clientCode=" + clientCode.Trim() + "";
            query = query + "&transUserName=" + transUserName.Trim() + "";
            query = query + "&transUserPassword=" + transUserPassword.Trim() + "";
            query = query + "&payerAddress=" + address + "";
            query = query + "&clientTxnId=" + clientTxnId.Trim() + "";
            query = query + "&amount=" + totalAmount.ToString() + "";

            query = query + "&amountType=" + AmountType.Trim() + "";
            query = query + "&channelId=" + channelid.Trim() + "";
            query = query + "&mcc=" + mcc.Trim() + "";
            query = query + "&callbackUrl=" + callbackUrl.Trim() + "";

            // Pass extra parameters in Udf1 to udf20 
            //query = query + "&udf1=" + Class.Trim() + "";
            //query = query + "&udf2=" + Roll.Trim() + "";
            Encryption enc = new Encryption();
            // Encrypting the query string
            string encdata = enc.EncryptString(authKey, authIV, query);

            // Create an HTML form for submitting the request to the payment gateway
            string respString = "<html>" +
                              "<body onload='document.forms[0].submit()'>" +   // Auto-submit on load
                                 // "<form action=\"https://securepay.sabpaisa.in/SabPaisa/sabPaisaInit?v=1\" method=\"post\">" +
                                       "<form action=\"https://stage-securepay.sabpaisa.in/SabPaisa/sabPaisaInit?v=1\" method=\"post\">" +
                                      "<input type=\"hidden\" name=\"encData\" value=\"" + encdata + "\" id=\"frm1\">" +
                                      "<input type=\"hidden\" name=\"clientCode\" value=\"" + clientCode + "\" id=\"frm2\">" +
                                      "<noscript><input type=\"submit\" value=\"Click here to continue\"></noscript>" + // fallback if JS is disabled
                                  "</form>" +
                              "</body>" +
                           "</html>";



            Response.Write(respString);
        }
        catch (Exception ex)
        {
            string safeMessage = ex.Message.Replace("'", "\\'");
            string script = @"
    swal({
        title: 'Error',
        text: 'Error during payment initialization: " + safeMessage + @"',
        icon: 'error',
        button: 'Close'
    });";
            ScriptManager.RegisterStartupScript(this, GetType(), "PaymentInitError", script, true);
        }



    }


    //public string forwardToSabPaisa(
    //  string clientCode, string transUserName, string transUserPassword,
    //  string authKey, string authIV, string payerName, string payerEmail, string payerMobile,
    //  string payerAddress, string clientTxnId, string amount, string amountType,
    //  string channelId, string mcc, string callbackUrl)
    //{
    //    string query = "?clientCode=" + HttpUtility.UrlEncode(clientCode) +
    //                   "&transUserName=" + HttpUtility.UrlEncode(transUserName) +
    //                   "&transUserPassword=" + HttpUtility.UrlEncode(transUserPassword) +
    //                   "&authKey=" + HttpUtility.UrlEncode(authKey) +
    //                   "&authIV=" + HttpUtility.UrlEncode(authIV) +
    //                   "&payerName=" + HttpUtility.UrlEncode(payerName) +
    //                   "&payerEmail=" + HttpUtility.UrlEncode(payerEmail) +
    //                   "&payerMobile=" + HttpUtility.UrlEncode(payerMobile) +
    //                   "&payerAddress=" + HttpUtility.UrlEncode(payerAddress) +
    //                   "&clientTxnId=" + HttpUtility.UrlEncode(clientTxnId) +
    //                   "&amount=" + HttpUtility.UrlEncode(amount) +
    //                   "&amountType=" + HttpUtility.UrlEncode(amountType) +
    //                   "&channelId=" + HttpUtility.UrlEncode(channelId) +
    //                   "&mcc=" + HttpUtility.UrlEncode(mcc) +
    //                   "&callbackUrl=" + HttpUtility.UrlEncode(callbackUrl);

    //    return EncryptString(query, authIV, authKey);
    //}
    //public static string EncryptString(string plainText, string iv, string key)
    //{
    //    using (var csp = new AesCryptoServiceProvider())
    //    {
    //        csp.Mode = CipherMode.CBC;
    //        csp.Padding = PaddingMode.PKCS7;
    //        csp.IV = Encoding.UTF8.GetBytes(iv);
    //        csp.Key = Encoding.UTF8.GetBytes(key);

    //        ICryptoTransform encryptor = csp.CreateEncryptor();
    //        byte[] inputBuffer = Encoding.UTF8.GetBytes(plainText);
    //        byte[] encryptedBytes = encryptor.TransformFinalBlock(inputBuffer, 0, inputBuffer.Length);

    //        return Convert.ToBase64String(encryptedBytes);
    //    }
    //}

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

            if (status != "SUCCESS")
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