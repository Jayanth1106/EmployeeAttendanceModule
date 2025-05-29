<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeAttendance.aspx.cs" Inherits="EmployeeAttendanceModule.EmployeeAttendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Attendance</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2><asp:Label ID="lblFormTitle" runat="server" Text="Add New Attendance Record"></asp:Label></h2>

            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" Visible="false"></asp:Label><br />

            <asp:Label Text="Employee ID:" AssociatedControlID="txtEmployeeID" runat="server" />
            <asp:TextBox ID="txtEmployeeID" runat="server" /><br />

            <asp:Label Text="Employee Name:" AssociatedControlID="txtEmployeeName" runat="server" />
            <asp:TextBox ID="txtEmployeeName" runat="server" /><br />

            <asp:Label Text="Date:" AssociatedControlID="txtDate" runat="server" />
            <asp:TextBox ID="txtDate" runat="server" TextMode="Date" /><br />

            <asp:Label Text="Time In:" AssociatedControlID="txtTimeIn" runat="server" />
            <asp:TextBox ID="txtTimeIn" runat="server" Placeholder="HH:mm" /><br />

            <asp:Label Text="Time Out:" AssociatedControlID="txtTimeOut" runat="server" />
            <asp:TextBox ID="txtTimeOut" runat="server" Placeholder="HH:mm" /><br />

            <asp:CustomValidator ID="cvTimeOut" runat="server" ControlToValidate="txtTimeOut"
                OnServerValidate="cvTimeOut_ServerValidate" ErrorMessage="Time Out must be greater than Time In" ForeColor="Red" Display="Dynamic" /><br />

            <asp:Label Text="Remarks:" AssociatedControlID="txtRemarks" runat="server" />
            <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="3" Columns="30" /><br />

            <asp:HiddenField ID="hiddenAttendanceID" runat="server" />

            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" Visible="false" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" /><br /><br />

            <asp:Label Text="Search by Employee ID:" AssociatedControlID="txtSearchEmployeeID" runat="server" />
            <asp:TextBox ID="txtSearchEmployeeID" runat="server" />
            <asp:Label Text="Date:" AssociatedControlID="txtSearchDate" runat="server" />
            <asp:TextBox ID="txtSearchDate" runat="server" TextMode="Date" />
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
            <asp:Button ID="btnShowAll" runat="server" Text="Show All" OnClick="btnShowAll_Click" /><br /><br />

            <asp:GridView ID="gvAttendance" runat="server" AutoGenerateColumns="False" DataKeyNames="ID"
                OnRowCommand="gvAttendance_RowCommand" Width="800px" GridLines="Both" BorderColor="Gray" BorderStyle="Solid" BorderWidth="1px">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" ReadOnly="True" Visible="false" />
                    <asp:BoundField DataField="EmployeeID" HeaderText="Employee ID" />
                    <asp:BoundField DataField="EmployeeName" HeaderText="Employee Name" />
                    <asp:TemplateField HeaderText="Date">
                        <ItemTemplate>
                            <%# ((DateTime)Eval("AttendanceDate")).ToString("yyyy-MM-dd") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="TimeIn" HeaderText="Time In" />
                    <asp:BoundField DataField="TimeOut" HeaderText="Time Out" />
                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" 
                                CommandName="EditRecord" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                Text="Edit" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDelete" runat="server" 
                                CommandName="DeleteRecord" 
                                CommandArgument='<%# Eval("ID") %>' 
                                Text="Delete" 
                                OnClientClick="return confirm('Are you sure you want to delete this record?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>
