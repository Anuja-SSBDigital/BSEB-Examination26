using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PaymentSummary : System.Web.UI.Page
{
    private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(PaymentSummary));
    private static bool isLog4NetConfigured = false;


    private void EnsureLog4NetConfigured()
    {
        if (!isLog4NetConfigured)
        {
            var logRepository = log4net.LogManager.GetRepository(System.Reflection.Assembly.GetExecutingAssembly());
            string configFile = Server.MapPath("~/Web.config"); // Using web.config
            log4net.Config.XmlConfigurator.Configure(logRepository, new FileInfo(configFile));

            isLog4NetConfigured = true;
            log.Info("log4net configured.");
        }
    }

    private void EnsureLogFolder()
    {
        string logFolder = Server.MapPath("~/logs");
        if (!Directory.Exists(logFolder))
        {
            Directory.CreateDirectory(logFolder);
        }
    }
    DBHelper dl = new DBHelper();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            log.Info("Page_Load started.");

            if (Session["CollegeId"] != null)
            {
                log.Info("Session CollegeId found: " + Session["CollegeId"]);
                if (Session["CollegeName"].ToString() == "Admin")
                {
                   
                    txt_CollegeName.Text = "";
                    btngetsummary.Visible = true;
                    lblcollege.Visible = true;
                    txt_CollegeName.Visible = true;
                }
                else
                {
                    log.Info("User is not Admin. Running GetCount() and BindSummary().");
                    // GetCount();
                    BindSummary();
                }



            }
            else
            {
                log.Warn("Session CollegeId is null. Redirecting to Login.aspx.");
                Response.Redirect("Login.aspx");
            }
        }

    }
    private void BindSummary()
    {
        try
        {
            string CollegeId = "";
            if (Session["CollegeName"] != null && Session["CollegeName"].ToString() == "Admin")
            {
                DataTable dt = dl.getcollegeidbasedonCollegecode(txt_CollegeName.Text);
                if (dt.Rows.Count > 0)
                {
                    CollegeId = dt.Rows[0]["Pk_CollegeId"].ToString();
                }
            }
            else if (Session["CollegeId"] != null)
            {
                CollegeId = Session["CollegeId"].ToString();
            }
            else
            {
                Response.Redirect("Login.aspx");
                return;
            }

            DataSet ds = dl.GetExamCollegeWiseSeatSummaryForInfo(Convert.ToInt32(CollegeId));
            if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
            {
                ResetCells();
                return;
            }

            DataTable dtSummary = ds.Tables[0];

            // Reset cells before filling
            ResetCells();

            // 🔹 Fill Science
            FillFacultyExamType(dtSummary, "SCIENCE", "REGULAR", tdSciRegFee, tdSciRegForm, tdSciRegFormNot);
            FillFacultyExamType(dtSummary, "SCIENCE", "EX REGULAR", tdSciExFee, tdSciExForm, tdSciExFormNot);
            FillFacultyExamType(dtSummary, "SCIENCE", "COMPARTMENTAL", tdSciCompFee, tdSciCompForm, tdSciCompFormNot);
            FillFacultyExamType(dtSummary, "SCIENCE", "IMPROVEMENT", tdSciImpFee, tdSciImpForm, tdSciImpFormNot);
            FillFacultyExamType(dtSummary, "SCIENCE", "QUALIFYING", tdSciQualFee, tdSciQualForm, tdSciQualFormNot);

            // 🔹 Fill Arts
            FillFacultyExamType(dtSummary, "ARTS", "REGULAR", tdArtsRegFee, tdArtsRegForm, tdArtsRegFormNot);
            FillFacultyExamType(dtSummary, "ARTS", "EX REGULAR", tdArtsExFee, tdArtsExForm, tdArtsExFormNot);
            FillFacultyExamType(dtSummary, "ARTS", "COMPARTMENTAL", tdArtsCompFee, tdArtsCompForm, tdArtsCompFormNot);
            FillFacultyExamType(dtSummary, "ARTS", "IMPROVEMENT", tdArtsImpFee, tdArtsImpForm, tdArtsImpFormNot);
            FillFacultyExamType(dtSummary, "ARTS", "QUALIFYING", tdArtsQualFee, tdArtsQualForm, tdArtsQualFormNot);


            // 🔹 Fill Commerce
            FillFacultyExamType(dtSummary, "COMMERCE", "REGULAR", tdComRegFee, tdComRegForm, tdComRegFormNot);
            FillFacultyExamType(dtSummary, "COMMERCE", "EX REGULAR", tdComExFee, tdComExForm, tdComExFormNot);
            FillFacultyExamType(dtSummary, "COMMERCE", "COMPARTMENTAL", tdComCompFee, tdComCompForm, tdComCompFormNot);
            FillFacultyExamType(dtSummary, "COMMERCE", "IMPROVEMENT", tdComImpFee, tdComImpForm, tdComImpFormNot);
            FillFacultyExamType(dtSummary, "COMMERCE", "QUALIFYING", tdComQualFee, tdComQualForm, tdComQualFormNot);

            // 🔹 Fill Vocational
            FillFacultyExamType(dtSummary, "VOCATIONAL", "REGULAR", tdVocRegFee, tdVocRegForm, tdVocRegFormNot);
            FillFacultyExamType(dtSummary, "VOCATIONAL", "EX REGULAR", tdVocExFee, tdVocExForm, tdVocExFormNot);
            FillFacultyExamType(dtSummary, "VOCATIONAL", "COMPARTMENTAL", tdVocCompFee, tdVocCompForm, tdVocCompFormNot);
            FillFacultyExamType(dtSummary, "VOCATIONAL", "IMPROVEMENT", tdVocImpFee, tdVocImpForm, tdVocImpFormNot);
            FillFacultyExamType(dtSummary, "VOCATIONAL", "QUALIFYING", tdVocQualFee, tdVocQualForm, tdVocQualFormNot);


        }
        catch (Exception ex)
        {
            // Escape single quotes for JS safety
            string safeMessage = ex.Message.Replace("'", "\\'");

            // Show in SweetAlert
            ScriptManager.RegisterStartupScript(this, GetType(), "SeatSummaryError", @"
        swal({
            title: 'Error',
            text: 'Error loading summary: " + safeMessage + @"',
            icon: 'error',
            button: 'Close'
        });
    ", true);
        }
    }

    protected void btngetsummary_Click(object sender, EventArgs e)
    {
        BindSummary();
    }
    private void ResetCells()
    {
        tdSciRegFee.InnerText = tdSciRegForm.InnerText = tdSciRegFormNot.InnerText = "--";
        tdSciExFee.InnerText = tdSciExForm.InnerText = tdSciExFormNot.InnerText = "--";
        tdSciCompFee.InnerText = tdSciCompForm.InnerText = tdSciCompFormNot.InnerText = "--";
        tdSciImpFee.InnerText = tdSciImpForm.InnerText = tdSciImpFormNot.InnerText = "--";
        tdSciQualFee.InnerText = tdSciQualForm.InnerText = tdSciQualFormNot.InnerText = "--";

        tdArtsRegFee.InnerText = tdArtsRegForm.InnerText = tdArtsRegFormNot.InnerText = "--";
        tdArtsExFee.InnerText = tdArtsExForm.InnerText = tdArtsExFormNot.InnerText = "--";
        tdArtsCompFee.InnerText = tdArtsCompForm.InnerText = tdArtsCompFormNot.InnerText = "--";
        tdArtsImpFee.InnerText = tdArtsImpForm.InnerText = tdArtsImpFormNot.InnerText = "--";
        tdArtsQualFee.InnerText = tdArtsQualForm.InnerText = tdArtsQualFormNot.InnerText = "--";

        tdComRegFee.InnerText = tdComRegForm.InnerText = tdComRegFormNot.InnerText = "--";
        tdComExFee.InnerText = tdComExForm.InnerText = tdComExFormNot.InnerText = "--";
        tdComCompFee.InnerText = tdComCompForm.InnerText = tdComCompFormNot.InnerText = "--";
        tdComImpFee.InnerText = tdComImpForm.InnerText = tdComImpFormNot.InnerText = "--";
        tdComQualFee.InnerText = tdComQualForm.InnerText = tdComQualFormNot.InnerText = "--";

        tdVocRegFee.InnerText = tdVocRegForm.InnerText = tdVocRegFormNot.InnerText = "--";
        tdVocExFee.InnerText = tdVocExForm.InnerText = tdVocExFormNot.InnerText = "--";
        tdVocCompFee.InnerText = tdVocCompForm.InnerText = tdVocCompFormNot.InnerText = "--";
        tdVocImpFee.InnerText = tdVocImpForm.InnerText = tdVocImpFormNot.InnerText = "--";
        tdVocQualFee.InnerText = tdVocQualForm.InnerText = tdVocQualFormNot.InnerText = "--";
    }
    private void FillFacultyExamType(
     DataTable dt, string facultyName, string examKeyword,
     System.Web.UI.HtmlControls.HtmlTableCell feeCell,
     System.Web.UI.HtmlControls.HtmlTableCell formCell,
     System.Web.UI.HtmlControls.HtmlTableCell formNotCell)
    {
        // normalize input
        string facultyUpper = facultyName.ToUpper();
        string examUpper = examKeyword.ToUpper();

        // Look for exact match on Exam Type
        var row = dt.AsEnumerable()
            .FirstOrDefault(r =>
                r.Field<string>("Faculty") != null &&
                r.Field<string>("Exam Type") != null &&
                r.Field<string>("Faculty").Trim().ToUpper() == facultyUpper &&
                r.Field<string>("Exam Type").Trim().ToUpper() == examUpper);

        if (row != null)
        {
            feeCell.InnerText = row["Fee Submitted"].ToString();
            formCell.InnerText = row["Form Submitted"].ToString();
            formNotCell.InnerText = row["Form Not Submitted"].ToString();
        }
        else
        {
            feeCell.InnerText = "--";
            formCell.InnerText = "--";
            formNotCell.InnerText = "--";
        }
    }



}