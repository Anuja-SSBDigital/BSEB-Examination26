using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class StudentRegisteredList : System.Web.UI.Page
{

    DBHelper dl = new DBHelper();

    public void BindFacultydropdown()
    {
        try
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
                ddlExamcat.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Exam Category", "0"));
            }
            else
            {
                ddlExamcat.Items.Clear();
            }

        }
        catch (Exception ex)
        {
            string safeMessage = ex.Message.Replace("'", "\\'");
            ScriptManager.RegisterStartupScript(this, GetType(), "DropdownError", @"
        swal({
            title: 'Error',
            text: 'An error occurred while binding dropdowns: " + safeMessage + @"',
            icon: 'error',
            button: 'Close'
        });
    ", true);
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
                }
                BindFacultydropdown();
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
    }

    protected void btnviewrecord_Click(object sender, EventArgs e)
    {
        try
        {
            string facultyId = ddlFaculty.SelectedValue;
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
            hfCollegeId.Value = CollegeId;
            DataTable result = dl.GetStudentExaminationListData(Convert.ToInt32(CollegeId), Convert.ToInt32(facultyId), ddlExamcat.SelectedValue);
            bool hasRecords = result != null && result.Rows.Count > 0;
            if (result != null && result.Rows.Count > 0)
            {

                pnlNoRecords.Visible = !hasRecords;
                pnlStudentTable.Visible = hasRecords;
                rptStudentList.DataSource = hasRecords ? result : null;
                rptStudentList.DataBind();
                pnlNoRecords.Visible = false;

            }
            else
            {

                pnlStudentTable.Visible = false;
                pnlNoRecords.Visible = true;




            }



        }
        catch (Exception ex)
        {

            Console.WriteLine("Error in btnviewrecord_Click: " + ex.Message);
            string safeMessage = ex.Message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
            string script = string.Format(@"
                swal({{
                    title: 'Error',
                    text: '{0}',
                    icon: 'error',
                    button: 'OK'
                }});", safeMessage);
            ScriptManager.RegisterStartupScript(this, GetType(), "ErrorGetData", script, true);
        }
    }
}