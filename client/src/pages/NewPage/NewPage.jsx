import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import request from "~/utils/request";
import { getLocalItem } from "~/utils/storageHelper";
import classes from './NewPage.module.scss';

const weeksInfo = [
  {
    "formattedWeek": "2024-01-08 - 2024-01-14",
    "time": {
      "month": 1,
      "year": 2024,
      "week_of_year": 2
    }
  },
  {
    "formattedWeek": "2024-01-15 - 2024-01-21",
    "time": {
      "month": 1,
      "year": 2024,
      "week_of_year": 3
    }
  },
  {
    "formattedWeek": "2024-01-22 - 2024-01-28",
    "time": {
      "month": 1,
      "year": 2024,
      "week_of_year": 4
    }
  }
]
const initialProjectData = [
  {
    "id": 1,
    "name": "Project A",
    "type": "client project",
    "users": [
      {
        "id": 1,
        "user_id": 1,
        "inserted_at": "2023-12-26T16:24:12Z",
        "inserted_by": 1,
        "updated_at": "2023-12-26T16:24:12Z",
        "updated_by": 1,
        "project_id": 1,
        "user_name": "Tien Tran",
        "user_role_id": 1,
        "user_role": "manager",
        "user_email": "admin@gmail.com",
        "points": [
          {
            "id": 485,
            "month": 1,
            "year": 2024,
            "user_id": 1,
            "inserted_at": "2024-01-08T01:52:43Z",
            "inserted_by": 1,
            "updated_at": "2024-01-08T02:31:39Z",
            "updated_by": 1,
            "project_id": 1,
            "actual_point": 42.62,
            "plan_point": 59.64,
            "week_of_year": 2
          },
          {
            "id": 488,
            "month": 1,
            "year": 2024,
            "user_id": 1,
            "inserted_at": "2024-01-08T01:52:43Z",
            "inserted_by": 1,
            "updated_at": "2024-01-08T02:31:39Z",
            "updated_by": 1,
            "project_id": 1,
            "actual_point": 0,
            "plan_point": 42.05,
            "week_of_year": 3
          }
        ]
      },
      {
        "id": 2,
        "user_id": 2,
        "inserted_at": "2023-12-26T16:24:12Z",
        "inserted_by": 1,
        "updated_at": "2023-12-26T16:24:12Z",
        "updated_by": 1,
        "project_id": 1,
        "user_name": "Member 2",
        "user_role_id": 2,
        "user_role": "tech lead",
        "user_email": "member2@gmail.com",
        "points": [
          {
            "id": 486,
            "month": 1,
            "year": 2024,
            "user_id": 2,
            "inserted_at": "2024-01-08T01:52:43Z",
            "inserted_by": 1,
            "updated_at": "2024-01-08T02:31:39Z",
            "updated_by": 1,
            "project_id": 1,
            "actual_point": 54.4,
            "plan_point": 46.79,
            "week_of_year": 2
          },
          {
            "id": 489,
            "month": 1,
            "year": 2024,
            "user_id": 2,
            "inserted_at": "2024-01-08T01:52:43Z",
            "inserted_by": 1,
            "updated_at": "2024-01-08T02:31:39Z",
            "updated_by": 1,
            "project_id": 1,
            "actual_point": 0,
            "plan_point": 55.47,
            "week_of_year": 3
          }
        ]
      },
      {
        "id": 3,
        "user_id": 3,
        "inserted_at": "2023-12-26T16:24:12Z",
        "inserted_by": 1,
        "updated_at": "2024-01-03T07:39:15Z",
        "updated_by": 1,
        "project_id": 1,
        "user_name": "Member 3",
        "user_role_id": 2,
        "user_role": "tech lead",
        "user_email": "member3@gmail.com",
        "points": [
          {
            "id": 487,
            "month": 1,
            "year": 2024,
            "user_id": 3,
            "inserted_at": "2024-01-08T01:52:43Z",
            "inserted_by": 1,
            "updated_at": "2024-01-08T02:31:39Z",
            "updated_by": 1,
            "project_id": 1,
            "actual_point": 40.53,
            "plan_point": 36.72,
            "week_of_year": 2
          },
          {
            "id": 502,
            "month": 1,
            "year": 2024,
            "user_id": 3,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 1,
            "actual_point": 0,
            "plan_point": 57.32,
            "week_of_year": 3
          }
        ]
      },
      {
        "id": 4,
        "user_id": 4,
        "inserted_at": "2023-12-26T16:24:12Z",
        "inserted_by": 1,
        "updated_at": "2023-12-26T16:24:12Z",
        "updated_by": 1,
        "project_id": 1,
        "user_name": "Member 4",
        "user_role_id": 4,
        "user_role": "brse",
        "user_email": "member4@gmail.com",
        "points": [
          {
            "id": 490,
            "month": 1,
            "year": 2024,
            "user_id": 4,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 1,
            "actual_point": 37.78,
            "plan_point": 31.06,
            "week_of_year": 2
          },
          {
            "id": 503,
            "month": 1,
            "year": 2024,
            "user_id": 4,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 1,
            "actual_point": 0,
            "plan_point": 56.39,
            "week_of_year": 3
          }
        ]
      }
    ]
  },
  {
    "id": 4,
    "name": "Project D",
    "type": "off",
    "users": [
      {
        "id": 13,
        "user_id": 1,
        "inserted_at": "2023-12-26T16:24:12Z",
        "inserted_by": 1,
        "updated_at": "2023-12-26T16:24:12Z",
        "updated_by": 1,
        "project_id": 4,
        "user_name": "Tien Tran",
        "user_role_id": 1,
        "user_role": "manager",
        "user_email": "admin@gmail.com",
        "points": [
          {
            "id": 498,
            "month": 1,
            "year": 2024,
            "user_id": 1,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 4,
            "actual_point": 59.75,
            "plan_point": 35.11,
            "week_of_year": 2
          },
          {
            "id": 512,
            "month": 1,
            "year": 2024,
            "user_id": 1,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 4,
            "actual_point": 0,
            "plan_point": 51.6,
            "week_of_year": 3
          }
        ]
      },
      {
        "id": 14,
        "user_id": 2,
        "inserted_at": "2023-12-26T16:24:12Z",
        "inserted_by": 1,
        "updated_at": "2023-12-26T16:24:12Z",
        "updated_by": 1,
        "project_id": 4,
        "user_name": "Member 2",
        "user_role_id": 2,
        "user_role": "tech lead",
        "user_email": "member2@gmail.com",
        "points": [
          {
            "id": 499,
            "month": 1,
            "year": 2024,
            "user_id": 2,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 4,
            "actual_point": 46.17,
            "plan_point": 45.92,
            "week_of_year": 2
          },
          {
            "id": 513,
            "month": 1,
            "year": 2024,
            "user_id": 2,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 4,
            "actual_point": 0,
            "plan_point": 45.47,
            "week_of_year": 3
          }
        ]
      },
      {
        "id": 15,
        "user_id": 3,
        "inserted_at": "2023-12-26T16:24:12Z",
        "inserted_by": 1,
        "updated_at": "2023-12-26T16:24:12Z",
        "updated_by": 1,
        "project_id": 4,
        "user_name": "Member 3",
        "user_role_id": 3,
        "user_role": "dev",
        "user_email": "member3@gmail.com",
        "points": [
          {
            "id": 500,
            "month": 1,
            "year": 2024,
            "user_id": 3,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 4,
            "actual_point": 49.16,
            "plan_point": 53.38,
            "week_of_year": 2
          },
          {
            "id": 514,
            "month": 1,
            "year": 2024,
            "user_id": 3,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 4,
            "actual_point": 0,
            "plan_point": 35.49,
            "week_of_year": 3
          }
        ]
      },
      {
        "id": 16,
        "user_id": 4,
        "inserted_at": "2023-12-26T16:24:12Z",
        "inserted_by": 1,
        "updated_at": "2023-12-26T16:24:12Z",
        "updated_by": 1,
        "project_id": 4,
        "user_name": "Member 4",
        "user_role_id": 4,
        "user_role": "brse",
        "user_email": "member4@gmail.com",
        "points": [
          {
            "id": 501,
            "month": 1,
            "year": 2024,
            "user_id": 4,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 4,
            "actual_point": 53.76,
            "plan_point": 48.05,
            "week_of_year": 2
          },
          {
            "id": 515,
            "month": 1,
            "year": 2024,
            "user_id": 4,
            "inserted_at": "2024-01-08T02:31:39Z",
            "inserted_by": 1,
            "updated_at": null,
            "updated_by": null,
            "project_id": 4,
            "actual_point": 0,
            "plan_point": 43.56,
            "week_of_year": 3
          }
        ]
      },
      {
        "id": 48,
        "user_id": 8,
        "inserted_at": "2024-01-10T04:22:11Z",
        "inserted_by": 1,
        "updated_at": "2024-01-10T04:22:11Z",
        "updated_by": null,
        "project_id": 4,
        "user_name": "Minh",
        "user_role_id": 1,
        "user_role": "manager",
        "user_email": "msqXjs@gmail.com",
        "points": []
      },
      {
        "id": 49,
        "user_id": 6,
        "inserted_at": "2024-01-10T04:22:11Z",
        "inserted_by": 1,
        "updated_at": "2024-01-10T04:22:11Z",
        "updated_by": null,
        "project_id": 4,
        "user_name": "Huyen",
        "user_role_id": 1,
        "user_role": "manager",
        "user_email": "KFLyCe@gmail.com",
        "points": []
      }
    ]
  },

]

