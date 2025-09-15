<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PaymentSummary.aspx.cs" Inherits="PaymentSummary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Custom Pills Styling */
        .nav-pills .nav-link {
            border-radius: 12px;
            padding: 10px 20px;
            margin: 0 5px;
            font-weight: 500;
            color: #555;
            border: 1px solid #ddd;
            transition: all 0.3s ease-in-out;
        }

            .nav-pills .nav-link.active {
                background-color: #4f46e5;
                color: #fff;
                border-color: #4f46e5;
                box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            }

            .nav-pills .nav-link:hover {
                background-color: #f0f0ff;
                border-color: #4f46e5;
                color: #4f46e5;
            }

        .tab-content {
            margin-top: 20px;
            padding: 20px;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
        }

        .card-soft-green {
            background-color: #eafee4 !important;
        }

        .card-soft-blue {
            background-color: #caddf2 !important;
        }

        .card-soft-yellow {
            background-color: #fff7d3 !important;
        }
           .card-soft-2 {
            background-color: #f8d9ff !important;
        }
        .card-title {
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: .7rem;
        }

        .stat-number {
            font-weight: bold;
            float: right;
        }

        .card {
            border-radius: 10px;
            padding: 1.1rem 1.7rem;
            min-height: 170px;
        }

        .mb-md-0 {
            margin-bottom: 0 !important;
        }

        .bg-orange {
            background-color: #fff7ec !important;
            border-left: 6px solid #E67E22;
        }
