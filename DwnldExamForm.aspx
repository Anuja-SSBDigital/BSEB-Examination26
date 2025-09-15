<%@ Page Title="BSEB - Admin Dashboard | Download Registration Form" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="DwnldExamForm.aspx.cs" Inherits="DwnldExamForm" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .table-responsive {
            margin-top: 20px;
        }

        .repeater-checkbox {
            width: 30px;
            text-align: center;
        }

        .repeater-col {
            padding: 8px;
        }
         table {
            border-collapse: collapse !important; /* Ensures no double borders */
            width: 100%;
        }

            table th,
            table td {
                border: 1px solid #333 !important; /* Darker and consistent grid border */
                padding: 10px;
                font-size: 14px;
                vertical-align: middle;
            }

            table tr:nth-child(even) {
                background-color: #f9f9f9;
            }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4>Download Examination Form</h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>+2 School/College Code & Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txt_CollegeName" runat="server" CssClass="form-control"  placeholder="Enter CollegeCode" ></asp:TextBox>
                                 <span id="CollegeNameError" class="text-danger" style="display: none;">Please Enter College.</span>
                            </div>

                             <%-- <div class="form-group">
                                  <label>Exam Category <span class="text-danger">*</span></label>
                                  <asp:DropDownList ID="ddlExamcat" runat="server" CssClass="form-control select2">
                                  </asp:DropDownList>
                                  <span id="ExamCatError" class="text-danger" style="display: none;">Please select a Exam Category.</span>
                              </div>--%>
                             <div class="col-md-12" style="padding: 0px !important;">
                                 <div class="form-group">
                             <label for="category">Student Category<span class="text-danger">*</span></label>
                             <asp:DropDownList runat="server" ID="ddl_category" CssClass="form-control select2">
                                 <asp:ListItem Value="0">Select Category</asp:ListItem>
                                 <asp:ListItem Value="Regular">Regular</asp:ListItem>
                                 <asp:ListItem Value="Private">Private</asp:ListItem>
                             </asp:DropDownList>
                                      <span id="ExamCatError" class="text-danger" style="display: none;">Please select Category.</span>
                                     </div>
                                
                         </div>
                       </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Faculty Name <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="ddlFaculty" runat="server" CssClass="form-control select2">
                                </asp:DropDownList>
                                <span id="facultyError" class="text-danger" style="display: none;">Please select a Faculty.</span>
                            </div>
                            <div class="form-group">
                                <label>Student Name</label>
                                <asp:TextBox ID="txtStudentName" runat="server" CssClass="form-control" placeholder="Enter Student Name"></asp:TextBox>
                            </div>
                        </div>

                     <%--   <div class="col-md-6">
                            <div class="form-group">
                            <label>Academic Session</label>
                            <asp:DropDownList runat="server" class="form-control" ID="dr_session">
                                <asp:ListItem Selected>2024-2026</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        </div>--%>
                    </div>

                    <div class="form-group mt-4 text-center">
                        <asp:Button ID="Button1" runat="server" Text="VIEW RECORD" CssClass="btn btn-primary mr-2" OnClick="btnGetExamStudentData" OnClientClick="return validateFaculty();" />
                    </div>

                    <div class="text-right mt-3">
                        <asp:Button ID="btnDownloadPDF" runat="server" Text="Download PDF" CssClass="btn btn-success" OnClick="btnDownloadPDF_Click" Visible="false" />
                    </div>

                   <div class="text-center">
    <strong><span id="SpSearchresult" runat="server" Visible="false">Search Result For: </span><asp:Label runat="server" ID="lblCollege" ></asp:Label></strong>
</div>

<hr />

<!-- 🔍 Search Box -->
<div class="form-group mt-3 text-right" id="searchInputDIV" runat="server" Visible="false" >
    <input type="text" id="searchInput" class="form-control" placeholder="Search by Student, Father, Mother Name or DOB" style="width: 300px; display: inline-block;" onkeyup="filterAndPaginate();" />
</div>

