<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeAttendance.aspx.cs" Inherits="EmployeeAttendanceModule.EmployeeAttendance" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Attendance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .report-container {
            margin-top: 20px;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container mt-4">
            <h2 class="mb-3">Employee Attendance Module</h2>
            
            <!-- Input Form -->
            <div class="card mb-4">
                <div class="card-header">Attendance Entry</div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-2"><asp:Label runat="server" Text="Employee ID" CssClass="form-label"/></div>
                        <div class="col-md-4"><asp:TextBox ID="txtEmployeeID" runat="server" CssClass="form-control" /></div>
                        <div class="col-md-2"><asp:Label runat="server" Text="Employee Name" CssClass="form-label"/></div>
                        <div class="col-md-4"><asp:TextBox ID="txtEmployeeName" runat="server" CssClass="form-control" /></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-2"><asp:Label runat="server" Text="Date (yyyy-MM-dd)" CssClass="form-label"/></div>
                        <div class="col-md-4"><asp:TextBox ID="txtDate" runat="server" CssClass="form-control" TextMode="Date" /></div>
                        <div class="col-md-2"><asp:Label runat="server" Text="Time In (HH:mm)" CssClass="form-label"/></div>
                        <div class="col-md-4"><asp:TextBox ID="txtTimeIn" runat="server" CssClass="form-control" TextMode="Time" /></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-2"><asp:Label runat="server" Text="Time Out (HH:mm)" CssClass="form-label"/></div>
                        <div class="col-md-4"><asp:TextBox ID="txtTimeOut" runat="server" CssClass="form-control" TextMode="Time" /></div>
                        <div class="col-md-2"><asp:Label runat="server" Text="Remarks" CssClass="form-label"/></div>
                        <div class="col-md-4"><asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" /></div>
                    </div>
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-success" OnClick="btnSave_Click" />
                    <asp:HiddenField ID="hfSelectedIndex" runat="server" />
                </div>
            </div>

            <!-- Attendance Grid -->
            <div class="card mb-4">
                <div class="card-header">Attendance Records</div>
                <div class="card-body">
                    <asp:GridView ID="GridView1" runat="server" CssClass="table table-bordered" AutoGenerateColumns="False" OnRowCommand="GridView1_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="Id" HeaderText="ID" />
                            <asp:BoundField DataField="EmployeeID" HeaderText="Employee ID" />
                            <asp:BoundField DataField="EmployeeName" HeaderText="Employee Name" />
                            <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="TimeIn" HeaderText="Time In" />
                            <asp:BoundField DataField="TimeOut" HeaderText="Time Out" />
                            <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:Button runat="server" Text="Edit" CommandName="EditRow" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-primary btn-sm" />
                                    <asp:Button runat="server" Text="Delete" CommandName="DeleteRow" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-danger btn-sm" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- Report Section -->
            <div class="card">
                <div class="card-header">Generate Report</div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-2"><asp:Label runat="server" Text="From Date" CssClass="form-label"/></div>
                        <div class="col-md-4"><asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date" /></div>
                        <div class="col-md-2"><asp:Label runat="server" Text="To Date" CssClass="form-label"/></div>
                        <div class="col-md-4"><asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date" /></div>
                    </div>
                    <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report" CssClass="btn btn-info" OnClick="btnGenerateReport_Click" />
                    
                    <div class="report-container mt-3">
                        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="500px" 
                            ProcessingMode="Local" Visible="false" AsyncRendering="false">
                        </rsweb:ReportViewer>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>