.text-2{
    color:#8f00b0;
}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  
        <!-- Pills Navigation -->
        <ul class="nav nav-pills justify-content-start mb-3" id="pills-tab" role="tablist">
          <%--  <li class="nav-item" role="presentation">
                <button class="nav-link active" id="pills-home-tab" data-bs-toggle="pill" data-bs-target="#pills-home" type="button" role="tab">
                    Registration Overview

                </button>
            </li>--%>
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" type="button" role="tab">
                    Payment Summary

                </button>
            </li>

        </ul>

        <!-- Pills Content -->
        <div class="tab-content font-18" id="pills-tabContent">
       

            <div class="tab-pane fade show active" id="pills-profile" role="tabpanel">
                <h4 class="text-center">Summary</h4>
                <div class="row">
                    <!-- Regular Students -->
                    <div class="form-group">
                        <label runat="server" id="lblcollege" visible="false">+2 School/College Code<span class="text-danger">*</span></label>
                        <asp:TextBox ID="txt_CollegeName" runat="server" CssClass="form-control"
                            placeholder="Enter CollegeCode" Visible="false">
                        </asp:TextBox>
                        <span id="CollegeNameError" class="text-danger" style="display: none;">Please Enter College.</span>

                    </div>
                    <div class="form-group mt-4 text-center">
                        <asp:Button ID="btngetsummary" runat="server" Text="Get Summary" CssClass="btn btn-primary" OnClick="btngetsummary_Click" Visible="false"  OnClientClick="return validateFaculty();"/>

                    </div>

                    <div class="col-md-6 mb-3">
                        <div class="card card-soft-green">
                            <div class="card-title text-success">OFSS Received Students</div>
                            <div>
                                <asp:Repeater ID="rptRegulareSeatMatrix" runat="server">
                                    <itemtemplate>
                                        <b><%# Eval("SummaryTitle") %></b>
                                        <span class="stat-number"><%# Eval("Ofss_Registered_Student") %></span>
                                        <br />

                                    </itemtemplate>
                                </asp:Repeater>
                            </div>

                        </div>
                    </div>
                    <!-- Private Students -->
                    <div class="col-md-6 mb-3">
                        <div class="card card-soft-blue">
                            <div class="card-title">Private Students</div>
                            <div>
                                <asp:Repeater ID="rptPrivateSeatMatrix" runat="server">
                                    <itemtemplate>
                                        <b><%# Eval("SummaryTitle") %></b>

                                        <span class="stat-number"><%# Eval("Private_Student") %></span>
                                        <br />

                                    </itemtemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mt-2">
                    <!-- Final Summary -->
                    <div class="col-md-6 mb-3 mb-md-0">
                        <div class="card card-soft-yellow">
                            <div class="card-title text-warning">Registration Fee Submission Summary</div>
                            <div>
                                <asp:Repeater ID="rptFeeSubmitted" runat="server">
                                    <itemtemplate>
                                        <b><%# Eval("SummaryTitle") %></b>

                                        <span class="stat-number"><%# Eval("TotalFeeSubmitted") %></span>
                                        <br />
                                    </itemtemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                    <!-- Application Submission Report -->
                    <div class="col-md-6">
                        <div class="card card-soft-green">
                            <div class="card-title text-success">Unsuccessful Payment Summary</div>
                            <div>
                                <asp:Repeater ID="rptUnsuccessful" runat="server">
                                    <itemtemplate>
                                        <b><%# Eval("SummaryTitle") %></b>
                                        <span class="stat-number"><%# Eval("UnsuccessfulPaymentCount") %></span>
                                        <br />

                                    </itemtemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-md-6 mb-3 mb-md-0">
                        <div class="card card-soft-2">
                            <div class="card-title text-2">Registration Form Submission Summary</div>
                            <div>
                                <asp:Repeater ID="rptFormSubmitted" runat="server">
                                    <itemtemplate>
                                        <b><%# Eval("SummaryTitle") %></b>
                                        <span class="stat-number"><%# Eval("TotalFormSubmitted") %></span>
                                        <br />

                                    </itemtemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
  

    <!-- Bootstrap JS + Icons -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <script type="text/javascript">
        (function () {
            function saveActive(target) {
                try { localStorage.setItem('activeTab', target); } catch (e) { }
                if (history.replaceState) {
                    history.replaceState(null, '', location.pathname + location.search + target);
                }
            }

            function activateTab(target) {
                if (!target) return;

                var trigger = document.querySelector('#pills-tab [data-bs-target="' + target + '"]');
                var pane = document.querySelector(target);

                if (!trigger || !pane) return;

                // Deactivate all
                document.querySelectorAll('#pills-tab .nav-link').forEach(function (el) {
                    el.classList.remove('active');
                    el.setAttribute('aria-selected', 'false');
                });
                document.querySelectorAll('#pills-tabContent .tab-pane').forEach(function (el) {
                    el.classList.remove('show', 'active');
                });

                // Activate selected (manual)
                trigger.classList.add('active');
                trigger.setAttribute('aria-selected', 'true');
                pane.classList.add('show', 'active');

                // Also use Bootstrap API if available (keeps internal state in sync)
                if (window.bootstrap && bootstrap.Tab) {
                    new bootstrap.Tab(trigger).show();
                }
            }

            function restoreAndWire() {
                // Wire saving on tab change
                document.querySelectorAll('#pills-tab [data-bs-toggle="pill"]').forEach(function (btn) {
                    // Fires when Bootstrap actually shows a tab
                    btn.addEventListener('shown.bs.tab', function (e) {
                        var t = e.target.getAttribute('data-bs-target');
                        saveActive(t);
                    });
                    // Fallback if shown.bs.tab didn't fire for any reason
                    btn.addEventListener('click', function () {
                        var t = this.getAttribute('data-bs-target');
                        saveActive(t);
                    });
                });

                // Prefer hash (e.g., #pills-profile), else localStorage
                var target =
                    (location.hash && document.querySelector(location.hash) ? location.hash : null) ||
                    localStorage.getItem('activeTab');

                if (target) activateTab(target);
            }

            // Initial load
            document.addEventListener('DOMContentLoaded', restoreAndWire);

            // Support ASP.NET UpdatePanel partial postbacks (if used)
            if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                    restoreAndWire();
                    var t = (location.hash && document.querySelector(location.hash) ? location.hash : null) ||
                        localStorage.getItem('activeTab');
                    if (t) activateTab(t);
                });
            }
        })();
    </script>

    <script type="text/javascript">
        // Attach keydown listener once page loads
        document.addEventListener("DOMContentLoaded", function () {
            var txtCollege = document.getElementById("<%= txt_CollegeName.ClientID %>");
            if (txtCollege) {
                txtCollege.addEventListener("keydown", function (event) {
                    if (event.key === "Enter") {
                        event.preventDefault(); // stop default submit
                        document.getElementById("<%= btngetsummary.ClientID %>").click();
                    }
                });
            }
        });
        function validateFaculty() {

            var collegeNameInput = document.getElementById('<%= txt_CollegeName.ClientID %>');
            var collegeNameErrorSpan = document.getElementById('CollegeNameError');
            if (collegeNameInput.value.trim() === "") {
                collegeNameErrorSpan.style.display = "inline";
                collegeNameInput.classList.add("is-invalid");
                collegeNameInput.focus();
                return false;
            } else {
                collegeNameErrorSpan.style.display = "none";
                collegeNameInput.classList.remove("is-invalid");
            }

           
        }
       <%-- function validateCollege()
        {

            var Panel1collegeNameInput = document.getElementById('<%= txt_Panel1CollegeName.ClientID %>');
            var Panel1collegeNameErrorSpan = document.getElementById('Panel1CollegeNameError');
            if (Panel1collegeNameInput.value.trim() === "") {
                Panel1collegeNameErrorSpan.style.display = "inline";
                Panel1collegeNameInput.classList.add("is-invalid");
                Panel1collegeNameInput.focus();
                return false;
            } else {
                Panel1collegeNameErrorSpan.style.display = "none";
                Panel1collegeNameInput.classList.remove("is-invalid");
            }
        }--%>
    </script>



</asp:Content>