<div class="table-responsive">
    <asp:Panel ID="pnlStudentTable" runat="server" Visible="false">
        <table class="table table-hover table-bordered dataTable" id="dataTable">
            <thead>
                <tr>
                    <th class="repeater-checkbox">
                        <asp:HiddenField ID="hfSelectedIds" runat="server" />
                        <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="false" />
                        Select All
                    </th>
                       <th>S.No.</th>
                    <th>Registration No</th>
                     <th>Student Name</th>
                     <th>Father Name</th>
                     <th>Mother Name</th>
                     <%--<th>Faculty</th>--%>
                     <th>DOB</th>
                     <th>Form Downloaded</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                <asp:Repeater runat="server" ID="rptStudents" EnableViewState="false" ClientIDMode="Static">
                    <ItemTemplate>
                        <tr data-visible="true">
                            <td class="repeater-checkbox">
                                <asp:CheckBox ID="chkRowSelect" runat="server" AutoPostBack="false" OnClientClick="updateSelectAllState();" />
                                <asp:HiddenField ID="hfStudentID" runat="server" Value='<%# Eval("StudentID") %>' />
                                <asp:HiddenField ID="hfCollege" runat="server" Value='<%# Eval("CollegeId") %>' />
                                <asp:HiddenField ID="hfFaculty" runat="server" Value='<%# Eval("FacultyId") %>' />
                            </td>

                             <td class="repeater-col"><%# Container.ItemIndex + 1 %></td>
                            <td class="repeater-col">
                                 <%# Eval("RegistrationNo") %>
                              
                                 <%-- Added here --%>
                             </td>
                             <td class="repeater-col"><%# Eval("StudentName") %></td>
                             <td class="repeater-col"><%# Eval("FatherName") %></td>
                             <td class="repeater-col"><%# Eval("MotherName") %></td>
                             <%--<td class="repeater-col">
                                 <%# Eval("Faculty") %>
                                 <asp:HiddenField ID="hfFaculty" runat="server" Value='<%# Eval("FacultyId") %>' />
                                  <asp:HiddenField ID="hfExamTypeId" runat="server" Value='<%# Eval("ExamTypeId") %>' />
                                 <%-- Added here </td>--%>
                          
                             <asp:HiddenField ID="hfExamTypeId" runat="server" Value='<%# Eval("ExamTypeId") %>' />
                             <td class="repeater-col"><%# Eval("Dob") != DBNull.Value ? string.Format("{0:dd-MM-yyyy}", Eval("Dob")) : "" %></td>
                             <td class="repeater-col">
                                 <%# Eval("FormDownloaded").ToString() == "True" || Eval("FormDownloaded").ToString().ToUpper() == "YES" ? "YES" : "NO" %>
                             </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
        <asp:Label ID="lblEntriesCount" runat="server" CssClass="mt-2 d-block text-left"></asp:Label>

    </asp:Panel>

    <asp:Panel ID="pnlNoRecords" runat="server" Visible="false" CssClass="alert alert-danger text-center mt-3">
        No student records found matching your criteria.
    </asp:Panel>
</div>

<asp:Panel ID="pnlPager" runat="server" CssClass="pagination" Visible="false">
    <div id="pagination"></div>
