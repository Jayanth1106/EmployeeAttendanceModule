using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace EmployeeAttendanceModule
{
    public partial class EmployeeAttendance : System.Web.UI.Page
    {
        private const string SessionKey = "AttendanceRecords";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session[SessionKey] = new List<Attendance>();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            List<Attendance> records = Session[SessionKey] as List<Attendance>;
            int index = string.IsNullOrEmpty(hfSelectedIndex.Value) ? -1 : int.Parse(hfSelectedIndex.Value);

            Attendance record = new Attendance
            {
                Id = index == -1 ? records.Count + 1 : records[index].Id,
                EmployeeID = txtEmployeeID.Text.Trim(),
                EmployeeName = txtEmployeeName.Text.Trim(),
                Date = DateTime.Parse(txtDate.Text),
                TimeIn = txtTimeIn.Text,
                TimeOut = txtTimeOut.Text,
                Remarks = txtRemarks.Text.Trim()
            };

            if (index == -1)
            {
                records.Add(record);
            }
            else
            {
                records[index] = record;
            }

            Session[SessionKey] = records;
            hfSelectedIndex.Value = "";
            ClearForm();
            BindGrid();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            List<Attendance> records = Session[SessionKey] as List<Attendance>;

            if (e.CommandName == "EditRow")
            {
                Attendance record = records[index];
                txtEmployeeID.Text = record.EmployeeID;
                txtEmployeeName.Text = record.EmployeeName;
                txtDate.Text = record.Date.ToString("yyyy-MM-dd");
                txtTimeIn.Text = record.TimeIn;
                txtTimeOut.Text = record.TimeOut;
                txtRemarks.Text = record.Remarks;
                hfSelectedIndex.Value = index.ToString();
            }
            else if (e.CommandName == "DeleteRow")
            {
                records.RemoveAt(index);
                Session[SessionKey] = records;
                BindGrid();
            }
        }

        protected void btnGenerateReport_Click(object sender, EventArgs e)
        {
            DateTime fromDate, toDate;
            if (!DateTime.TryParse(txtFromDate.Text, out fromDate) || !DateTime.TryParse(txtToDate.Text, out toDate))
            {
                return;
            }

            List<Attendance> allRecords = Session[SessionKey] as List<Attendance>;
            List<Attendance> filtered = allRecords.FindAll(r => r.Date >= fromDate && r.Date <= toDate);

            if (filtered.Count > 0)
            {
                DataTable dt = new DataTable("Attendance");
                dt.Columns.Add("Id", typeof(int));
                dt.Columns.Add("EmployeeID", typeof(string));
                dt.Columns.Add("EmployeeName", typeof(string));
                dt.Columns.Add("Date", typeof(DateTime));
                dt.Columns.Add("TimeIn", typeof(string));
                dt.Columns.Add("TimeOut", typeof(string));
                dt.Columns.Add("Remarks", typeof(string));

                foreach (Attendance record in filtered)
                {
                    dt.Rows.Add(record.Id, record.EmployeeID, record.EmployeeName, record.Date, record.TimeIn, record.TimeOut, record.Remarks);
                }

                ReportViewer1.ProcessingMode = ProcessingMode.Local;
                ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/Report1.rdlc");
                ReportViewer1.LocalReport.DataSources.Clear();
                ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("DataSet1", dt));
                ReportViewer1.LocalReport.Refresh();
                ReportViewer1.Visible = true;
            }
            else
            {
                ReportViewer1.Visible = false;
            }
        }

        private void BindGrid()
        {
            GridView1.DataSource = Session[SessionKey] as List<Attendance>;
            GridView1.DataBind();
        }

        private void ClearForm()
        {
            txtEmployeeID.Text = "";
            txtEmployeeName.Text = "";
            txtDate.Text = "";
            txtTimeIn.Text = "";
            txtTimeOut.Text = "";
            txtRemarks.Text = "";
        }

        public class Attendance
        {
            public int Id { get; set; }
            public string EmployeeID { get; set; }
            public string EmployeeName { get; set; }
            public DateTime Date { get; set; }
            public string TimeIn { get; set; }
            public string TimeOut { get; set; }
            public string Remarks { get; set; }
        }
    }
}
