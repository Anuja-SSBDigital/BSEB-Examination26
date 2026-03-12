<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StudentDataFilter.aspx.cs" Inherits="StudentDataFilter" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
    <title>BSEB</title>
    <!-- General CSS Files -->
    <link rel="stylesheet" href="assets/css/app.min.css">
    <!-- Template CSS -->
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/components.css">
    <!-- Custom style CSS -->
    <link rel="stylesheet" href="assets/css/custom.css">
    <link rel='shortcut icon' type='image/x-icon' href='../assets/img/favicon_v1.png' />
    <link rel="stylesheet" href="../assets/bundles/datatables/datatables.min.css">
    <link rel="stylesheet" href="../assets/bundles/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
    <style>
        body {
            background: radial-gradient(circle at top left, #2c4a9c 0%, #142b5e 70%);
        }

        .container {
            max-width: 1400px !important;
        }

        .card {
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        #table-1 td .btn {
            margin-right: 5px;
            margin-bottom: 5px;
        }

        .table th {
            white-space: nowrap;
        }

        .action-btns .btn {
            margin-bottom: 4px;
        }

        .pagination {
            text-align: center;
            margin-top: 15px;
        }

            .pagination a, .pagination span {
                display: inline-block;
                padding: 8px 16px;
                text-decoration: none;
                color: black;
                border: 1px solid #ddd;
                margin: 0 4px;
            }

                .pagination a.active {
                    background-color: #4CAF50;
                    color: white;
                    border: 1px solid #4CAF50;
                }

                .pagination a:hover:not(.active) {
                    background-color: #ddd;
                }
    </style>


</head>

<body>
    <div class="loader"></div>
    <form id="form1" runat="server">

        <div id="app">
            <section class="section">
                <div class="container mt-5">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card card-primary">
                                <div class="card-header">
                                    <h4>Search File Upload Details</h4>
                                </div>
                                <div class="card-body">

                                    <div class="row" runat="server" id="div_search">

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label for="rollNumber" class="form-label">Roll code:</label>

                                                <asp:TextBox ID="txtrollcode" runat="server" class="form-control" TextMode="Number" />
                                                <span id="txtrollcodeErr" style="display: none; color: red;">Please Enter Roll Code</span>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label for="rollNumber" class="form-label">Roll Number:</label>

                                                <asp:TextBox ID="txtrollNumber" runat="server" class="form-control" TextMode="Number" />
                                                <span id="txtrollNumberErr" style="display: none; color: red;">Please Enter Roll Number</span>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Faculty<span class="text-danger">*</span></label>
                                                <asp:DropDownList ID="ddlFaculty" runat="server" CssClass="form-control select2">
                                                </asp:DropDownList>
                                                <span id="facultyError" class="text-danger" style="display: none;">Please select a Faculty.</span>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label for="rollNumber" class="form-label">Distric Code</label>

                                                <asp:TextBox ID="txtdiscode" runat="server" class="form-control" TextMode="Number" />
                                                <span id="txtrolldisErr" style="display: none; color: red;">Please Enter code</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div class="card-footer text-end">
                                    <%-- <asp:Button runat="server" ID="btnsearch" OnClick="btn_Search_Click" CssClass="btn btn-primary" Text="Search" />--%>

                                    <asp:Button runat="server" ID="btnsearch" OnClick="btnGetStudentDummyExamData" OnClientClick="return validateSearch();" CssClass="btn btn-primary" Text="Search" />


                                    <asp:Label ID="lblMessage" runat="server" CssClass="text-info d-block mb-2"></asp:Label>

                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mt-3" runat="server" id="Agency_detailes" >

                                <div class="text-right mt-3">
                                    <asp:Button ID="btnDownloadPDF" runat="server" Text="Download PDF" CssClass="btn btn-success" OnClick="btnDownloadPDF_Click"  />
                                </div>
                                <hr />
                                <!-- 🔍 Search Box -->
                                <div class="form-group mt-3 text-right" id="searchInputDIV" runat="server" >
                                    <input type="text" id="searchInput" class="form-control" placeholder="Search by RegistrationNo,Student,Father,Mother,Gender" style="width: 300px; display: inline-block;" onkeyup="filterAndPaginate();" />
                                </div>
                                <div class="table-responsive">
                                    <asp:Panel ID="pnlStudentTable" runat="server" >
                                        <table class="table table-hover table-bordered dataTable" id="dataTable">
                                            <thead>
                                                <tr>
                                                    <th class="repeater-checkbox">
                                                        <asp:HiddenField ID="hfSelectedIds" runat="server" />
                                                        <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="false" />
                                                        Select All
                                                    </th>
                                                    <th>Registration No</th>
                                                    <th>Roll No</th>
                                                    <th>Student Name</th>
                                                    <th>Father Name</th>
                                                    <th>Mother Name</th>
                                                    <%--<th>Faculty</th>--%>
                                                    <th>Gender</th>
                                                </tr>
                                            </thead>
                                            <tbody id="tableBody">
                                                <asp:Repeater runat="server" ID="rptStudents"  >
                                                    <ItemTemplate>
                                                        <tr data-visible="true">
                                                            <td class="repeater-checkbox">
                                                                <asp:CheckBox ID="chkRowSelect" runat="server" AutoPostBack="false" OnClientClick="updateSelectAllState();" />
                                                                <asp:HiddenField ID="hfStudentID" runat="server" Value='<%# Eval("StudentID") %>' />
                                                                <asp:HiddenField ID="hfCollege" runat="server" Value='<%# Eval("CollegeId") %>' />
                                                                <asp:HiddenField ID="hfFaculty" runat="server" Value='<%# Eval("FacultyId") %>' />
                                                                <asp:HiddenField ID="hfexamtypid" runat="server" Value='<%# Eval("ExamTypeId") %>' />
                                                            </td>
                                                            <td class="repeater-col"><%# Eval("RegistrationNo") %></td>
                                                            <td class="repeater-col"><%# Eval("RollNumber") %></td>
                                                            <td class="repeater-col"><%# Eval("StudentName") %></td>
                                                            <td class="repeater-col"><%# Eval("FatherName") %></td>
                                                            <td class="repeater-col"><%# Eval("MotherName") %></td>
                                                            <%--<td class="repeater-col">
                                     <%# Eval("Faculty") %>
                                     <asp:HiddenField ID="hfFaculty" runat="server" Value='<%# Eval("FacultyId") %>' />
                                       <asp:HiddenField ID="hfexamtypid" runat="server" Value='<%# Eval("ExamTypeId") %>' />
                                 </td>--%>
                                                            <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("FacultyId") %>' />
                                                            <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Eval("ExamTypeId") %>' />
                                                            <td class="repeater-col"><%# Eval("GenderName") %></td>
                                                            <%-- <td class="repeater-col"><%# Eval("Dob", "{0:yyyy-MM-dd}") %></td>--%>
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


            </section>
        </div>
    </form>
    <script>

        var currentPage = 1;
        var rowsPerPage = 25;

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



        function attachRowHandlers() {
            document.querySelectorAll("#dataTable tbody input[type=checkbox]").forEach(function (cb) {
                cb.removeEventListener('change', updateSelectAllState);
                cb.addEventListener('change', updateSelectAllState);
            });
        }

        function setupSelectAll() {
            var master = document.getElementById('<%= chkSelectAll.ClientID %>');
            if (!master) return;

            master.addEventListener('change', function () {
                var checked = this.checked;

                // ✅ Only select rows visible on current page
                document.querySelectorAll("#dataTable tbody tr").forEach(function (row) {
                    if (row.style.display !== "none") {
                        var cb = row.querySelector("input[type=checkbox]");
                        if (cb) cb.checked = checked;
                    }
                });
                updateSelectAllState();
            });

            attachRowHandlers();
            updateSelectAllState();
        }

        function updateSelectAllState() {
            var master = document.getElementById('<%= chkSelectAll.ClientID %>');
            // ✅ Only check visible rows (current page)
            var checkboxes = document.querySelectorAll('#dataTable tbody tr[data-visible="true"]');
            var visibleCheckboxes = Array.from(checkboxes).filter(function (row) {
                return row.style.display !== "none";
            }).map(function (row) {
                return row.querySelector("input[type=checkbox]");
            });

            var total = visibleCheckboxes.length;
            var checkedCount = visibleCheckboxes.filter(cb => cb && cb.checked).length;

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
                var RegistrationNo = row.cells[1].textContent.toLowerCase();
                var studentName = row.cells[2].textContent.toLowerCase();
                var fatherName = row.cells[3].textContent.toLowerCase();
                var motherName = row.cells[4].textContent.toLowerCase();
                var gender = row.cells[5].textContent.toLowerCase();

                var match = RegistrationNo.includes(searchText) ||
                    studentName.includes(searchText) ||
                    fatherName.includes(searchText) ||
                    motherName.includes(searchText) ||
                    gender.includes(searchText);

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

            // === Prev button ===
            var prev = document.createElement('a');
            prev.textContent = 'Prev';
            prev.href = 'javascript:void(0);';
            if (currentPage === 1) prev.classList.add('disabled');
            prev.addEventListener('click', function () {
                if (currentPage > 1) {
                    currentPage--;
                    paginateFilteredTable();
                }
            });
            container.appendChild(prev);

            // === Page numbers with ellipses ===
            var maxVisible = 1; // how many page links to show at once
            var startPage = Math.max(1, currentPage - Math.floor(maxVisible / 2));
            var endPage = Math.min(totalPages, startPage + maxVisible - 1);

            if (startPage > 1) {
                addPageLink(container, 1);
                if (startPage > 2) addDots(container);
            }

            for (let i = startPage; i <= endPage; i++) {
                addPageLink(container, i, i === currentPage);
            }

            if (endPage < totalPages) {
                if (endPage < totalPages - 1) addDots(container);
                addPageLink(container, totalPages);
            }

            // === Next button ===
            var next = document.createElement('a');
            next.textContent = 'Next';
            next.href = 'javascript:void(0);';
            if (currentPage === totalPages) next.classList.add('disabled');
            next.addEventListener('click', function () {
                if (currentPage < totalPages) {
                    currentPage++;
                    paginateFilteredTable();
                }
            });
            container.appendChild(next);
        }

        function addPageLink(container, pageNum, isActive = false) {
            var link = document.createElement('a');
            link.textContent = pageNum;
            link.href = 'javascript:void(0);';
            if (isActive) link.classList.add('active');
            link.addEventListener('click', function () {
                currentPage = pageNum;
                paginateFilteredTable();
            });
            container.appendChild(link);
        }

        function addDots(container) {
            var span = document.createElement('span');
            span.textContent = '...';
            container.appendChild(span);
        }


    </script>
    <!-- General JS Scripts -->
    <script src="assets/js/app.min.js"></script>
    <!-- JS Libraies -->
    <!-- Page Specific JS File -->
    <!-- Template JS File -->
    <script src="assets/js/scripts.js"></script>
    <!-- Custom JS File -->
    <script src="assets/js/custom.js"></script>
    <script src="../assets/bundles/datatables/datatables.min.js"></script>
    <script src="../assets/bundles/datatables/DataTables-1.10.16/js/dataTables.bootstrap4.min.js"></script>
    <script src="../assets/bundles/jquery-ui/jquery-ui.min.js"></script>
    <script src="../assets/js/page/datatables.js"></script>
</html>