</asp:Panel>
                </div>
            </div>
        </div>
    </div>
  <script type="text/javascript">
      function validateFaculty() {
          var collegeNameInput = document.getElementById('<%= txt_CollegeName.ClientID %>');
        var collegeNameErrorSpan = document.getElementById('CollegeNameError');

        var facultyDropdown = document.getElementById('<%= ddlFaculty.ClientID %>');
        var facultyErrorSpan = document.getElementById('facultyError');

        var catDropdown = document.getElementById('<%= ddl_category.ClientID %>');
          var catErrorSpan = document.getElementById('ExamCatError');

          collegeNameErrorSpan.style.display = "none";
          facultyErrorSpan.style.display = "none";
          catErrorSpan.style.display = "none";

          collegeNameInput.classList.remove("is-invalid");
          facultyDropdown.classList.remove("is-invalid");
          catDropdown.classList.remove("is-invalid");

        
          if (collegeNameInput.value.trim() === "") {
              collegeNameErrorSpan.style.display = "inline";
              collegeNameInput.classList.add("is-invalid");
              collegeNameInput.focus();
              return false;
          }

        
          if (facultyDropdown.value === "0" || facultyDropdown.value === "") {
              facultyErrorSpan.style.display = "inline";
              facultyDropdown.classList.add("is-invalid");
              facultyDropdown.focus();
              return false;
          }

        
          if (catDropdown.value === "0" || catDropdown.value === "") {
              catErrorSpan.style.display = "inline";
              catDropdown.classList.add("is-invalid");
              catDropdown.focus();
              return false;
          }

      
          return true;
      }
      var currentPage = 1;
      var rowsPerPage = 10;

      document.addEventListener("DOMContentLoaded", function () {
          setupSelectAll();
          filterAndPaginate(); // Load initial table
      });

      function getSelectedIds() {
          var ids = [];
          document.querySelectorAll("#dataTable tbody tr").forEach(function (row) {
              var cb = row.querySelector("input[type=checkbox]");
              var hf = row.querySelector("input[type=hidden][id$='hfStudentID']");
              if (cb && cb.checked && hf) {
                  ids.push(hf.value);
              }
          });
          return ids;
      }

      function updateHiddenField() {
          var hiddenField = document.getElementById('<%= hfSelectedIds.ClientID %>');
          hiddenField.value = getSelectedIds().join(',');
      }

      function setupSelectAll() {
          var master = document.getElementById('<%= chkSelectAll.ClientID %>');
       if (!master) return;

       master.addEventListener('change', function () {
           var checked = this.checked;
           document.querySelectorAll("#dataTable tbody tr").forEach(function (row) {
               if (row.dataset.visible !== "false") {
                   var cb = row.querySelector("input[type=checkbox]");
                   if (cb) cb.checked = checked;
               }
           });
           updateSelectAllState();
       });

       attachRowHandlers();
       updateSelectAllState();
   }

   function attachRowHandlers() {
       document.querySelectorAll("#dataTable tbody input[type=checkbox]").forEach(function (cb) {
           cb.removeEventListener('change', updateSelectAllState);
           cb.addEventListener('change', updateSelectAllState);
       });
   }

   function updateSelectAllState() {
       var master = document.getElementById('<%= chkSelectAll.ClientID %>');
       var checkboxes = document.querySelectorAll('#dataTable tbody tr[data-visible="true"] input[type=checkbox]');
       var total = checkboxes.length;
       var checkedCount = 0;

       checkboxes.forEach(function (cb) {
           if (cb.checked) checkedCount++;
       });

       if (checkedCount === 0) {
           master.checked = false;
           master.indeterminate = false;
       } else if (checkedCount === total) {
           master.checked = true;
           master.indeterminate = false;
       } else {
           master.checked = false;
           master.indeterminate = true;
       }

       updateHiddenField();
   }

   // ====== 🔍 Filtering + Pagination ======
   function filterAndPaginate() {
       var searchText = document.getElementById("searchInput").value.toLowerCase();
       var rows = document.querySelectorAll("#dataTable tbody tr");

       rows.forEach(function (row) {
           var studentName = row.cells[1].textContent.toLowerCase();
           var fatherName = row.cells[2].textContent.toLowerCase();
           var motherName = row.cells[3].textContent.toLowerCase();
           var dob = row.cells[4].textContent.toLowerCase();

           var match = studentName.includes(searchText) ||
               fatherName.includes(searchText) ||
               motherName.includes(searchText) ||
               dob.includes(searchText);

           row.dataset.visible = match ? "true" : "false";
       });

       currentPage = 1;
       paginateFilteredTable();
   }

   function paginateFilteredTable() {
       var allRows = document.querySelectorAll("#dataTable tbody tr");
       var visibleRows = Array.from(allRows).filter(function (row) {
           return row.dataset.visible !== "false";
       });

       var totalRows = visibleRows.length;
       var totalPages = Math.ceil(totalRows / rowsPerPage) || 1;

       if (currentPage > totalPages) currentPage = totalPages;
       if (currentPage < 1) currentPage = 1;

       allRows.forEach(function (row) {
           row.style.display = "none";
       });

       var start = (currentPage - 1) * rowsPerPage;
       var end = start + rowsPerPage;

       visibleRows.slice(start, end).forEach(function (row) {
           row.style.display = "";
       });

       renderPagination(totalPages);
       attachRowHandlers();
       updateSelectAllState();
          var lblEntries = document.getElementById('<%= lblEntriesCount.ClientID %>');
          if (totalRows === 0) {
              lblEntries.innerText = "No entries found";
          } else {
              lblEntries.innerText = `Showing ${start + 1} to ${Math.min(end, totalRows)} of ${totalRows} entries`;
          }
      }

      function renderPagination(totalPages) {
          var container = document.getElementById('pagination');
          container.innerHTML = '';

          if (totalPages <= 1) return;

          var prev = document.createElement('a');
          prev.textContent = 'Prev';
          prev.href = 'javascript:void(0);';
          prev.addEventListener('click', function () {
              if (currentPage > 1) {
                  currentPage--;
                  paginateFilteredTable();
              }
          });
          container.appendChild(prev);

          for (let i = 1; i <= totalPages; i++) {
              var link = document.createElement('a');
              link.textContent = i;
              link.href = 'javascript:void(0);';
              if (i === currentPage) link.classList.add('active');
              link.addEventListener('click', (function (pageNum) {
                  return function () {
                      currentPage = pageNum;
                      paginateFilteredTable();
                  };
              })(i));
              container.appendChild(link);
          }

          var next = document.createElement('a');
          next.textContent = 'Next';
          next.href = 'javascript:void(0);';
          next.addEventListener('click', function () {
              if (currentPage < totalPages) {
                  currentPage++;
                  paginateFilteredTable();
              }
          });
          container.appendChild(next);
      }
  </script>


</asp:Content>