function NewPage() {
  const [users, setUsers] = useState([])
  const [currentInputValue, setCurrentInputValue] = useState(0);
  const [projectUsers, setProjectUsers] = useState([])
  const [projectData, setProjectData] = useState(initialProjectData)
  const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
  const headers = {
    Authorization: tokenAuth,
  };
  const fetchUsers = async () => {
    try {
      const response = await request.get('user_management/get_all', {
        headers: headers,
      });
      setUsers(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };
  const fetchProjectUsers = async () => {
    try {
      const response = await request.get(`project_point_management/project_users/get_all`, {
        headers: headers,
      });
      setProjectUsers(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  const checkedUserInProject = (project_id, user_id) => {
    const checked = projectUsers.some(projectUser => projectUser.user_id === user_id && projectUser.project_id === project_id)
    return !checked;
  }
  const handleEditPlanPoint = (projectId, userId, time, e) => {
    const inputValue = parseFloat(e.target.value) > 0 ? parseFloat(e.target.value) : 0;
    setCurrentInputValue(inputValue);
    // Clone projectData to avoid direct state modification
    const updatedProjectData = [...projectData];

    // Find the project, user, and point indexes
    const projectIndex = updatedProjectData.findIndex((project) => project.id === projectId);
    const userIndex = updatedProjectData[projectIndex].users.findIndex((user) => user.user_id === userId);
    const pointIndex = updatedProjectData[projectIndex].users[userIndex].points.findIndex(
      (point) => point.year === time.year && point.week_of_year === time.week_of_year
    );

    // Check if the point object exists, if not, create a new one
    if (pointIndex !== -1) {
      // Update the plan_point value
      updatedProjectData[projectIndex].users[userIndex].points[pointIndex].plan_point = inputValue;
    } else {
      // Point object not found, create a new one
      const newPoint = {
        year: time.year,
        week_of_year: time.week_of_year,
        plan_point: inputValue,
        // Add other properties as needed
      };

      // Push the new point object to the points array
      updatedProjectData[projectIndex].users[userIndex].points.push(newPoint);
    }

    // Update the state with the modified data
    setProjectData(updatedProjectData);
  };

  const handleEditActualPoint = (projectId, userId, time, e) => {
    const inputValue = parseFloat(e.target.value) > 0 ? parseFloat(e.target.value) : 0;
    setCurrentInputValue(inputValue);
    // Clone projectData to avoid direct state modification
    const updatedProjectData = [...projectData];

    // Find the project, user, and point indexes
    const projectIndex = updatedProjectData.findIndex((project) => project.id === projectId);
    const userIndex = updatedProjectData[projectIndex].users.findIndex((user) => user.user_id === userId);
    const pointIndex = updatedProjectData[projectIndex].users[userIndex].points.findIndex(
      (point) => point.year === time.year && point.week_of_year === time.week_of_year
    );

    // Check if the point object exists, if not, create a new one
    if (pointIndex !== -1) {
      // Update the actual_point value
      updatedProjectData[projectIndex].users[userIndex].points[pointIndex].actual_point = inputValue;
    } else {
      // Point object not found, create a new one
      const newPoint = {
        year: time.year,
        week_of_year: time.week_of_year,
        actual_point: inputValue,
        // Add other properties as needed
      };

      // Push the new point object to the points array
      updatedProjectData[projectIndex].users[userIndex].points.push(newPoint);
    }

    // Update the state with the modified data
    setProjectData(updatedProjectData);
  };

  const insertPlanPoint = async (project_id, user_id, timeData) => {
    const time = timeData.split(" - ")
    if (currentInputValue > 0) {
      const params = {
        project_id,
        user_id,
        time: time[0],
        plan_point: currentInputValue,
      }
      try {
        await request.post(`project_point_management/insert_week_point`, params, {
          headers: headers,
        });
      } catch (error) {
        console.error("Handling Data Error: ", error.message)
      }
      setCurrentInputValue(0)
    }
    else {
      console.log("Empty")
    }

  }

  const insertActualPoint = async (project_id, user_id, timeData) => {
    const time = timeData.split(" - ")
    if (currentInputValue > 0) {
      const params = {
        project_id,
        user_id,
        time: time[0],
        actual_point: currentInputValue,
      }
      try {
        await request.post(`project_point_management/insert_week_point`, params, {
          headers: headers,
        });
      } catch (error) {
        console.error("Handling Data Error: ", error.message)
      }
      setCurrentInputValue(0)
    }
    else {
      console.log("Empty")
    }

  }

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

    return total;
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

    return total;
  };

  useEffect(() => {
    fetchUsers()
    fetchProjectUsers()
  }, [])

  return (
    <div className={classes.container}>
      <table className={classes["table-project-point"]}>
        <thead>
          <tr >
            <th className={`${classes.element} ${classes.stickyColumn}`} rowSpan="2">Group</th>
            {weeksInfo.map((week, index) => (
              <th className={`${classes.element} ${classes.stickyRow}`} key={`${week.formattedWeek}-${index}`} colSpan={users.length}>{week.formattedWeek}</th>
            ))}

          </tr>
          <tr>

            {weeksInfo.map((week) => (
              users.map((user) => (
                <th className={`${classes.element} ${classes.stickyRow}`} key={`${user.id}-${week.formattedWeek}`}>{user.name}</th>
              ))
            ))}

          </tr>
        </thead>
        <tbody>
          {projectData.map((project) => (
            <tr key={project.id}>
              <td className={`${classes.element} ${classes.stickyColumn}`}>{project.name}</td>
              {
                weeksInfo.map((week) => (
                  users.map((user) => (
                    <td className={classes.element} key={`${user.id}-${week.formattedWeek}`}>
                      <input
                        type="number"
                        step={0.01}
                        className={classes.inputPoint}
                        value={projectData.find(p => p.id === project.id)?.users.find(u => u.user_id === user.id)?.points.find(point => point.week_of_year === week.time.week_of_year)?.plan_point || 0}
                        onChange={(e) => handleEditPlanPoint(project.id, user.id, week.time, e)}
                        onBlur={() => insertPlanPoint(project.id, user.id, week.formattedWeek)}
                        disabled={checkedUserInProject(project.id, user.id)}
                      />

                    </td>
                  ))
                ))
              }
            </tr>
          ))}
          <tr>
            <td className={`${classes.element} ${classes.stickyColumn} ${classes.totalPoint}`}>Personal Total (hour)</td>
            {
              weeksInfo.map((week) => (
                users.map((user) => (
                  <td className={`${classes.element} ${classes.totalPoint}`} key={`${user.id}-${week.formattedWeek}`}>
                    {renderTotalPlanPoint(user.id, week.time)}
                  </td>
                ))
              ))
            }
          </tr>

          {projectData.map((project) => (
            <tr key={project.id}>
              <td className={`${classes.element} ${classes.stickyColumn}`}>{project.name}</td>
              {
                weeksInfo.map((week) => (
                  users.map((user) => (
                    <td className={classes.element} key={`${user.id}-${week.formattedWeek}`}>
                      <input
                        className={classes.inputPoint}
                        step={0.01}
                        type="number"
                        value={projectData.find(p => p.id === project.id)?.users.find(u => u.user_id === user.id)?.points.find(point => point.week_of_year === week.time.week_of_year)?.actual_point || 0}
                        onChange={(e) => handleEditActualPoint(project.id, user.id, week.time, e)}
                        onBlur={() => insertActualPoint(project.id, user.id, week.formattedWeek)}
                        disabled={checkedUserInProject(project.id, user.id)}
                      />

                    </td>
                  ))
                ))
              }
            </tr>
          ))}
          <tr>
            <td className={`${classes.element} ${classes.stickyColumn} ${classes.totalPoint}`}>Personal Total (hour)</td>
            {
              weeksInfo.map((week) => (
                users.map((user) => (
                  <td className={`${classes.element} ${classes.totalPoint}`} key={`${user.id}-${week.formattedWeek}`}>
                    {renderTotalActualPoint(user.id, week.time)}
                  </td>
                ))
              ))
            }
          </tr>
        </tbody>
      </table>

    </div>
  );
}

export default NewPage;