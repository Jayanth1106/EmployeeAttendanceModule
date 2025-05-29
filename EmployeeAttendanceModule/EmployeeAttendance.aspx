<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeAttendance.aspx.cs" Inherits="EmployeeAttendanceModule.EmployeeAttendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Attendance</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9fafb;
            margin: 20px;
            color: #333;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-weight: 600;
            font-size: 24px;
        }

        label {
            display: inline-block;
            width: 120px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #34495e;
        }

        input[type="text"],
        input[type="date"],
        textarea,
        .aspNetTextBox {
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 7px 10px;
            width: 250px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="date"]:focus,
        textarea:focus {
            outline: none;
            border-color: #2980b9;
            box-shadow: 0 0 5px rgba(41, 128, 185, 0.5);
        }

        textarea {
            resize: vertical;
            font-family: inherit;
        }

        .aspNetButton {
            background-color: #2980b9;
            color: white;
            border: none;
            padding: 8px 16px;
            margin: 5px 5px 5px 0;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: background-color 0.3s ease;
        }

        .aspNetButton:hover {
            background-color: #1c5980;
        }

        #<%= lblMessage.ClientID %> {
            font-weight: 600;
            margin-bottom: 10px;
        }

        /* GridView Styling */
        #<%= gvAttendance.ClientID %> {
            border-collapse: collapse;
            width: 100%;
            max-width: 850px;
            background-color: white;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            font-size: 14px;
        }

        #<%= gvAttendance.ClientID %> th, #<%= gvAttendance.ClientID %> td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        #<%= gvAttendance.ClientID %> th {
            background-color: #2980b9;
            color: white;
            font-weight: 700;
        }

        #<%= gvAttendance.ClientID %> tr:nth-child(even) {
            background-color: #f2f6fa;
        }

        #<%= gvAttendance.ClientID %> tr:hover {
            background-color: #dbe9f9;
        }

        /* LinkButtons inside GridView */
        a {
            color: #2980b9;
            text-decoration: none;
            font-weight: 600;
        }

        a:hover {
            text-decoration: underline;
            color: #1c5980;
        }

        /* Form container */
        div {
            max-width: 850px;
            background: white;
            padding: 20px 30px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2><asp:Label ID="lblFormTitle" runat="server" Text="Add New Attendance Record"></asp:Label></h2>

            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" Visible="false"></asp:Label><br />

            <asp:Label Text="Employee ID:" AssociatedControlID="txtEmployeeID" runat="server" />
            <asp:TextBox ID="txtEmployeeID" runat="server" CssClass="aspNetTextBox" /><br />

            <asp:Label Text="Employee Name:" AssociatedControlID="txtEmployeeName" runat="server" />
            <asp:TextBox ID="txtEmployeeName" runat="server" CssClass="aspNetTextBox" /><br />

            <asp:Label Text="Date:" AssociatedControlID="txtDate" runat="server" />
            <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="aspNetTextBox" /><br />

            <asp:Label Text="Time In:" AssociatedControlID="txtTimeIn" runat="server" />
            <asp:TextBox ID="txtTimeIn" runat="server" Placeholder="HH:mm" CssClass="aspNetTextBox" /><br />

            <asp:Label Text="Time Out:" AssociatedControlID="txtTimeOut" runat="server" />
            <asp:TextBox ID="txtTimeOut" runat="server" Placeholder="HH:mm" CssClass="aspNetTextBox" /><br />

            <asp:CustomValidator ID="cvTimeOut" runat="server" ControlToValidate="txtTimeOut"
                OnServerValidate="cvTimeOut_ServerValidate" ErrorMessage="Time Out must be greater than Time In" ForeColor="Red" Display="Dynamic" /><br />

            <asp:Label Text="Remarks:" AssociatedControlID="txtRemarks" runat="server" />
            <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="3" Columns="30" CssClass="aspNetTextBox" /><br />

            <asp:HiddenField ID="hiddenAttendanceID" runat="server" />

            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="aspNetButton" />
            <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" Visible="false" CssClass="aspNetButton" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CssClass="aspNetButton" /><br /><br />

            <asp:Label Text="Search by Employee ID:" AssociatedControlID="txtSearchEmployeeID" runat="server" />
            <asp:TextBox ID="txtSearchEmployeeID" runat="server" CssClass="aspNetTextBox" />
            <asp:Label Text="Date:" AssociatedControlID="txtSearchDate" runat="server" />
            <asp:TextBox ID="txtSearchDate" runat="server" TextMode="Date" CssClass="aspNetTextBox" />
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="aspNetButton" />
            <asp:Button ID="btnShowAll" runat="server" Text="Show All" OnClick="btnShowAll_Click" CssClass="aspNetButton" /><br /><br />

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
