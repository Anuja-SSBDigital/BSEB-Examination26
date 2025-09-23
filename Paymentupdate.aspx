<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Paymentupdate.aspx.cs" Inherits="Paymentupdate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4>Payment Update</h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="form-group col-md-4">
                            <label for="paymode">Select Bank</label>
                            <asp:DropDownList runat="server" ID="ddl_paymode" CssClass="form-control form-select">
                                <asp:ListItem Value="Indian Bank">Indian Bank</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group col-md-4">
                            <label for="paymode">Start Date</label>
                            <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>

                        </div>
                        <div class="form-group col-md-4">
                            <label for="paymode">End Date</label>
                            <asp:TextBox ID="TextBox1" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>

                        </div>
                        <div class="form-group col-md-4">
                            <label for="paymode">Select Transaction ID</label>
                            <asp:DropDownList runat="server" ID="DropDownList1" CssClass="form-control form-select">
                                <asp:ListItem Value="Indian Bank">Indian Bank</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group mt-3">
                        <asp:Button runat="server" ID="btn_getdetails" CssClass="btn btn-primary mr-2" Text="GET DETAILS" />
                    </div>

                    <div class="table-responsive">
                        <asp:Panel ID="pnlStudentTable" runat="server" Visible="true">
                             <div class="col-md-12 text-lg-right">
                                <asp:Button ID="UpdateAllTransaction" runat="server" Text="Update All Transaction" CssClass="btn btn-primary mb-2" />
                            </div>
                            <table class="table table-hover table-bordered dataTable" id="dataTable">
                        <thead>
                                    <tr>
                                        <th>S. No.</th>
                                        <th>+2 School/College Code</th>
                                        <th>Transaction ID</th>
                                        <th>Student No</th>
                                        <th>Paid Amount</th>
                                       
                                        <th>Status</th>
                                        
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater runat="server" ID="rpt_getpayemnt" >
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblRowNumber" Text='<%# Container.ItemIndex + 1 %>' runat="server" /></td>
                                                <td><%# Eval("CollegeCode") %></td>
                                                <td><%# Eval("ClientTxnId") %></td>
                                                <td><%# Eval("StudentsPerTransaction") %></td>
                                                <td><%# Eval("AmountPaid") %></td>
                                               
                                                <td><%# Eval("PaymentStatus") %></td>
                                                <asp:HiddenField runat="server" ID="hf_status" Value='<%# Eval("PaymentStatus") %>' />
                                                

                                                
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Label ID="lblEntriesCount" runat="server" CssClass="mt-2 d-block text-left"></asp:Label>
                        </asp:Panel>


                    </div>


                </div>
            </div>
</asp:Content>

