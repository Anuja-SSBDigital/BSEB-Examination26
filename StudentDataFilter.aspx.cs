using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class StudentDataFilter : System.Web.UI.Page
{
    DBHelper dl = new DBHelper();

    protected void Page_Load(object sender, EventArgs e)
    {
        BindFacultydropdown();

    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {

    }

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
            //DataTable dtExamcat = dl.getExamCatfordropdown();
            //var filtered = dtExamcat.AsEnumerable().Where(row => row.Field<int>("Pk_ExamTypeId") != 5);

            //if (filtered.Any())
            //{
            //    ddlExamcat.DataSource = filtered.CopyToDataTable();
            //    ddlExamcat.DataTextField = "ExamTypeName";
            //    ddlExamcat.DataValueField = "Pk_ExamTypeId";
            //    ddlExamcat.DataBind();
            //}
            //else
            //{
            //    ddlExamcat.Items.Clear();
            //}

            //ddlExamcat.Items.Insert(0, new ListItem("Select Exam Category", "0"));
        }
        catch (Exception ex)
        {
            // Log the exception
            Console.WriteLine("Error in BindFacultydropdown: " + ex.Message);
            throw ex;
        }
    }


    protected void btnGetStudentDummyExamData(object sender, EventArgs e)
    {
        try
        {
            string facultyId = ddlFaculty.SelectedValue;
            string Rollcode = txtrollcode.Text;
            string Rollnumber = txtrollNumber.Text;
            int DisCode = Convert.ToInt32(txtdiscode.Text);





            //DataTable result = dl.GetStudentDummyadmitData(CollegeId, facultyId, ExamId);
            DataTable result = dl.GetStudentTheoryDummyadmitDataoutside(facultyId, Rollcode, Rollnumber, DisCode);
            if (result != null && result.Rows.Count > 0)
            {
                rptStudents.DataSource = result;
                rptStudents.DataBind();
                pnlNoRecords.Visible = false;
                pnlStudentTable.Visible = true;
                btnDownloadPDF.Visible = true;
                pnlPager.Visible = true;
                searchInputDIV.Visible = true;
            }
            else
            {
                rptStudents.DataSource = null;
                rptStudents.DataBind();
                pnlStudentTable.Visible = false;
                pnlNoRecords.Visible = true;
                btnDownloadPDF.Visible = false;
                pnlPager.Visible = false;
                searchInputDIV.Visible = false;
            }

            chkSelectAll.Checked = false;

        }
        catch (Exception ex)
        {

            Console.WriteLine("Error in btnGetStudentDummyRegData: " + ex.Message);
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

    protected void btnDownloadPDF_Click(object sender, EventArgs e)
    {
        // Re-bind the Repeater to restore its items.
        btnGetStudentDummyExamData(null, null);

        string selectedIds = hfSelectedIds.Value;
        if (string.IsNullOrEmpty(selectedIds))
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                "swal({ title: 'Failed', text: 'Please select at least one student to download PDF', icon: 'error', button: 'Retry' });", true);
            return;
        }

        string[] ids = selectedIds.Split(',');
        List<string> selectedStudentData = new List<string>();

        foreach (RepeaterItem item in rptStudents.Items)
        {
            if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField hfStudentID = (HiddenField)item.FindControl("hfStudentID");
                HiddenField hfCollege = (HiddenField)item.FindControl("hfCollege");
                HiddenField hfFaculty = (HiddenField)item.FindControl("hfFaculty");
                HiddenField hfExamTypeId = (HiddenField)item.FindControl("hfexamtypid");
                string examTypeId = hfExamTypeId.Value.Trim();
                if (hfStudentID != null && hfCollege != null && hfFaculty != null && hfExamTypeId != null)
                {
                    string studentid = hfStudentID.Value;
                    string rawCollegeId = hfCollege.Value;
                    string faculty = hfFaculty.Value;

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
                            string combinedData = string.Format("{0}|{1}|{2}|{3}", studentid, CollegeId, faculty, examTypeId);
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
            Response.Redirect("TheoryAdmitCertificate.aspx?studentData=" + encodedStudentData);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                "swal({ title: 'Failed', text: 'Please select at least one student to download PDF', icon: 'error', button: 'Retry' });", true);
        }
    }


}