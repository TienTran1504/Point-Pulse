import classes from './UserWorkPoint.module.scss'
import { Link, useLocation } from "react-router-dom";
import { useEffect, useState } from 'react';
import Calendar from 'react-calendar';
import 'react-calendar/dist/Calendar.css';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPencil, faPlusCircle } from "@fortawesome/free-solid-svg-icons";
import Button from "~/components/Layout/DefaultLayout/Header/Button";
import request from "~/utils/request";
import ModalPoint from "./ModalPoint/ModalPoint";
import Swal from "sweetalert2";
import formatDate from "~/utils/formatDate";
import { Backdrop, CircularProgress } from "@mui/material";
import checkPermission from '~/utils/checkPermission';
import { getLocalItem } from '~/utils/storageHelper';
const convertTime = (originalDate) => {
  const year = originalDate.getFullYear();
  const month = ("0" + (originalDate.getMonth() + 1)).slice(-2); // Thêm 1 vì tháng bắt đầu từ 0
  const day = ("0" + originalDate.getDate()).slice(-2);

  // Tạo chuỗi ngày tháng năm theo định dạng "YYYY-MM-DD"
  const formattedDate = year + "-" + month + "-" + day;
  return formattedDate;
}

const generateTimeRange = (start_time, end_time) => {
  const result = [];
  const startDate = new Date(start_time);
  const endDate = new Date(end_time);

  while (startDate <= endDate) {
    result.push(convertTime(startDate));
    startDate.setDate(startDate.getDate() + 7);
    if (startDate > endDate) {
      result.push(convertTime(endDate));
    }
  }

  return result;
}

