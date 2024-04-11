import React, { useState, useEffect, useRef } from 'react';
import { getLocalItem } from '~/utils/storageHelper';

import request from '~/utils/request';
import classes from './ViewReport.module.scss';

import checkPermission from '~/utils/checkPermission';
import { Backdrop, CircularProgress } from '@mui/material';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faFileExport, faFilter } from '@fortawesome/free-solid-svg-icons';
import DropdownUser from '~/components/DropdownUser/DropdownUser';
import ExcelJS from 'exceljs';
import { getCurrentDate } from '~/utils/handleDate';

function ViewReport() {
  const currentDate = getCurrentDate();

  const [loading, setLoading] = useState(false)
  const [filterActive, setFilterActive] = useState(false);
  const [fromDate, setFromDate] = useState(currentDate);
  const [toDate, setToDate] = useState(currentDate);
  const [selectedUsers, setSelectedUsers] = useState([])
  const [users, setUsers] = useState([])
  const [projects, setProjects] = useState([])
  const [members, setMembers] = useState([])
  const [roles, setRoles] = useState([])
  const [workPoints, setWorkPoints] = useState([])
  const [typeStatistic, setTypeStatistic] = useState(0)
  const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
  const headers = {
    Authorization: tokenAuth,
  };
  const [selectedFilter, setSelectedFilter] = useState(0);
  const [selectedStartEndDate, setSelectedStartEndDate] = useState(false)
  const inputStartEndDate = useRef()
  const exportToExcel = async () => {
    setLoading(true);
    //Export Projects
    if (parseInt(typeStatistic) === 0) {
      const columnWidths = [20, 25, 30, 15, 15];

      if (!projects) {
        console.error("Invalid projects data");
        setLoading(false);
        return;
      }

      const workbook = new ExcelJS.Workbook();
      const worksheet = workbook.addWorksheet('Projects Statistic Report');

      // Merge row cho header
      worksheet.mergeCells('A1:E1');
      worksheet.columns.forEach((column, colNumber) => {
        column.width = columnWidths[colNumber]; // Thiết lập độ rộng cho từng cột
      });

      const header = worksheet.getCell('A1');
      if (selectedStartEndDate) {
        header.value = `Statistical project report start/end date `
      } else {
        header.value = `Statistical project report ${fromDate + ' - ' + toDate}`
      }

      header.font = { bold: true, size: 14 };
      header.alignment = { horizontal: 'center', vertical: 'center' };
      header.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFFF' } };
      header.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } }

      // Thiết lập style cho header
      const headerRow = worksheet.addRow(["Project Name", "Project Type", "Time (YYYY-MM-DD)", "Actual Point", "Plan Point"]);
      headerRow.alignment = { horizontal: 'center', vertical: 'center' };
      headerRow.eachCell((cell, colNumber) => {
        cell.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } };
        cell.font = { bold: true, size: 14 };
        if (colNumber <= 5) {
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'f7f705' } };
        }
      });

      // // Thiết lập style cho dữ liệu
      const dataStyle = { border: { left: { style: 'thin' }, right: { style: 'thin' }, top: { style: 'thin' }, bottom: { style: 'thin' } } };

      // Đặt dữ liệu vào sheet
      projects.forEach((project) => {
        const row = worksheet.addRow([
          project.project_name,
          project.project_type,
          project.start_time + ' - ' + project.end_time,
          parseFloat(project.actual_point.toFixed(2)),
          parseFloat(project.plan_point.toFixed(2))
        ]);

        // Thiết lập style cho từng ô từ cột A đến cột G
        for (let colNumber = 1; colNumber <= 5; colNumber++) {
          const cell = row.getCell(colNumber);
          if (colNumber >= 4) {
            cell.font = { bold: true, size: 12 };
          } else {
            cell.font = { size: 12 };
          }
          cell.alignment = { horizontal: 'center', vertical: 'center', wrapText: true };
          cell.border = dataStyle.border;
        }
      });

      // Xuất Excel
      const buffer = await workbook.xlsx.writeBuffer();
      const dataBlob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });

      const url = URL.createObjectURL(dataBlob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `project_report.xlsx`;
      a.click();
    }
    //Export Members
    else if (parseInt(typeStatistic) === 1) {
      const columnWidths = [20, 30, 20, 35, 15, 15];

      if (!members) {
        console.error("Invalid members data");
        setLoading(false);
        return;
      }

      const workbook = new ExcelJS.Workbook();
      const worksheet = workbook.addWorksheet('Members Statistic Report');

      // Merge row cho header
      worksheet.mergeCells('A1:F1');
      worksheet.columns.forEach((column, colNumber) => {
        column.width = columnWidths[colNumber]; // Thiết lập độ rộng cho từng cột
      });

      const header = worksheet.getCell('A1');
      header.value = `Statistical Members ${fromDate} - ${toDate}`


      header.font = { bold: true, size: 14 };
      header.alignment = { horizontal: 'center', vertical: 'center' };
      header.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFFF' } };
      header.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } }

      // Thiết lập style cho header
      const headerRow = worksheet.addRow(["Member Name", "Projects", "Project Type", "Time (YYYY-MM-DD)", "Plan Point", "Percent (%)"]);
      headerRow.alignment = { horizontal: 'center', vertical: 'center' };
      headerRow.eachCell((cell, colNumber) => {
        cell.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } };
        cell.font = { bold: true, size: 14 };
        if (colNumber <= 6) {
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'f7f705' } };
        }
      });
      // // Thiết lập style cho dữ liệu
      const dataStyle = { border: { left: { style: 'thin' }, right: { style: 'thin' }, top: { style: 'thin' }, bottom: { style: 'thin' } } };
      let mergeCell = []
      // Đặt dữ liệu vào sheet
      members.forEach((user, userIndex) => {
        user.point_percentages.forEach((point, index) => {
          const row = worksheet.addRow([
            user.name,
            renderProjects(point.projects),
            point.project_type,
            fromDate + ' - ' + toDate,
            parseFloat(point.plan_point.toFixed(2)),
            parseFloat(point.percent.toFixed(2) * 100)
          ]);

          // Thiết lập style cho từng ô từ cột A đến cột G
          for (let colNumber = 1; colNumber <= 6; colNumber++) {
            const cell = row.getCell(colNumber);
            if (colNumber >= 5 || colNumber === 1) {
              cell.font = { bold: true, size: 12 };
            } else {
              cell.font = { size: 12 };
            }
            cell.alignment = { horizontal: 'center', vertical: 'center', wrapText: true };
            cell.border = dataStyle.border;
            if (colNumber === 1) {
              cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FABF8F' } };
            }
          }
        })
        if (userIndex === 0) {
          mergeCell.push({
            start: 3,
            end: 3 + user.point_percentages.length - 1
          }
          )
        } else {
          const s = mergeCell[mergeCell.length - 1].end + 1;
          const e = s + user.point_percentages.length - 1;
          mergeCell.push({
            start: s,
            end: e,
          })
        }

      });

      for (let i = 0; i < mergeCell.length; i++) {
        worksheet.mergeCells(`A${mergeCell[i].start}:A${mergeCell[i].end}`)
      }
      // Xuất Excel
      const buffer = await workbook.xlsx.writeBuffer();
      const dataBlob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });

      const url = URL.createObjectURL(dataBlob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `members_report.xlsx`;
      a.click();
    }
    //Export Roles
    else if (parseInt(typeStatistic) === 2) {
      const columnWidths = [20, 25, 30, 35, 25, 25];

      if (!roles) {
        console.error("Invalid roles data");
        setLoading(false);
        return;
      }

      const workbook = new ExcelJS.Workbook();
      const worksheet = workbook.addWorksheet('Roles Statistic Report');

      // Merge row cho header
      worksheet.mergeCells('A1:F1');
      worksheet.columns.forEach((column, colNumber) => {
        column.width = columnWidths[colNumber]; // Thiết lập độ rộng cho từng cột
      });

      const header = worksheet.getCell('A1');
      header.value = `Statistical Roles ${fromDate} - ${toDate}`


      header.font = { bold: true, size: 14 };
      header.alignment = { horizontal: 'center', vertical: 'center' };
      header.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFFF' } };
      header.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } }

      // Thiết lập style cho header
      const headerRow = worksheet.addRow(["Project Name", "Role", "Members", "Time (YYYY-MM-DD)", "Actual Point", "Point Performance"]);
      headerRow.alignment = { horizontal: 'center', vertical: 'center' };
      headerRow.eachCell((cell, colNumber) => {
        cell.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } };
        cell.font = { bold: true, size: 14 };
        if (colNumber <= 6) {
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'f7f705' } };
        }
      });

      // // Thiết lập style cho dữ liệu
      const dataStyle = { border: { left: { style: 'thin' }, right: { style: 'thin' }, top: { style: 'thin' }, bottom: { style: 'thin' } } };
      let mergeCell = []
      // Đặt dữ liệu vào sheet
      roles.forEach((role, roleIndex) => {
        role.data_role.forEach((data_role) => {
          const row = worksheet.addRow([
            role.project,
            data_role.role,
            renderMembers(data_role.members),
            fromDate + ' - ' + toDate,
            parseFloat(data_role.actual_point.toFixed(2)),
            parseFloat(data_role.point_performance.toFixed(2))
          ]);

          // Thiết lập style cho từng ô từ cột A đến cột G
          for (let colNumber = 1; colNumber <= 6; colNumber++) {
            const cell = row.getCell(colNumber);
            if (colNumber >= 5 || colNumber === 1) {
              cell.font = { bold: true, size: 12 };
            } else {
              cell.font = { size: 12 };
            }
            cell.alignment = { horizontal: 'center', vertical: 'center', wrapText: true };
            cell.border = dataStyle.border;

            if (colNumber === 1) {
              cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FABF8F' } };
            }
          }
        })
        if (role.data_role.length > 0) {
          if (roleIndex === 0) {
            mergeCell.push({
              start: 3,
              end: 3 + role.data_role.length - 1
            }
            )
          } else {
            const s = mergeCell[mergeCell.length - 1].end + 1;
            const e = s + role.data_role.length - 1;
            mergeCell.push({
              start: s,
              end: e,
            })
          }
        }

      });

      for (let i = 0; i < mergeCell.length; i++) {
        worksheet.mergeCells(`A${mergeCell[i].start}:A${mergeCell[i].end}`)
      }
      // Xuất Excel
      const buffer = await workbook.xlsx.writeBuffer();
      const dataBlob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });

      const url = URL.createObjectURL(dataBlob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `roles_report.xlsx`;
      a.click();
    }
    //Export Work Points
    else if (parseInt(typeStatistic) === 3) {
      const columnWidths = [20, 25, 30, 15, 15];

      if (!workPoints) {
        console.error("Invalid workPoints data");
        setLoading(false);
        return;
      }

      const workbook = new ExcelJS.Workbook();
      const worksheet = workbook.addWorksheet('Work Points Statistic Report');

      // Merge row cho header
      worksheet.mergeCells('A1:E1');
      worksheet.columns.forEach((column, colNumber) => {
        column.width = columnWidths[colNumber]; // Thiết lập độ rộng cho từng cột
      });

      const header = worksheet.getCell('A1');
      header.value = `Statistical Work Points report ${fromDate + ' - ' + toDate}`


      header.font = { bold: true, size: 14 };
      header.alignment = { horizontal: 'center', vertical: 'center' };
      header.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFFF' } };
      header.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } }

      // Thiết lập style cho header
      const headerRow = worksheet.addRow(["Name", "Time (YYYY-MM-DD)", "Plan Point", "Work Point", "Remaining"]);
      headerRow.alignment = { horizontal: 'center', vertical: 'center' };
      headerRow.eachCell((cell, colNumber) => {
        cell.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } };
        cell.font = { bold: true, size: 14 };
        if (colNumber <= 5) {
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'f7f705' } };
        }
      });

      // // Thiết lập style cho dữ liệu
      const dataStyle = { border: { left: { style: 'thin' }, right: { style: 'thin' }, top: { style: 'thin' }, bottom: { style: 'thin' } } };

      // Đặt dữ liệu vào sheet
      workPoints.forEach((point) => {
        const row = worksheet.addRow([
          point.name,
          fromDate + ' - ' + toDate,
          parseFloat(point.plan_point.toFixed(2)),
          parseFloat(point.work_point.toFixed(2)),
          parseFloat(point.remaining.toFixed(2)),
        ]);

        // Thiết lập style cho từng ô từ cột A đến cột G
        for (let colNumber = 1; colNumber <= 5; colNumber++) {
          const cell = row.getCell(colNumber);
          if (colNumber >= 3) {
            cell.font = { bold: true, size: 12 };
          } else {
            cell.font = { size: 12 };
          }
          cell.alignment = { horizontal: 'center', vertical: 'center', wrapText: true };
          cell.border = dataStyle.border;
        }
      });

      // Xuất Excel
      const buffer = await workbook.xlsx.writeBuffer();
      const dataBlob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });

      const url = URL.createObjectURL(dataBlob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `work_points_report.xlsx`;
      a.click();
    }
    setLoading(false);

  }


  const handleFilterChange = (type) => {
    setSelectedFilter(type);
    setTypeStatistic(type)
    setProjects([])
    setMembers([])
    setRoles([])
    setWorkPoints([])
    setSelectedStartEndDate(false)
  };

  const getFilterStyle = (filter) => ({
    color: selectedFilter === filter ? '#0A6971' : '#2f2f2f',
    borderBottom: selectedFilter === filter ? '2px solid #0A6971' : 'none',
    cursor: 'pointer',
  });

  const fetchProjects = async () => {
    setLoading(true)
    if (!selectedStartEndDate) {
      const params = {
        start_time: fromDate,
        end_time: toDate,
      }
      try {
        const response = await request.post(`view_report_management/statistic_all_projects_points_by_time`, params, {
          headers: headers,
        });
        setProjects(response.data.data);
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    } else {
      try {
        const response = await request.get(`view_report_management/statistic_all_projects_points`, {
          headers: headers,
        });
        setProjects(response.data.data);
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    }
    setLoading(false)

  };
  const fetchMembers = async () => {
    setLoading(true)

    const params = {
      start_time: fromDate,
      end_time: toDate,
    }
    try {
      const response = await request.post(`view_report_management/statistic_users_percentage_point`, params, {
        headers: headers,
      });
      setMembers(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
    setLoading(false)

  };
  const fetchRoles = async () => {
    setLoading(true)

    const params = {
      start_time: fromDate,
      end_time: toDate,
    }
    try {
      const response = await request.post(`view_report_management/statistic_points_by_role`, params, {
        headers: headers,
      });
      setRoles(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
    setLoading(false)

  }
  const fetchWorkPoints = async () => {
    setLoading(true)

    const users = selectedUsers.map(user => user.id).sort()
    const params = {
      users: users,
      start_time: fromDate,
      end_time: toDate,
    }
    try {
      const response = await request.post(`view_report_management/statistic_work_points`, params, {
        headers: headers,
      });
      setWorkPoints(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
    setLoading(false)

  }
  const fetchUsers = async () => {
    setLoading(true)
    try {
      const response = await request.get(`view_report_management/get_all_users`, {
        headers: headers,
      });
      setUsers(response.data.data)
      setSelectedUsers(response.data.data)
    } catch (error) {
      console.error('Error fetching data:', error);
    }
    setLoading(false)

  }
  const handleStartEndDateChange = () => {
    setSelectedStartEndDate(inputStartEndDate.current.checked);
    setProjects([]);
  };
  useEffect(() => {
    if (selectedStartEndDate) {
      fetchProjects()
    } else if (fromDate && toDate) {
      if (parseInt(typeStatistic) === 0) {
        fetchProjects()
        if (inputStartEndDate) {
          inputStartEndDate.current.checked = selectedStartEndDate
        }
      } else if (parseInt(typeStatistic) === 1) {
        fetchMembers();
      } else if (parseInt(typeStatistic) === 2) {
        fetchRoles();
      } else if (parseInt(typeStatistic) === 3) {
        fetchWorkPoints();
      }
    }
  }, [fromDate, toDate, typeStatistic, selectedStartEndDate, selectedUsers])

  useEffect(() => {
    fetchUsers()
  }, [])
  const renderProjects = (projects) => {
    const projectNames = projects.map(project => project.name);
    return projectNames.join(', ');
  }
  const renderMembers = (members) => {
    const memberNames = members.map(member => member.name);
    return memberNames.join(', ');
  }

  return (
    <div>
      {
        checkPermission('6') ? (
          <>
            <h1>View Report</h1>

            <div className={classes['header-wrapper']}>
              <div className={classes.date}>
                <div className={classes.fromDate}>
                  <label>From Date:</label>
                  <input type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} max={toDate} />
                </div>
                <div className={classes.toDate}>
                  <label>To Date:</label>
                  <input type="date" value={toDate} onChange={(e) => setToDate(e.target.value)} min={fromDate} />
                </div>
              </div>

            </div>

            <div className={classes.container__wrap}>
              <div className={classes.container}>
                <div className={classes.container__header}>
                  {/* Tab Filter */}
                  <div className={classes.container__header_filter}>
                    <div onClick={() => handleFilterChange(0)} style={getFilterStyle(0)}>
                      Project
                    </div>
                    <div onClick={() => handleFilterChange(1)} style={getFilterStyle(1)}>
                      Member
                    </div>
                    <div onClick={() => handleFilterChange(2)} style={getFilterStyle(2)}>
                      Role
                    </div>
                    <div onClick={() => handleFilterChange(3)} style={getFilterStyle(3)}>
                      Work Point
                    </div>
                  </div>
                  <div className={classes.container__header_right}>
                    {parseInt(typeStatistic) === 0 && (
                      <div className={classes.container__header_right_checkbox}>
                        <input style={{ height: '1.5rem', width: '1.5rem', marginRight: '8px', accentColor: '#6faf8c' }} type="checkbox" id="start_end_date" name="start_end_date" ref={inputStartEndDate} value={true} onChange={handleStartEndDateChange} />
                        <label htmlFor="start_end_date">Statistic Start/End Date</label>
                      </div>
                    )}
                    {parseInt(typeStatistic) === 3 && (
                      <div className={classes.filter}>
                        <div
                          className={[classes.filter__ic, filterActive && classes['filter__ic--active']].join(' ')}
                          onClick={() => setFilterActive(!filterActive)}
                        >
                          <FontAwesomeIcon icon={faFilter} />
                        </div>
                        {filterActive && (
                          <DropdownUser
                            setSelectedUsers={setSelectedUsers}
                            selectedUsers={selectedUsers}
                            users={users}
                          />
                        )}
                      </div>
                    )}
                    <Button
                      onClick={exportToExcel}
                      label="Export to Excel"
                      icon={<FontAwesomeIcon icon={faFileExport} className={classes.icon} />}
                    />
                  </div>
                </div>
                <div className={classes.table_container}>
                  {parseInt(typeStatistic) === 0 && (
                    <>
                      {/* Table Project */}
                      {/* Table Header */}
                      <div className={classes.table_header}>
                        <table className={classes.table__header_wrap}>
                          <thead className={classes.table__header_wrap_thead}>
                            <tr>
                              {/* <th style={{ width: '10%' }}>STT</th> */}
                              <th style={{ width: '20%' }}>Name</th>
                              <th style={{ width: '20%' }}>Type</th>
                              <th style={{ width: '20%' }}>Time</th>
                              <th style={{ width: '20%' }}>Actual Point</th>
                              <th style={{ width: '20%' }}>Plan Point</th>
                            </tr>
                          </thead>
                        </table>
                      </div>
                      {/* Table Body */}
                      {selectedStartEndDate ? (
                        <>
                          <div className={classes.table__body}>
                            <table className={classes.table__body_wrap}>
                              <tbody>
                                {projects.map((row, rowIndex) => (
                                  <tr className={classes.table__body_wrap_row} key={row.project_id}>
                                    {/* <td style={{ width: '10%' }}>{rowIndex + 1}</td> */}
                                    <td style={{ width: '20%' }}>{row.project_name}</td>
                                    <td style={{ width: '20%' }}>{row.project_type}</td>
                                    <td style={{ width: '20%' }}>{row.start_time + ' - ' + row.end_time}</td>
                                    <td style={{ width: '20%' }}>{row.actual_point.toFixed(2)}</td>
                                    <td style={{ width: '20%' }}>{row.plan_point.toFixed(2)}</td>
                                  </tr>
                                ))}
                              </tbody>
                            </table>
                          </div>
                        </>
                      ) : (
                        <>
                          {fromDate && toDate && (
                            <div className={classes.table__body}>
                              <table className={classes.table__body_wrap}>
                                <tbody>
                                  {projects.map((row, rowIndex) => (
                                    <tr className={classes.table__body_wrap_row} key={row.project_id}>
                                      {/* <td style={{ width: '10%' }}>{rowIndex + 1}</td> */}
                                      <td style={{ width: '20%' }}>{row.project_name}</td>
                                      <td style={{ width: '20%' }}>{row.project_type}</td>
                                      <td style={{ width: '20%' }}>{row.start_time + ' - ' + row.end_time}</td>
                                      <td style={{ width: '20%' }}>{row.actual_point.toFixed(2)}</td>
                                      <td style={{ width: '20%' }}>{row.plan_point.toFixed(2)}</td>
                                    </tr>
                                  ))}
                                </tbody>
                              </table>
                            </div>
                          )}
                        </>
                      )}
                    </>
                  )}

                  {parseInt(typeStatistic) === 1 && (
                    <>
                      {/* Table Project */}
                      {/* Table Header */}
                      <div className={classes.table_header}>
                        <table className={classes.table__header_wrap}>
                          <thead className={classes.table__header_wrap_thead}>
                            <tr>
                              {/* <th style={{ width: '10%' }}>STT</th> */}
                              <th style={{ width: '10%' }}>Name</th>
                              <th style={{ width: '15%' }}>Type</th>
                              <th style={{ width: '30%' }}>Projects</th>
                              <th style={{ width: '15%' }}>Time</th>
                              <th style={{ width: '15%' }}>Plan Point</th>
                              <th style={{ width: '15%' }}>Percent</th>
                            </tr>
                          </thead>
                        </table>
                      </div>
                      {/* Table Body */}
                      {fromDate && toDate && (
                        <div className={classes.table__body}>
                          <table className={classes.table__body_wrap}>
                            <tbody>
                              {members.map((user) => (
                                user.point_percentages.map((row, rowIndex) => (
                                  <tr className={classes.table__body_wrap_row} key={`${user.user_id}-${row.project_type_id}-${rowIndex}`}>
                                    {rowIndex === 0 && (
                                      <td rowSpan={user.point_percentages.length} style={{ backgroundColor: '#d7f7d3', width: '10%', marginLeft: '4px' }}>
                                        {user.name}
                                      </td>
                                    )}
                                    <td style={{ width: '15%', marginLeft: '4px' }}>{row.project_type}</td>
                                    <td style={{ width: '30%', marginLeft: '4px' }}>{renderProjects(row.projects)}</td>
                                    <td style={{ width: '15%', marginLeft: '4px' }}>{fromDate + ' - ' + toDate}</td>
                                    <td style={{ width: '15%', marginLeft: '4px' }}>{row.plan_point.toFixed(2)}</td>
                                    <td style={{ width: '15%', marginLeft: '4px' }}>{(row.percent.toFixed(2) * 100).toFixed(2) + ' %'}</td>
                                  </tr>
                                ))
                              ))}
                            </tbody>
                          </table>
                        </div>
                      )}
                    </>
                  )}

                  {parseInt(typeStatistic) === 2 && (
                    <>
                      {/* Table Project */}
                      {/* Table Header */}
                      <div className={classes.table_header}>
                        <table className={classes.table__header_wrap}>
                          <thead className={classes.table__header_wrap_thead}>
                            <tr>
                              {/* <th style={{ width: '10%' }}>STT</th> */}
                              <th style={{ width: '10%' }}>Project</th>
                              <th style={{ width: '15%' }}>Role</th>
                              <th style={{ width: '25%' }}>Members</th>
                              <th style={{ width: '20%' }}>Time</th>
                              <th style={{ width: '15%' }}>Actual Point</th>
                              <th style={{ width: '15%' }}>Point Performance</th>
                            </tr>
                          </thead>
                        </table>
                      </div>
                      {/* Table Body */}
                      {fromDate && toDate && (
                        <div className={classes.table__body}>
                          <table className={classes.table__body_wrap}>
                            <tbody>
                              {roles.map((role, roleIndex) => (
                                role.data_role.map((row, rowIndex) => (
                                  <tr className={classes.table__body_wrap_row} key={`${roleIndex}-${rowIndex}`}>
                                    {/* <td style={{ width: '10%' }}>{roleIndex * role.data_role.length + rowIndex + 1}</td> */}

                                    {rowIndex === 0 && (
                                      <td rowSpan={role.data_role.length} style={{ backgroundColor: '#d7f7d3', width: '10%' }}>
                                        {role.project}
                                      </td>
                                    )}
                                    <td style={{ width: '15%' }}>{row.role}</td>
                                    <td style={{ width: '25%' }}>{renderMembers(row.members)}</td>
                                    <td style={{ width: '20%' }}>{fromDate + ' - ' + toDate}</td>
                                    <td style={{ width: '15%' }}>{row.actual_point.toFixed(2)}</td>
                                    <td style={{ width: '15%' }}>{row.point_performance.toFixed(2)}</td>
                                  </tr>
                                ))
                              ))}
                            </tbody>
                          </table>
                        </div>
                      )}
                    </>
                  )}

                  {parseInt(typeStatistic) === 3 && (
                    <>
                      {/* Table Project */}
                      {/* Table Header */}
                      <div className={classes.table_header}>
                        <table className={classes.table__header_wrap}>
                          <thead className={classes.table__header_wrap_thead}>
                            <tr>
                              {/* <th style={{ width: '10%' }}>STT</th> */}
                              <th style={{ width: '10%' }}>Name</th>
                              <th style={{ width: '20%' }}>Time</th>
                              <th style={{ width: '20%' }}>Plan Point</th>
                              <th style={{ width: '20%' }}>Work Point</th>
                              <th style={{ width: '20%' }}>Remaining</th>
                            </tr>
                          </thead>
                        </table>
                      </div>
                      {/* Table Body */}
                      {fromDate && toDate && (
                        <div className={classes.table__body}>
                          <table className={classes.table__body_wrap}>
                            <tbody>
                              {workPoints.map((row, rowIndex) => (
                                <tr className={classes.table__body_wrap_row} key={`${rowIndex}`}>
                                  {/* <td style={{ width: '10%' }}>{rowIndex + 1}</td> */}
                                  <td style={{ width: '10%' }}>{row.name}</td>
                                  <td style={{ width: '20%' }}>{fromDate + ' - ' + toDate}</td>
                                  <td style={{ width: '20%' }}>{row.plan_point.toFixed(2)}</td>
                                  <td style={{ width: '20%' }}>{row.work_point.toFixed(2)}</td>
                                  <td style={{ width: '20%' }}>{row.remaining.toFixed(2)}</td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      )}
                    </>
                  )}
                </div>
              </div>
            </div>
            <Backdrop sx={{ color: '#fff', zIndex: (theme) => theme.zIndex.drawer + 1 }} open={loading}>
              <CircularProgress color="inherit" />
            </Backdrop>
          </>
        ) : (
          <div>
            <h2>No permissions</h2>
          </div>
        )

      }
    </div>
  );
}

export default ViewReport;