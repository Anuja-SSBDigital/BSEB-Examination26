<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PaymentSummary.aspx.cs" Inherits="PaymentSummary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        /* ✅ Make header and body tables align perfectly */
        .summary-table {
            table-layout: fixed;
            width: 100%;
            border-collapse: collapse;

        }

            .summary-table th,
            .summary-table td {
                text-align: center;
                                border: 1px solid #000 !important;

                vertical-align: middle;
                white-space: nowrap;
                padding: 8px;
                border: 1px solid #dee2e6;
            }

               

        /* ✅ Sticky header when scrolling */
        .faculty-header {
            position: sticky;
            top: 0;
            z-index: 10;
            background: #f8f9fa;
            font-weight: bold;
        }

        /* ✅ Section header row (Science, Arts, Commerce) */
        .table-secondary.fw-bold td {
            background: #f1f3f5 !important;
            font-size: 1.1rem;
            font-weight: bold;
            text-align: center;
            padding-left: 12px;
            color: #333;
        }

        /* ✅ Optional: category theme colors */
        .science-row td {
            background-color: #e7f3ff !important;
        }

        .arts-row td {
            background-color: #eaf7ea !important;
        }

        .commerce-row td {
            background-color: #fff9e6 !important;
        }

        /* ✅ Card styling */
        

       
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">





    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4>Exam Form Submission Summary</h4>
                </div>

                <div class="card-body">
                    <div class="table-responsive">

                        <!-- ✅ Common Header Table -->
                        <table class="table table-bordered summary-table mb-0" >
                            <thead class="faculty-header sticky-top bg-light">
                                <tr>
                                    <th>Faculty / Exam Type</th>
                                    <th>Fee Submitted</th>
                                    <th>Form Submitted</th>
                                    <th>Form Not Submitted</th>
                                </tr>
                            </thead>
                        </table>

                        <!-- ✅ Science Table -->
                        <table class="table table-bordered summary-table mt-2">
                            <tbody>
                                <tr class="table-secondary fw-bold">
                                    <td colspan="4">Science</td>
                                </tr>
                                <tr>
                                    <td>Regular</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Ex Regular</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Compartment</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Improvement</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Qualifying</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- ✅ Arts Table -->
                        <table class="table table-bordered summary-table mb-4">
                            <tbody>
                                <tr class="table-secondary fw-bold">
                                    <td colspan="4">Arts</td>
                                </tr>
                                <tr>
                                    <td>Regular</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Ex Regular</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Compartment</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Improvement</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Qualifying</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- ✅ Commerce Table -->
                        <table class="table table-bordered summary-table">
                            <tbody>
                                <tr class="table-secondary fw-bold">
                                    <td colspan="4">Commerce</td>
                                </tr>
                                <tr>
                                    <td>Regular</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Ex Regular</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Compartment</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Improvement</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                                <tr>
                                    <td>Qualifying</td>
                                    <td>--</td>
                                    <td>--</td>
                                    <td>--</td>
                                </tr>
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
        </div>
    </div>


</asp:Content>

