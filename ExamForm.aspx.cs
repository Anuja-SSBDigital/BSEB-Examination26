using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ExamForm : System.Web.UI.Page
{
    DBHelper dl = new DBHelper();

    public void getcollegewiseseatsummary()
    {
        int CollegeId = 0;
        if (Session["CollegeName"].ToString() == "Admin")
        {
            DataTable dtres = dl.getcollegeidbasedonCollegecode(txt_CollegeName.Text);

            if (dtres.Rows.Count > 0)
            {
                CollegeId = Convert.ToInt32(dtres.Rows[0]["Pk_CollegeId"].ToString());

            }

        }
        else
        {
            CollegeId = Convert.ToInt32(hfCollegeId.Value);
        }
        DataTable dt = dl.GetCollegeWiseEXMSeatSummary(CollegeId, Convert.ToInt32(ddlFaculty.SelectedValue));
        if (dt != null && dt.Rows.Count > 0)
        {

           
            lbl_totalpayment.Text = dt.Rows[0]["TotalPaymentDone"].ToString();
            lbl_totalformsubmitted.Text = dt.Rows[0]["TotalFormSubmitted"].ToString();
            lbl_pymntdonefrmntsubmitd.Text = dt.Rows[0]["PaymentDoneFormNotSubmitted"].ToString();
        }
        else
        {
           
            lbl_totalpayment.Text = "0";
            lbl_totalformsubmitted.Text = "0";
            lbl_pymntdonefrmntsubmitd.Text = "0";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["CollegeId"] != null)
            {
               
                if (Session["CollegeName"].ToString() == "Admin")
                {
                    txt_CollegeName.Text = "";
                }
                else
                {
                    txt_CollegeName.Text = Session["CollegeCode"].ToString() + " | " + Session["CollegeName"].ToString();
                    txt_CollegeName.ReadOnly = true;
                    string CollegeId = Session["CollegeId"].ToString();
                    hfCollegeId.Value = CollegeId.ToString();
                }

                Binddropdown();

                pnlNoRecords.Visible = false;
                pnlStudentTable.Visible = false;
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
            //string script = @"
            //<script type='text/javascript'>
            //    window.onload = function() {
            //        document.getElementById('Regular').checked = true;
            //        handleRegTypeChange();
            //    };
            //</script>";
            //ClientScript.RegisterStartupScript(this.GetType(), "DefaultRadios", script);

        }


    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        try
        {

            string studentId = ((Button)sender).CommandArgument;
            //string RegistrationType = Request.Form["regType"];
            Button btnEdit = (Button)sender;
            RepeaterItem item = (RepeaterItem)btnEdit.NamingContainer;
            HiddenField hfExamTypeid = (HiddenField)item.FindControl("hfExamTypeid");
            string examTypeId = hfExamTypeid != null ? hfExamTypeid.Value : "";
            string url = "ViewExamDetalis.aspx?studentId=" + Server.UrlEncode(studentId.ToString()) + "&examTypeId=" + Server.UrlEncode(examTypeId.ToString()) + "&from=ExamForm";
            Response.Redirect(url, false);

            // string url = "viewstudentregdetalis.aspx?studentId=" + Server.UrlEncode(studentId.ToString()) +
            //"&RegistrationType=" + Server.UrlEncode(RegistrationType) + "&examTypeId=" +Server.UrlEncode(examTypeId.ToString()) +
            //"&from=ExamForm";
            // Response.Redirect(url, false);

            // DataTable result = dl.ViewStudentRegDetails(studentId, categoryType);
        }
        catch (Exception ex)
        {

            throw ex;
        }


    }
    public void Binddropdown()
    {
        DataTable dtfaculty = dl.getFacultyfordropdown();
        if (dtfaculty.Rows.Count > 0)
        {
            ddlFaculty.DataSource = dtfaculty;
            ddlFaculty.DataTextField = "FacultyName";
            ddlFaculty.DataValueField = "Pk_FacultyId";
            ddlFaculty.DataBind();
            ddlFaculty.Items.Insert(0, new ListItem("Select Faculty", "0"));
        }
        else
        {
            ddlFaculty.Items.Clear();
            ddlFaculty.Items.Insert(0, new ListItem("Select Faculty", "0"));
        }
        DataTable dtExamcat = dl.getExamCatfordropdown();
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

        ddlExamcat.Items.Insert(0, new ListItem("Select Exam Category", "0"));
    }

    protected void btnViewRecord_Click(object sender, EventArgs e)
    {
   
        string CollegeId = "";
        if (Session["CollegeName"].ToString() == "Admin")
        {
            DataTable dt = dl.getcollegeidbasedonCollegecode(txt_CollegeName.Text);

            if (dt.Rows.Count > 0)
            {
                CollegeId = dt.Rows[0]["Pk_CollegeId"].ToString();

            }

        }
        else
        {
            CollegeId = hfCollegeId.Value;
        }


        getcollegewiseseatsummary();
        //string RegistrationType = Request.Form["regType"];
        //string CategoryType = "Regular";

        int facultyId = Convert.ToInt32(ddlFaculty.SelectedValue);
        int ExamId = Convert.ToInt32(ddlExamcat.SelectedValue);
        string StudentName = txtStudentName.Text.Trim();
        //string CategoryName = ddl_category.SelectedValue;

        DataTable result = dl.GetExamStudentRegiListData(Convert.ToInt32(CollegeId), facultyId, ExamId, StudentName);
        //DataTable result = dl.GetExamStudentRegiListData(Convert.ToInt32(CollegeId), facultyId, ExamId, RegistrationType, StudentName);
        bool hasRecords = result != null && result.Rows.Count > 0;
        pnlNoRecords.Visible = !hasRecords;
        pnlStudentTable.Visible = hasRecords;

        rptStudentList.DataSource = hasRecords ? result : null;
        rptStudentList.DataBind();

        //string script = string.Format(@"
        //<script type='text/javascript'>
        //    window.onload = function() {{
        //        document.getElementById('{0}').checked = true;
        //        handleRegTypeChange();
        //    }};
        //</script>", RegistrationType);

        //ClientScript.RegisterStartupScript(this.GetType(), "SetRadios", script);
   

    }
    protected void rptStudentList_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Button btnRegister = (Button)e.Item.FindControl("btnRegister");
            Button btnView = (Button)e.Item.FindControl("btnView");
            HiddenField hfExamFeeSubmit = (HiddenField)e.Item.FindControl("hfExamFeeSubmit");
            HiddenField hfExamFormSubmit = (HiddenField)e.Item.FindControl("hfExamFormSubmit");
            Label lblStatus = (Label)e.Item.FindControl("lblStatus");

            //string registrationMode = Request.Form["regType"];

            bool examFeeSubmit = false;
            bool examFormSubmit = false;
            bool.TryParse(hfExamFeeSubmit.Value, out examFeeSubmit);
            bool.TryParse(hfExamFormSubmit.Value, out examFormSubmit);

            // Status logic
            if (examFeeSubmit && examFormSubmit)
            {
                btnRegister.Visible = false;
                lblStatus.Text = "Submit";
                lblStatus.CssClass = "badge badge-success";
            }
            else if (examFeeSubmit && !examFormSubmit)
            {
                btnRegister.Visible = true;
                lblStatus.Text = "Pending";
                lblStatus.CssClass = "badge badge-warning";
                btnView.Visible = (examFeeSubmit && examFormSubmit);
            }
            //else
            //{
            //    lblStatus.Text = "Pending";
            //    lblStatus.CssClass = "badge badge-warning";
            //    btnRegister.Visible = false;
            //    btnView.Visible = false;
            //}

            // Edit/View logic based on registrationMode
            //if (registrationMode == "Regular" || registrationMode == "Private")
            //{
            //    btnRegister.Visible = true;
            //    btnView.Visible = (examFeeSubmit && examFormSubmit);
            //}
            //else if (registrationMode == "Private")
            //{
            //    btnRegister.Visible = false;
            //    btnView.Visible = (examFeeSubmit && examFormSubmit);
            //}
            //else
            //{
            //    btnRegister.Visible = false;
            //    btnView.Visible = false;
            //}
        }
    }



    protected void btnEdit_Click(object sender, EventArgs e)
    {
       
        Button btnEdit = (Button)sender;
        RepeaterItem item = (RepeaterItem)btnEdit.NamingContainer;
        HiddenField hfExamTypeid = (HiddenField)item.FindControl("hfExamTypeid");
        string examTypeId = hfExamTypeid != null ? hfExamTypeid.Value : "";

        string studentId = btnEdit.CommandArgument;
        //string registrationType = Request.Form["regType"];

        string url = "StudentExamRegForm.aspx?studentId=" + Server.UrlEncode(studentId) + "&examTypeId=" + Server.UrlEncode(examTypeId);
        //string url = "StudentExamRegForm.aspx?studentId=" + Server.UrlEncode(studentId) + "&registrationType=" + Server.UrlEncode(registrationType) + "&examTypeId=" + Server.UrlEncode(examTypeId);

        Response.Redirect(url, false);
    }




    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        string studentId = ((Button)sender).CommandArgument;

    }
}