using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;

namespace EmployeeAttendanceModule
{
    public partial class EmployeeAttendance : System.Web.UI.Page
    {
        private const string ViewStateKey = "AttendanceRecords";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize the ViewState list if null
                if (ViewState[ViewStateKey] == null)
                {
                    ViewState[ViewStateKey] = new List<AttendanceRecord>();
                }
                LoadGrid();
                ClearForm();
            }
        }

        private List<AttendanceRecord> AttendanceRecords
        {
            get => ViewState[ViewStateKey] as List<AttendanceRecord>;
            set => ViewState[ViewStateKey] = value;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (!DateTime.TryParse(txtDate.Text, out DateTime date))
                {
                    ShowMessage("Invalid date format.");
                    return;
                }
                if (!TimeSpan.TryParse(txtTimeIn.Text, out TimeSpan timeIn))
                {
                    ShowMessage("Invalid Time In format.");
                    return;
                }
                if (!TimeSpan.TryParse(txtTimeOut.Text, out TimeSpan timeOut))
                {
                    ShowMessage("Invalid Time Out format.");
                    return;
                }

                // Generate a new ID
                int newId = AttendanceRecords.Count > 0 ? AttendanceRecords.Max(r => r.ID) + 1 : 1;

                AttendanceRecord newRecord = new AttendanceRecord
                {
                    ID = newId,
                    EmployeeID = txtEmployeeID.Text.Trim(),
                    EmployeeName = txtEmployeeName.Text.Trim(),
                    AttendanceDate = date,
                    TimeIn = timeIn.ToString(@"hh\:mm"),
                    TimeOut = timeOut.ToString(@"hh\:mm"),
                    Remarks = txtRemarks.Text.Trim()
                };

                AttendanceRecords.Add(newRecord);

                ShowMessage("Record saved successfully.", false);
                ClearForm();
                LoadGrid();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (!int.TryParse(hiddenAttendanceID.Value, out int editId))
                {
                    ShowMessage("Invalid record ID.");
                    return;
                }
                if (!DateTime.TryParse(txtDate.Text, out DateTime date))
                {
                    ShowMessage("Invalid date format.");
                    return;
                }
                if (!TimeSpan.TryParse(txtTimeIn.Text, out TimeSpan timeIn))
                {
                    ShowMessage("Invalid Time In format.");
                    return;
                }
                if (!TimeSpan.TryParse(txtTimeOut.Text, out TimeSpan timeOut))
                {
                    ShowMessage("Invalid Time Out format.");
                    return;
                }

                var record = AttendanceRecords.FirstOrDefault(r => r.ID == editId);
                if (record == null)
                {
                    ShowMessage("Record not found.");
                    return;
                }

                record.EmployeeID = txtEmployeeID.Text.Trim();
                record.EmployeeName = txtEmployeeName.Text.Trim();
                record.AttendanceDate = date;
                record.TimeIn = timeIn.ToString(@"hh\:mm");
                record.TimeOut = timeOut.ToString(@"hh\:mm");
                record.Remarks = txtRemarks.Text.Trim();

                ShowMessage("Record updated successfully.", false);
                ClearForm();
                LoadGrid();
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string empIdSearch = txtSearchEmployeeID.Text.Trim().ToLower();
            bool hasEmpIdFilter = !string.IsNullOrEmpty(empIdSearch);

            DateTime searchDate;
            bool hasDateFilter = DateTime.TryParse(txtSearchDate.Text, out searchDate);

            var filtered = AttendanceRecords.AsEnumerable();

            if (hasEmpIdFilter)
                filtered = filtered.Where(r => r.EmployeeID.ToLower().Contains(empIdSearch));
            if (hasDateFilter)
                filtered = filtered.Where(r => r.AttendanceDate.Date == searchDate.Date);

            gvAttendance.DataSource = filtered.ToList();
            gvAttendance.DataBind();
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            LoadGrid();
        }

        private void LoadGrid()
        {
            gvAttendance.DataSource = AttendanceRecords;
            gvAttendance.DataBind();
        }

        protected void gvAttendance_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRecord")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                var record = AttendanceRecords[index];

                // Populate form with record values
                txtEmployeeID.Text = record.EmployeeID;
                txtEmployeeName.Text = record.EmployeeName;
                txtDate.Text = record.AttendanceDate.ToString("yyyy-MM-dd");
                txtTimeIn.Text = record.TimeIn;
                txtTimeOut.Text = record.TimeOut;
                txtRemarks.Text = record.Remarks;
                hiddenAttendanceID.Value = record.ID.ToString();

                // Toggle buttons & form title
                btnSave.Visible = false;
                btnUpdate.Visible = true;
                lblFormTitle.Text = "Edit Attendance Record";
                lblMessage.Visible = false;
            }
            else if (e.CommandName == "DeleteRecord")
            {
                int idToDelete = Convert.ToInt32(e.CommandArgument);
                var record = AttendanceRecords.FirstOrDefault(r => r.ID == idToDelete);
                if (record != null)
                {
                    AttendanceRecords.Remove(record);
                    LoadGrid();
                    ShowMessage("Record deleted successfully.", false);
                    ClearForm();
                }
            }
        }

        private void ClearForm()
        {
            txtEmployeeID.Text = "";
            txtEmployeeName.Text = "";
            txtDate.Text = "";
            txtTimeIn.Text = "";
            txtTimeOut.Text = "";
            txtRemarks.Text = "";
            hiddenAttendanceID.Value = "";
            btnSave.Visible = true;
            btnUpdate.Visible = false;
            lblFormTitle.Text = "Add New Attendance Record";
            lblMessage.Visible = false;
        }

        private void ShowMessage(string message, bool isError = true)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = isError ? System.Drawing.Color.Red : System.Drawing.Color.Green;
            lblMessage.Visible = true;
        }

        protected void cvTimeOut_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            if (TimeSpan.TryParse(txtTimeIn.Text, out TimeSpan timeIn) &&
                TimeSpan.TryParse(txtTimeOut.Text, out TimeSpan timeOut))
            {
                args.IsValid = timeOut > timeIn;
            }
            else
            {
                args.IsValid = false;
            }
        }
    }

    [Serializable]
    public class AttendanceRecord
    {
        public int ID { get; set; }
        public string EmployeeID { get; set; }
        public string EmployeeName { get; set; }
        public DateTime AttendanceDate { get; set; }
        public string TimeIn { get; set; }
        public string TimeOut { get; set; }
        public string Remarks { get; set; }
    }
}
