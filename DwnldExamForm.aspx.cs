using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DwnldExamForm : System.Web.UI.Page
{
    DBHelper dl = new DBHelper();

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
                }


                Binddropdown();
                pnlNoRecords.Visible = false;
                pnlStudentTable.Visible = false;
                btnDownloadPDF.Visible = false;
            }
            else
            {
                Response.Redirect("Login.aspx");
            }

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

        //DataTable dtExamcat = dl.getExamCatfordropdown();


        //DataRow[] filteredRows = dtExamcat.Select("Pk_ExamTypeId = 1 OR Pk_ExamTypeId = 5");


        //DataTable filteredDt = dtExamcat.Clone(); 
        //foreach (DataRow row in filteredRows)
        //{
        //    filteredDt.ImportRow(row);
        //}

        //if (filteredDt.Rows.Count > 0)
        //{
        //    ddlExamcat.DataSource = filteredDt;
        //    ddlExamcat.DataTextField = "ExamTypeName";
        //    ddlExamcat.DataValueField = "Pk_ExamTypeId";
        //    ddlExamcat.DataBind();
        //    ddlExamcat.Items.Insert(0, new ListItem("Select Exam Category", "0"));
        //}
        //else
        //{
        //    ddlExamcat.Items.Clear();
        //    ddlExamcat.Items.Insert(0, new ListItem("Select Exam Category", "0"));
        //}

    }

    protected void btnGetExamStudentData(object sender, EventArgs e)
    {

        try
        {

            int facultyId = Convert.ToInt32(ddlFaculty.SelectedValue);
            //int ExamId = Convert.ToInt32(ddlExamcat.SelectedValue);
            string CategoryName = ddl_category.SelectedValue;
            string CollegeNameAndCode = txt_CollegeName.Text.Trim();

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

            string StudentName = txtStudentName.Text.Trim();

            // DataTable result = dl.getExamDwnldStudentData(CollegeId, CollegeCode, StudentName, facultyId, 3, "");
            DataTable result = dl.getExamDwnldStudentData(CollegeId, StudentName, facultyId, 0, CategoryName, "");
            //DataTable result = dl.getExamDwnldStudentData(CollegeId, CollegeCode, StudentName, facultyId,0, CategoryName, "");
            if (result != null && result.Rows.Count > 0)
            {
                rptStudents.DataSource = result;
                rptStudents.DataBind();
                pnlNoRecords.Visible = false;
                pnlStudentTable.Visible = true;

                string examTypeName = result.Rows[0]["ExamTypeName"].ToString();
                Session["CollegeCode"] = result.Rows[0]["CollegeCode"].ToString();
                btnDownloadPDF.Visible = true;
                lblCollege.Text = result.Rows[0]["College"].ToString();
                SpSearchresult.Visible = true;
                pnlPager.Visible = true;
                searchInputDIV.Visible = true;
                //if (examTypeName == "REGULAR" || examTypeName == "PRIVATE")
                //{
                //    btnDownloadPDF.Visible = true;
                //}
                //else
                //{
                //    btnDownloadPDF.Visible = false;
                //}
            }
            else
            {
                rptStudents.DataSource = null;
                rptStudents.DataBind();
                pnlStudentTable.Visible = false;
                pnlNoRecords.Visible = true;
                btnDownloadPDF.Visible = false;
                SpSearchresult.Visible = false;
                pnlPager.Visible = false;
                searchInputDIV.Visible = false;
            }

            chkSelectAll.Checked = false;


        }

        catch (Exception ex)
        {
            // Escape single quotes to avoid JS breakage
            string safeMessage = ex.Message.Replace("'", "\\'");
            ScriptManager.RegisterStartupScript(this, GetType(), "SearchError", @"
        swal({
            title: 'Error',
            text: 'An error occurred: " + safeMessage + @"',
            icon: 'error',
            button: 'Close'
        });
    ", true);
        }


    }

    protected void btnDownloadPDF_Click(object sender, EventArgs e)
    {
        // Re-bind the Repeater to restore its items.
        btnGetExamStudentData(null, null);

        string selectedIds = hfSelectedIds.Value;
        if (string.IsNullOrEmpty(selectedIds))
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                "swal({ title: 'Failed', text: 'Please select at least one student to download PDF', icon: 'error', button: 'Retry' });", true);
            return;
        }

        string[] ids = selectedIds.Split(',');
        if (ids.Length > 25)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                "swal({ title: 'Limit Exceeded', text: 'You can select a maximum of 25 students at a time.', icon: 'warning', button: 'OK' });", true);
            return;
        }
        List<string> selectedStudentData = new List<string>();

        foreach (RepeaterItem item in rptStudents.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField hfStudentID = (HiddenField)item.FindControl("hfStudentID");
                HiddenField hfCollege = (HiddenField)item.FindControl("hfCollege");
                HiddenField hfFaculty = (HiddenField)item.FindControl("hfFaculty");
                HiddenField hfExamTypeId = (HiddenField)item.FindControl("hfExamTypeId");

                if (hfStudentID != null && hfCollege != null && hfFaculty != null)
                {
                    string studentid = hfStudentID.Value;
                    string rawCollegeId = hfCollege.Value;
                    string faculty = hfFaculty.Value;
                    string ExamTypeId = hfExamTypeId.Value;
                    string CollegeCode = Session["CollegeCode"].ToString();

                    if (!string.IsNullOrEmpty(studentid) && ids.Contains(studentid))
                    {
                        string CollegeId = rawCollegeId;

                        if (!string.IsNullOrEmpty(rawCollegeId) && rawCollegeId.Contains("|"))
                        {
                            var parts = rawCollegeId.Split('|');
                            if (parts.Length > 1)
                                CollegeId = parts[1].Trim();
                        }

                        if (!string.IsNullOrEmpty(CollegeId) && !string.IsNullOrEmpty(faculty))
                        {
                            string combinedData = string.Format("{0}|{1}|{2}|{3}|{4}", hfStudentID.Value, CollegeId, faculty, ExamTypeId, CollegeCode);
                            selectedStudentData.Add(combinedData);
                        }
                    }
                }
            }
        }

        // Redirect after loop
        if (selectedStudentData.Count > 0)
        {
            string encodedStudentData = Server.UrlEncode(string.Join(",|", selectedStudentData));
            Response.Redirect("ExaminationForm.aspx?studentData=" + encodedStudentData);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                "swal({ title: 'Failed', text: 'Please select at least one student to download PDF', icon: 'error', button: 'Retry' });", true);
        }
    }
}