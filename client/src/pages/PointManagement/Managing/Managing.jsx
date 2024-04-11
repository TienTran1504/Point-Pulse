import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import checkPermission from '~/utils/checkPermission';
import request from '~/utils/request';
import classes from './Managing.module.scss';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBackward, faFilter } from '@fortawesome/free-solid-svg-icons';
import { checkCurrentDate, getCurrentDate, getOneMonthAgoDate, getWeeksInRange } from '~/utils/handleDate';
import { Backdrop, CircularProgress } from '@mui/material';
import { getLocalItem } from '~/utils/storageHelper';
import DropdownProject from '~/components/DropdownProject/DropdownProject';
import debounce from 'lodash/debounce';
import Swal from 'sweetalert2'

function Managing() {
  const personalNavigate = useNavigate()
  const currentDate = getCurrentDate();
  const currentDateMonthAgo = getOneMonthAgoDate();
  const [filterActive, setFilterActive] = useState(false);
  const [users, setUsers] = useState([])
  const [projectUsers, setProjectUsers] = useState([])
  const [currentInputValue, setCurrentInputValue] = useState(0);
  const [selectedProjects, setSelectedProjects] = useState([])
  const [loading, setLoading] = useState(false);
  const [projectData, setProjectData] = useState([])
  const [projects, setProjects] = useState([]);
  const [managingProjects, setManagingProjects] = useState([]);
  const [fromDate, setFromDate] = useState(currentDateMonthAgo);
  const [toDate, setToDate] = useState(currentDate);
  const [weeksInfo, setWeeksInfo] = useState([])
  const [weekPoints, setWeekPoints] = useState('')
  const [oldPlanPoint, setOldPlanPoint] = useState(0)
  const [oldActualPoint, setOldActualPoint] = useState(0)
  const timeoutPlanRef = useRef(null);
  const timeoutActualRef = useRef(null);
  const [firstPlanClick, setFirstPlanClick] = useState(true)
  const [firstActualClick, setFirstActualClick] = useState(true)
  const [insertPointPlan, setInsertPointPlan] = useState(null)
  const [insertPointActual, setInsertPointActual] = useState(null)
  const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
  const headers = {
    Authorization: tokenAuth,
  };
  const fetchUsers = async () => {
    try {
      const responseUsers = await request.get('user_management/get_all', {
        headers: headers,
      });
      const filteredUser = responseUsers.data.data.filter((user) =>
        projectUsers.some((projectUser) => user.id === projectUser.user_id)
      );
      setUsers(filteredUser)
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };
  const fetchProjects = async () => {
    try {
      const response = await request.get('point_management/get_projects_unblocked', {
        headers: headers,
      });
      setProjects(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };
  const fetchManagingProject = async () => {
    try {
      const response = await request.get(`point_management/project_users/get_managing_projects`, {
        headers: headers,
      });
      setManagingProjects(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };
  const fetchProjectUsers = async () => {
    let projectUsers = []
    try {
      for (let i = 0; i < managingProjects.length; i++) {
        const response = await request.get(`point_management/project_users/get_in_project/${managingProjects[i].project_id}`, { headers: headers })
        for (let j = 0; j < response.data.data.length; j++) {
          projectUsers.push(response.data.data[j])
        }
      }
    } catch (error) {
      console.error('Error fetching data:', error);
    }
    setProjectUsers(projectUsers)
    return projectUsers
  }

  useEffect(() => {
    fetchProjects()
    fetchManagingProject();
    fetchProjectUsers();
  }, [])
  useEffect(() => {
    fetchUsers()
  }, [projectUsers])

  const checkedUserInProject = (project_id, user_id) => {

    const checked = projectUsers.some(projectUser => projectUser.user_id === user_id && projectUser.project_id === project_id)
    return !checked;
  }
  const fetchWeekPoints = async () => {
    setLoading(true)
    const newWeeksInfo = getWeeksInRange(fromDate, toDate)
    let pointsData = [];
    for (let i = 0; i < newWeeksInfo.length; i++) {
      const time = newWeeksInfo[i].formattedWeek.split(" - ");
      try {
        const response = await request.post(`point_management/get_all_user_week_points_by_week`, { time: time[0] }, {
          headers: headers,
        });
        for (let i = 0; i < response.data.data.length; i++) {
          pointsData.push(response.data.data[i])
        }
        const responseWeek = await request.post('/calculate_time', { time: time[0] })
        newWeeksInfo[i].time = responseWeek.data.data
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    }
    setWeeksInfo(newWeeksInfo)
    setWeekPoints(pointsData);
    setLoading(false)

  }
  const handleProjectData = async () => {
    let projectUsers = await fetchProjectUsers();
    if (weekPoints !== undefined) {
      const newData = projects.map((project) => {
        const users = projectUsers.filter(projectUser => projectUser.project_id === project.id)
        const newUsers = users.map((user) => {
          const points = weekPoints.filter((point) => {
            return point.project_id === project.id && point.user_id === user.user_id
          })
          return {
            ...user,
            points: points
          }
        })
        return {
          id: project.id,
          name: project.name,
          type: project.project_type,
          users: newUsers
        }
      })
      const filteredArray = newData.filter((project) =>
        managingProjects.some((managing) => project.id === managing.project_id)
      );
      setProjectData(filteredArray)
      setSelectedProjects(filteredArray)

    }
    else {
      const newData = projects.map((project) => {
        const users = projectUsers.filter(projectUser => projectUser.project_id === project.id)
        const newUsers = users.map((user) => {
          return {
            ...user,
            points: []
          }
        })
        return {
          id: project.id,
          name: project.name,
          type: project.project_type,
          users: newUsers
        }
      })
      const filteredArray = newData.filter((project) =>
        managingProjects.some((managing) => project.id === managing.project_id)
      );

      setProjectData(filteredArray)
      setSelectedProjects(filteredArray)

    }
  }
  useEffect(() => {

    fetchWeekPoints();
    handleProjectData();

  }, [fromDate, toDate])

  useEffect(() => {
    handleProjectData();
  }, [weekPoints])

  useEffect(() => {
    if (insertPointActual !== null) {
      if (insertPointActual?.actual_point > 0) {
        debouncedHandleEditActualPoint(insertPointActual.project_id, insertPointActual.user_id, insertPointActual.time, insertPointActual.actual_point)
      }

    }
  }, [insertPointActual, firstActualClick])

  useEffect(() => {
    if (insertPointPlan !== null) {
      if (insertPointPlan?.plan_point > 0) {
        debouncedHandleEditPlanPoint(insertPointPlan.project_id, insertPointPlan.user_id, insertPointPlan.time, insertPointPlan.plan_point)
      }
    }

  }, [insertPointPlan, firstPlanClick])
  const debouncedHandleEditPlanPoint = debounce(async (projectId, userId, week, inputValue) => {
    const timeInfor = week?.split(" - ")
    if (inputValue > 0 && !firstPlanClick) {
      const params = {
        project_id: projectId,
        user_id: userId,
        time: timeInfor[0],
        plan_point: inputValue,
        old_plan_point: oldPlanPoint > 0 ? oldPlanPoint : 0,
      }
      try {
        const res = await request.post(`point_management/insert_plan_point`, params, {
          headers: headers,
        });
        if (res.data?.error_code === 1001) {
          Swal.fire({
            title: "The point has recently updated. Do you want to overwrite it?",
            showDenyButton: true,
            // showCancelButton: true,
            confirmButtonText: "Save",
            denyButtonText: `Don't save`
          }).then(async (result) => {
            /* Read more about isConfirmed, isDenied below */
            const { project_id, plan_point, new_plan_point, user_id, week_of_year, year } = res.data.data
            if (result.isConfirmed) {
              const overwrite_params = {
                project_id,
                user_id,
                time: timeInfor[0],
                plan_point: new_plan_point,
              }
              await request.post(`point_management/insert_force_plan_point`, overwrite_params, {
                headers: headers,
              });
            } else if (result.isDenied) {
              const updatedProjectData = [...selectedProjects];

              // Find the project, user, and point indexes
              const projectIndex = updatedProjectData.findIndex((project) => project.id === projectId);
              const userIndex = updatedProjectData[projectIndex].users.findIndex((user) => user.user_id === userId);
              const pointIndex = updatedProjectData[projectIndex].users[userIndex].points.findIndex(
                (point) => point.year === year && point.week_of_year === week_of_year
              );

              // Check if the point object exists, if not, create a new one
              if (pointIndex !== -1) {
                // Update the plan_point value
                updatedProjectData[projectIndex].users[userIndex].points[pointIndex].plan_point = plan_point;
                updatedProjectData[projectIndex].users[userIndex].points[pointIndex].time = week;
              } else {
                // Point object not found, create a new one
                const newPoint = {
                  project_id,
                  user_id,
                  time: timeInfor[0],
                  year,
                  week_of_year,
                  plan_point,
                  // Add other properties as needed
                };

                // Push the new point object to the points array
                updatedProjectData[projectIndex].users[userIndex].points.push(newPoint);
              }
              setSelectedProjects(updatedProjectData)
            }
          });

        }
      } catch (error) {
        console.error("Handling Data Error: ", error.message)
      }
      setCurrentInputValue(0)
      setOldPlanPoint(0)
      setFirstPlanClick(true)
      setInsertPointPlan(null)
    }
  }, 500); // Adjust the debounce delay as needed

  const debouncedHandleEditActualPoint = debounce(async (projectId, userId, week, inputValue) => {
    const timeInfor = week?.split(" - ");
    if (inputValue > 0 && !firstActualClick) {
      const params = {
        project_id: projectId,
        user_id: userId,
        time: timeInfor[0],
        actual_point: inputValue,
        old_plan_point: 0,
        old_actual_point: oldActualPoint > 0 ? oldActualPoint : 0,
      };
      try {
        const res = await request.post(`point_management/insert_actual_point`, params, {
          headers: headers,
        });
        if (res.data?.error_code === 1001) {
          Swal.fire({
            title: "The point has recently updated. Do you want to overwrite it?",
            showDenyButton: true,
            // showCancelButton: true,
            confirmButtonText: "Save",
            denyButtonText: `Don't save`
          }).then(async (result) => {
            /* Read more about isConfirmed, isDenied below */
            const { project_id, actual_point, new_actual_point, user_id, week_of_year, year } = res.data.data
            if (result.isConfirmed) {
              const overwrite_params = {
                project_id,
                user_id,
                time: timeInfor[0],
                actual_point: new_actual_point,
              }
              await request.post(`point_management/insert_force_actual_point`, overwrite_params, {
                headers: headers,
              });
            } else if (result.isDenied) {
              const updatedProjectData = [...selectedProjects];

              // Find the project, user, and point indexes
              const projectIndex = updatedProjectData.findIndex((project) => project.id === projectId);
              const userIndex = updatedProjectData[projectIndex].users.findIndex((user) => user.user_id === userId);
              const pointIndex = updatedProjectData[projectIndex].users[userIndex].points.findIndex(
                (point) => point.year === year && point.week_of_year === week_of_year
              );

              // Check if the point object exists, if not, create a new one
              if (pointIndex !== -1) {
                // Update the actual_point value
                updatedProjectData[projectIndex].users[userIndex].points[pointIndex].actual_point = actual_point;
                updatedProjectData[projectIndex].users[userIndex].points[pointIndex].time = week;
              } else {
                // Point object not found, create a new one
                const newPoint = {
                  project_id,
                  user_id,
                  time: timeInfor[0],
                  year,
                  week_of_year,
                  actual_point,
                  // Add other properties as needed
                };

                // Push the new point object to the points array
                updatedProjectData[projectIndex].users[userIndex].points.push(newPoint);
              }
              setSelectedProjects(updatedProjectData)
            }
          });

        }
      } catch (error) {
        console.error("Handling Data Error: ", error.message)
      }
      setCurrentInputValue(0);
      setOldActualPoint(0)
      setFirstActualClick(true)
      setInsertPointActual(null)
    }
  }, 500); // Adjust the debounce delay as needed
  const handleInputChangePlanPoint = (projectId, userId, time, week, e) => {
    const inputValue = parseFloat(e.target.value) > 0 ? parseFloat(e.target.value) : 0;
    setCurrentInputValue(inputValue);
    // Clone projectData to avoid direct state modification
    const updatedProjectData = [...selectedProjects];

    // Find the project, user, and point indexes
    const projectIndex = updatedProjectData.findIndex((project) => project.id === projectId);
    const userIndex = updatedProjectData[projectIndex].users.findIndex((user) => user.user_id === userId);
    let pointIndex = updatedProjectData[projectIndex].users[userIndex].points.findIndex(
      (point) => point.year === time.year && point.week_of_year === time.week_of_year
    );

    // Check if the point object exists, if not, create a new one
    if (pointIndex !== -1) {
      if (firstPlanClick) {
        setOldPlanPoint(updatedProjectData[projectIndex].users[userIndex].points[pointIndex].plan_point)
        setFirstPlanClick(false)
      }
      // Update the plan_point value
      updatedProjectData[projectIndex].users[userIndex].points[pointIndex].plan_point = inputValue;
      updatedProjectData[projectIndex].users[userIndex].points[pointIndex].time = week;
    } else {
      setFirstPlanClick(false)
      // Point object not found, create a new one
      const newPoint = {
        project_id: projectId,
        user_id: userId,
        time: week,
        year: time.year,
        week_of_year: time.week_of_year,
        plan_point: inputValue,
        // Add other properties as needed
      };

      // Push the new point object to the points array
      updatedProjectData[projectIndex].users[userIndex].points.push(newPoint);
      pointIndex = updatedProjectData[projectIndex].users[userIndex].points.length - 1
    }
    if (timeoutPlanRef.current) {
      clearTimeout(timeoutPlanRef.current);
    }
    // Update the state with the modified data
    // setProjectData(updatedProjectData);
    setSelectedProjects(updatedProjectData)

    timeoutPlanRef.current = setTimeout(() => {
      setInsertPointPlan(updatedProjectData[projectIndex].users[userIndex].points[pointIndex])
    }, 500);
    // debouncedHandleEditPlanPoint(projectId, userId, week, inputValue)
  };

  const handleInputChangeActualPoint = (projectId, userId, time, week, e) => {
    const inputValue = parseFloat(e.target.value) > 0 ? parseFloat(e.target.value) : 0;
    setCurrentInputValue(inputValue);
    // Clone projectData to avoid direct state modification
    const updatedProjectData = [...selectedProjects];

    // Find the project, user, and point indexes
    const projectIndex = updatedProjectData.findIndex((project) => project.id === projectId);
    const userIndex = updatedProjectData[projectIndex].users.findIndex((user) => user.user_id === userId);
    let pointIndex = updatedProjectData[projectIndex].users[userIndex].points.findIndex(
      (point) => point.year === time.year && point.week_of_year === time.week_of_year
    );

    // Check if the point object exists, if not, create a new one
    if (pointIndex !== -1) {
      if (firstActualClick) {
        setOldActualPoint(updatedProjectData[projectIndex].users[userIndex].points[pointIndex].actual_point)
        setFirstActualClick(false)
      }
      // Update the plan_point value
      updatedProjectData[projectIndex].users[userIndex].points[pointIndex].actual_point = inputValue;
      updatedProjectData[projectIndex].users[userIndex].points[pointIndex].time = week;
    } else {
      setFirstActualClick(false)
      // Point object not found, create a new one
      const newPoint = {
        project_id: projectId,
        user_id: userId,
        time: week,
        year: time.year,
        week_of_year: time.week_of_year,
        actual_point: inputValue,
        // Add other properties as needed
      };

      // Push the new point object to the points array
      updatedProjectData[projectIndex].users[userIndex].points.push(newPoint);
      pointIndex = updatedProjectData[projectIndex].users[userIndex].points.length - 1

    }
    if (timeoutActualRef.current) {
      clearTimeout(timeoutActualRef.current);
    }
    // Update the state with the modified data
    // setProjectData(updatedProjectData);
    setSelectedProjects(updatedProjectData)

    timeoutActualRef.current = setTimeout(() => {
      setInsertPointActual(updatedProjectData[projectIndex].users[userIndex].points[pointIndex])
    }, 1000);
    // debouncedHandleEditActualPoint(projectId, userId, week, inputValue)
  };

  // const insertPlanPoint = async (project_id, user_id, timeData) => {
  //   const time = timeData.split(" - ")
  //   if (currentInputValue > 0) {
  //     const params = {
  //       project_id,
  //       user_id,
  //       time: time[0],
  //       plan_point: currentInputValue,
  //     }
  //     try {
  //       await request.post(`project_point_management/insert_week_point`, params, {
  //         headers: headers,
  //       });
  //     } catch (error) {
  //       console.error("Handling Data Error: ", error.message)
  //     }
  //     setCurrentInputValue(0)
  //   }
  // }

  // const insertActualPoint = async (project_id, user_id, timeData) => {
  //   const time = timeData.split(" - ")
  //   if (currentInputValue > 0) {
  //     const params = {
  //       project_id,
  //       user_id,
  //       time: time[0],
  //       actual_point: currentInputValue,
  //     }
  //     try {
  //       await request.post(`project_point_management/insert_week_point`, params, {
  //         headers: headers,
  //       });
  //     } catch (error) {
  //       console.error("Handling Data Error: ", error.message)
  //     }
  //     setCurrentInputValue(0)
  //   }
  // }

  const renderTotalPlanPoint = (user_id, timeData) => {
    let total = 0;

    projectData.forEach((project) => {
      const user = project.users.find((u) => u.user_id === user_id);
      if (user) {
        const point = user.points.find((p) => p.year === timeData.year && p.week_of_year === timeData.week_of_year);
        if (point) {
          total += point.plan_point || 0;
        }
      }
    });

    return total.toFixed(2);
  };
  const renderTotalActualPoint = (user_id, timeData) => {
    let total = 0;

    projectData.forEach((project) => {
      const user = project.users.find((u) => u.user_id === user_id);
      if (user) {
        const point = user.points.find((p) => p.year === timeData.year && p.week_of_year === timeData.week_of_year);
        if (point) {
          total += point.actual_point || 0;
        }
      }
    });

    return total.toFixed(2);
  };

  return (
    <div>
      {
        checkPermission('5') ? (

          <div>
            <h1>Managing</h1>
            {managingProjects.length > 0 ? (
              <>
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
                  {fromDate && toDate && (

                    <div className={classes.state}>
                      <div className={classes.filter}>
                        <div
                          className={[classes.filter__ic, filterActive && classes['filter__ic--active']].join(' ')}
                          onClick={() => setFilterActive(!filterActive)}
                        >
                          <FontAwesomeIcon icon={faFilter} />
                        </div>
                        {filterActive && (
                          <DropdownProject
                            setSelectedProjects={setSelectedProjects}
                            selectedProjects={selectedProjects}
                            projectData={projectData}
                          />
                        )}
                      </div>
                    </div>
                  )}
                </div>
                {fromDate && toDate && (
                  <div className={classes['table-container']}>
                    <table className={classes["table-project-point"]}>
                      <thead className={`${classes.stickyRow}`}>
                        <tr >
                          <th className={`${classes.stickyColumn}`} rowSpan="2">
                            <div className={classes.elementEmpty}>
                            </div>
                          </th>
                          {weeksInfo.map((week, index) => (
                            <th className={`${classes.stickyRow}`} key={`${week.formattedWeek}-${index}`} colSpan={users.length}>
                              <div className={`${classes.elementHeaderFirst}`}>{week.formattedWeek}</div>
                            </th>
                          ))}

                        </tr>
                        <tr>

                          {weeksInfo.map((week) => (
                            users.map((user) => (
                              <th className={` ${classes.stickyRow}`} key={`${user.id}-${week.formattedWeek}`}>
                                <div className={`${classes.elementHeader}`} colSpan={users.length}>
                                  {user.name}
                                </div>
                              </th>
                            ))
                          ))}

                        </tr>
                      </thead>
                      <tbody>
                        {selectedProjects.map((project) => (
                          <tr key={project.id}>
                            <td className={` ${classes.stickyColumn}`}>
                              <div className={classes.elementSide}>
                                {project.name}
                              </div>
                            </td>
                            {
                              weeksInfo.map((week) => (
                                users.map((user) => (
                                  <td className={`${classes.element} ${checkedUserInProject(project.id, user.id) ? classes.disabled : ''}`} key={`${user.id}-${week.formattedWeek}`}>
                                    <input
                                      type="number"
                                      step={0.01}
                                      className={classes.inputPoint}
                                      onClick={(e) => e.target.select()}
                                      value={selectedProjects.find(p => p.id === project.id)?.users.find(u => u.user_id === user.id)?.points.find(point => point.week_of_year === week.time.week_of_year)?.plan_point || 0}
                                      onChange={(e) => handleInputChangePlanPoint(project.id, user.id, week.time, week.formattedWeek, e)}
                                      // onBlur={() => insertPlanPoint(project.id, user.id, week.formattedWeek)}
                                      onWheel={event => event.currentTarget.blur()}
                                      disabled={checkedUserInProject(project.id, user.id)}

                                    />
                                  </td>
                                ))
                              ))
                            }
                          </tr>
                        ))}
                        <tr>
                          <td className={`${classes.stickyColumn} ${classes.totalPoint}`}>
                            <div className={classes.elementSide}>
                              Personal Total (hour)
                            </div>
                          </td>
                          {
                            weeksInfo.map((week) => (
                              users.map((user) => (
                                <td className={`${classes.element} ${classes.totalPoint}`} key={`${user.id}-${week.formattedWeek}`}>
                                  <div className={classes.total}>
                                    {renderTotalPlanPoint(user.id, week.time)}
                                  </div>
                                </td>
                              ))
                            ))
                          }
                        </tr>

                        {selectedProjects.map((project) => (
                          <tr key={project.id}>
                            <td className={`${classes.stickyColumn}`}>
                              <div className={classes.elementSide}>
                                {project.name}
                              </div>
                            </td>
                            {
                              weeksInfo.map((week) => (
                                users.map((user) => (
                                  <td className={`${classes.element} ${checkedUserInProject(project.id, user.id) || checkCurrentDate(week.formattedWeek) ? classes.disabled : ''}`} key={`${user.id}-${week.formattedWeek}`}>
                                    <input
                                      className={classes.inputPoint}
                                      step={0.01}
                                      type="number"
                                      onClick={(e) => e.target.select()}
                                      value={selectedProjects.find(p => p.id === project.id)?.users.find(u => u.user_id === user.id)?.points.find(point => point.week_of_year === week.time.week_of_year)?.actual_point || 0}
                                      onChange={(e) => handleInputChangeActualPoint(project.id, user.id, week.time, week.formattedWeek, e)}
                                      // onBlur={() => insertActualPoint(project.id, user.id, week.formattedWeek)}
                                      disabled={checkedUserInProject(project.id, user.id) || checkCurrentDate(week.formattedWeek)}
                                      onWheel={event => event.currentTarget.blur()}

                                    />
                                  </td>
                                ))
                              ))
                            }
                          </tr>
                        ))}
                        <tr>
                          <td className={`${classes.stickyColumn} ${classes.totalPoint}`}>
                            <div className={classes.elementLastSide}>
                              Personal Total (hour)
                            </div>
                          </td>
                          {
                            weeksInfo.map((week) => (
                              users.map((user) => (
                                <td className={`${classes.element} ${classes.totalPoint}`} key={`${user.id}-${week.formattedWeek}`}>
                                  <div className={classes.total}>
                                    {renderTotalActualPoint(user.id, week.time)}
                                  </div>
                                </td>
                              ))
                            ))
                          }
                        </tr>
                      </tbody>
                    </table>
                  </div>
                )}
              </>
            ) : (
              <>
                <h2>Don't Have Any Managing Project</h2>
              </>
            )}


            <div className={classes['button-wrapper']}>
              <Button
                className={classes['button_add']}
                onClick={() => {
                  personalNavigate('/point_management')
                }}
                label="Back"
                icon={<FontAwesomeIcon icon={faBackward} className={classes.icon} />}
              >

              </Button>
            </div>
            <Backdrop sx={{ color: '#fff', zIndex: (theme) => theme.zIndex.drawer + 1 }} open={loading}>
              <CircularProgress color="inherit" />
            </Backdrop>
          </div>
        ) : (
          <div>
            <h2>No permissions</h2>
          </div>
        )

      }
    </div>
  );
}

export default Managing;