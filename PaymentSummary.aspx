<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PaymentSummary.aspx.cs" Inherits="PaymentSummary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .category-row {
            background: #f1f3f5;
            font-weight: bold;
        }

        table {
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            text-align: center;
            vertical-align: middle;
        }

        .category-header {
            font-size: 1.2rem;
            font-weight: bold;
            padding: 8px;
            border-radius: 8px 8px 0 0;
        }

        .science {
            background-color: #e7f3ff;
        }

        .arts {
            background-color: #eaf7ea;
        }

        .commerce {
            background-color: #fff9e6;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    


    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4>Exam Form Submission Summary</h4>
                </div>

                <!-- ✅ Card Body -->
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="faculty-header">
                                <tr>
                                    <th>Faculty / Exam Type</th>
                                    <th>Fee Submitted</th>
                                    <th>Form Submitted</th>
                                    <th>Form Not Submitted</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Science -->
                                <tr class="category-row">
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

                                <!-- Arts -->
                                <tr class="category-row">
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

                                <!-- Commerce -->
                                <tr class="category-row">
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