function UserWorkPoint() {
  const path = useLocation();
  const [loading, setLoading] = useState(false)
  const [users, setUsers] = useState([])
  const [modalAddOpen, setModalAddOpen] = useState(false);
  const [modalUpdateOpen, setModalUpdateOpen] = useState(false);
  const [userWorkPoints, setUserWorkPoints] = useState([])
  const [dataUsers, setDataUsers] = useState([])
  const [value, onChange] = useState(new Date());
  const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
  const headers = {
    Authorization: tokenAuth,
  };
  const [pointEdit, setPointEdit] = useState({
    id: '',
    time: '',
    user_id: '',
    work_point: '',
    inserted_by: '',
    updated_by: ''
  })
  const [userInfo, setUserInfo] = useState({
    user_id: '',
    time: '',
  })
  const [createUserWorkPoint, setCreateUserWorkPoint] = useState({
    from_date: '',
    to_date: '',
    work_point: ''
  })
  const [editUserWorkPoint, setEditUserWorkPoint] = useState({
    work_point: ''
  })

  const resetForm = () => {
    setCreateUserWorkPoint({
      user_id: '',
      time: '',
      work_point: '',
      from_date: '',
      to_date: '',
    });
    setEditUserWorkPoint({
      user_id: '',
      time: '',
      work_point: ''
    })
  };



  const fetchUsers = async () => {
    try {
      const response = await request.get('user_management/get_all', {
        headers: headers,
      });

      setUsers(response.data.data);
    } catch (error) {
      console.error('Error fetching users:', error);
    }
  };
  const fetchUserWorkPoints = async () => {

    const time = convertTime(new Date(value))
    try {
      const response = await request.post('user_management/get_all_user_work_points_by_week', { time: time }, {
        headers: headers,
      });
      setUserWorkPoints(response.data.data);
    } catch (error) {
      console.error('Error fetching user work points:', error);
    }
  }
  const handleData = async () => {
    const newData = users.map((user) => {
      const foundedWorkPoint = userWorkPoints.find((point) => point.user_id === user.id)
      return {
        ...user,
        work_point: foundedWorkPoint?.work_point || 0,
        year: foundedWorkPoint?.year || null,
        week_of_year: foundedWorkPoint?.week_of_year || null,
        month: foundedWorkPoint?.month || null,
        work_point_inserted_at: foundedWorkPoint?.inserted_at || null,
        work_point_updated_at: foundedWorkPoint?.updated_at || null,
        work_point_inserted_by: foundedWorkPoint?.inserted_by || null,
        work_point_updated_by: foundedWorkPoint?.updated_by || null,
      }
    })
    setDataUsers(newData)
  }
  useEffect(() => {
    fetchUsers();
    fetchUserWorkPoints();
  }, [value])


  useEffect(() => {
    handleData()
  }, [users, userWorkPoints])

  const handleGetInforUserWorkPointUpdate = async (user_id) => {
    const params = {
      user_id: user_id,
      time: convertTime(new Date(value))
    }
    try {
      const response = await request.post(`user_management/get_user_work_point_by_week`, params, { headers: headers })
      setPointEdit(response.data.data)
    } catch (error) {
      console.error('Error get user:', error);
    }

  }

  const handleGetInforUserWorkPointAdd = async (user_id) => {
    const time = convertTime(new Date(value))
    setUserInfo({
      user_id: user_id,
      time: time
    })
  }

  const handleAddFormChange = (e) => {
    // e.preventDefault();
    const fieldName = e.target.getAttribute('name');

    const fieldValue = e.target.value;

    const newFormData = { ...createUserWorkPoint };
    newFormData[fieldName] = fieldValue;

    setCreateUserWorkPoint(newFormData);
  };

  const handleUpdateFormChange = (e) => {
    // e.preventDefault();
    const fieldName = e.target.getAttribute('name');
    const fieldValue = e.target.value;

    const newFormData = { ...editUserWorkPoint };
    newFormData[fieldName] = fieldValue;

    setEditUserWorkPoint(newFormData);

  }


  //Call api post method add user
  const handleAddFormSubmit = async (e) => {
    e.preventDefault();
    const newWorkPoint = {
      user_id: userInfo.user_id,
      time: userInfo.time,
      from_date: createUserWorkPoint?.from_date,
      to_date: createUserWorkPoint?.to_date,
      work_point: parseFloat(createUserWorkPoint.work_point),
    };
    setLoading(true)

    if (!newWorkPoint.from_date && !newWorkPoint.to_date) {
      await request
        .post('user_management/insert_user_work_point', newWorkPoint, { headers: headers })
        .then((res) => {
          const newUserWorkPoints = [...userWorkPoints, res.data.data];
          setUserWorkPoints(newUserWorkPoints);
          setModalAddOpen(false);
          Swal.fire({
            title: "Thêm giờ làm việc nhân viên thành công",
            icon: "success",
            confirmButtonText: 'Hoàn tất',
            width: '50rem',
          });
          resetForm();
        })
        .catch((err) => {
          console.log(err);
          Swal.fire({
            icon: 'error',
            title: 'Đã xảy ra lỗi trong quá trình tạo work point cho người dùng',
            text: 'Vui lòng  hãy thử lại',
            width: '50rem',
          });
        });
    }
    else {
      if (!newWorkPoint.from_date || !newWorkPoint.to_date) {
        Swal.fire({
          title: "Vui lòng chọn khoảng thời gian hợp lệ",
          icon: 'warning',
          confirmButtonText: 'Hoàn tất',
          width: '50rem',
        });
      }
      else {
        const start_time = convertTime(new Date(newWorkPoint.from_date))
        const end_time = convertTime(new Date(newWorkPoint.to_date))


        const timeRange = generateTimeRange(start_time, end_time)
        for (let i = 0; i < timeRange.length; i++) {
          const workPoint = {
            user_id: userInfo.user_id,
            time: timeRange[i],
            work_point: parseFloat(createUserWorkPoint.work_point),
          }
          await request
            .post('user_management/insert_user_work_point', workPoint, { headers: headers })
            .then((res) => {
            })
            .catch((err) => {
              console.log(err);
              // Swal.fire({
              //     icon: 'error',
              //     title: 'Đã xảy ra lỗi trong quá trình tạo work point cho người dùng',
              //     text: 'Vui lòng  hãy thử lại',
              //     width: '50rem',
              // });
            });
        }
        setModalAddOpen(false);

        fetchUserWorkPoints()
        resetForm();
      }
    }
    setLoading(false)

  };

  //Call api post method add user
  const handleUpdateFormSubmit = async (e) => {
    e.preventDefault();
    const updatedWorkPoint = {
      user_id: pointEdit.user_id,
      time: convertTime(new Date(value)),
      work_point: parseFloat(editUserWorkPoint.work_point) || pointEdit.work_point,
    };

    await request
      .patch('/user_management/update_user_work_point', updatedWorkPoint, { headers: headers })
      .then((res) => {
        const newData = dataUsers.map((user) => {
          if (res.data.data.user_id === user.id) {
            return {
              ...user,
              work_point: res.data.data.work_point,
              year: res.data.data.year,
              week_of_year: res.data.data.week_of_year,
              month: res.data.data.month,
              work_point_inserted_at: res.data.data.inserted_at,
              work_point_updated_at: res.data.data.updated_at,
              work_point_inserted_by: res.data.data.inserted_by,
              work_point_updated_by: res.data.data.updated_by,
            }
          } else {
            return {
              ...user,
            }
          }

        })
        setDataUsers(newData)

        setModalUpdateOpen(false);
        Swal.fire({
          title: "Cập nhật thành công",
          icon: "success",
          confirmButtonText: 'Hoàn tất',
          width: '50rem',
        });
        resetForm();
      })
      .catch((err) => {
        console.log(err);
        Swal.fire({
          icon: 'error',
          title: 'Đã xảy ra lỗi trong quá trình cập nhật người dùng',
          text: 'Vui long hãy thử lại',
          width: '50rem',
        });
      });

  }

  return (
    <div>
      {
        checkPermission('1') ? (
          <>
            <div className={classes.wrapper}>
              <div className={classes.actions}>
                <ul className={classes['menu-list']}>
                  <li className={classes['menu-item']}>
                    <Link to="/user_management" className={`${path.pathname === '/user_management' ? classes.active : ''}`}>
                      User Management
                    </Link>
                  </li>

                  <li className={classes['menu-item']}>
                    <Link
                      to="/user_management/user_work_point"
                      className={`${path.pathname.includes('/user_management/user_work_point') ? classes.active : ''}`}
                    >
                      User Work Point
                    </Link>
                  </li>

                </ul>
              </div>
              {modalAddOpen && (
                <ModalPoint
                  labelTitle="Insert User's Work Points"
                  labelButton="Insert"
                  resetForm={resetForm}
                  setOpenModal={setModalAddOpen}
                  handleFormChange={handleAddFormChange}
                  handleFormSubmit={handleAddFormSubmit}
                  createUserWorkPoint={createUserWorkPoint}
                  workPoint={true}
                  deleteModal={false}
                />
              )}
              {modalUpdateOpen && (
                <ModalPoint
                  labelTitle="Update User's Work Point"
                  labelButton="Update"
                  pointEdit={pointEdit}
                  openModal={modalUpdateOpen}
                  resetForm={resetForm}
                  setOpenModal={setModalUpdateOpen}
                  handleFormChange={handleUpdateFormChange}
                  handleFormSubmit={handleUpdateFormSubmit}
                  workPoint={true}
                  deleteModal={false}

                />
              )}
              <div className={classes.calendar}>
                <Calendar onChange={onChange} value={value} />
              </div>
              <div className={classes.clear}></div>
              <div>
                <table className={classes.tableWorkPoint}>
                  <thead>
                    <tr>
                      <th className={classes.header_work_point}>ID</th>
                      <th className={classes.header_work_point}>Email</th>
                      <th className={classes.header_work_point}>Name</th>
                      <th className={classes.header_work_point}>Work Point</th>
                      {/* <th className={classes.header_work_date}>Inserted at</th>
                      <th className={classes.header_work_date}>Updated at</th> */}
                      <th className={classes.header_edit_work}>Edit</th>
                    </tr>
                  </thead>
                  <tbody>
                    {dataUsers.map((user) => (
                      <tr key={user.id}>
                        <td className={classes.data_work_point}>{user.id}</td>
                        <td className={classes.data_work_point}>{user.email}</td>
                        <td className={classes.data_work_point}>{user.name}</td>
                        <td className={classes.data_work_point}>{user.work_point}</td>
                        {/* <td className={classes.data_work_point}>{user.work_point_inserted_at ? formatDate(user.work_point_inserted_at) : ''}</td>
                        <td className={classes.data_work_point}>{user.work_point_updated_at ? formatDate(user.work_point_updated_at) : ''}</td> */}
                        <td className={classes.data_work_point}>
                          {user.week_of_year ? (
                            <Button
                              onClick={() => {
                                setModalUpdateOpen(true);
                                handleGetInforUserWorkPointUpdate(user.id)
                              }}
                              icon={<FontAwesomeIcon icon={faPencil} />}
                            />
                          ) : (
                            <Button
                              onClick={() => {
                                setModalAddOpen(true);
                                handleGetInforUserWorkPointAdd(user.id)
                              }}

                              icon={<FontAwesomeIcon icon={faPlusCircle} />}
                            />
                          )}


                        </td>

                      </tr>
                    ))}
                  </tbody>
                </table>
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

export default UserWorkPoint;