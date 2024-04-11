import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import request from '~/utils/request';
import classes from './UserManagement.module.scss';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPencil, faTrashCan, faPlusCircle } from '@fortawesome/free-solid-svg-icons';
import Modal from './Modal/Modal';
import Swal from 'sweetalert2';
import formatDate from '~/utils/formatDate';
import checkPermission from '~/utils/checkPermission';
import { getLocalItem } from '~/utils/storageHelper';

function UserManagement() {
  const path = useLocation();
  const [users, setUsers] = useState([])
  const [modalAddOpen, setModalAddOpen] = useState(false);
  const [modalUpdateOpen, setModalUpdateOpen] = useState(false);
  const [modalDeleteOpen, setModalDeleteOpen] = useState(false);
  const [addFormData, setAddFormData] = useState({
    email: '',
    password: '',
    name: '',
    weight: '',
    permissions: [],
  });
  const [updateFormData, setUpdateFormData] = useState({
    weight: '',
    permissions: [],
  });
  const [userEdit, setUserEdit] = useState({
    id: '',
    email: '',
    password: '',
    name: '',
    weight: '',
    permissions: [],
  })
  const [userIdDelete, setUserIdDelete] = useState('')

  const resetForm = () => {
    setAddFormData({
      email: '',
      password: '',
      name: '',
      weight: '',
      permissions: [],
    });
    setUserEdit({
      email: '',
      password: '',
      name: '',
      weight: '',
      permissions: [],
    })
    setUserIdDelete('')
  };
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
      console.error('Error fetching users:', error);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleGetInforUserUpdate = async (id) => {
    try {
      const response = await request(`user_management/user/${id}`, { headers: headers })
      setUserEdit(response.data.data)
      setUpdateFormData({
        weight: response.data.data.weight,
        permissions: response.data.data.permissions
      })

    } catch (error) {
      console.error('Error get user:', error);
    }

  }
  const handleGetInforUserDelete = async (id) => {
    try {
      const response = await request(`user_management/user/${id}`, { headers: headers })
      setUserIdDelete(response.data.data.id)
    } catch (error) {
      console.error('Error get user:', error);
    }

  }

  const handleUpdateFormChange = (e) => {
    // e.preventDefault();
    const fieldType = e.target.getAttribute('type')
    if (fieldType === 'checkbox') {
      const fieldValue = parseInt(e.target.value, 10);
      const isChecked = e.target.checked;


      // Lấy danh sách giá trị đã được chọn từ state hoặc khởi tạo nếu chưa có
      const selectedValues = updateFormData.permissions || [];

      // Nếu ô input được checked, thêm giá trị vào danh sách, ngược lại loại bỏ giá trị
      const updatedValues = isChecked
        ? [...selectedValues, fieldValue]
        : selectedValues.filter((value) => value !== fieldValue);

      const newFormData = { ...updateFormData, permissions: updatedValues };
      setUpdateFormData(newFormData);
    }
    else {
      const fieldName = e.target.getAttribute('name');
      if (fieldName === 'weight') {
        const fieldValue = e.target.value;

        const newFormData = { ...updateFormData };
        newFormData[fieldName] = fieldValue;

        setUpdateFormData(newFormData);
      }

    }

  };

  const handleAddFormChange = (e) => {
    // e.preventDefault();
    const fieldType = e.target.getAttribute('type')
    if (fieldType === 'checkbox') {
      const fieldValue = parseInt(e.target.value, 10);
      const isChecked = e.target.checked;


      // Lấy danh sách giá trị đã được chọn từ state hoặc khởi tạo nếu chưa có
      const selectedValues = addFormData.permissions || [];

      // Nếu ô input được checked, thêm giá trị vào danh sách, ngược lại loại bỏ giá trị
      const updatedValues = isChecked
        ? [...selectedValues, fieldValue]
        : selectedValues.filter((value) => value !== fieldValue);

      const newFormData = { ...addFormData, permissions: updatedValues };
      setAddFormData(newFormData);
    }
    else {
      const fieldName = e.target.getAttribute('name');

      const fieldValue = e.target.value;

      const newFormData = { ...addFormData };
      newFormData[fieldName] = fieldValue;

      setAddFormData(newFormData);
    }

  };


  //Call api post method add user
  const handleUpdateFormSubmit = async (e) => {
    e.preventDefault();
    const updatedUser = {
      user_id: userEdit.id,
      weight: parseFloat(updateFormData.weight),
      permissions: updateFormData.permissions,
    };

    if (!isNaN(updateFormData.weight) && updatedUser.weight <= 1.0 && updatedUser.weight > 0.0) {
      // setIsLoading(true);
      await request
        .patch('/user_management/update', updatedUser, { headers: headers })
        .then((res) => {
          const newUsers = users.map(user => user.id !== res.data.data.id ? user : res.data.data);
          setUsers(newUsers);
          setModalUpdateOpen(false);
          Swal.fire({
            title: "Update User Successfully",
            icon: "success",
            confirmButtonText: 'Done',
            width: '50rem',
          });
          resetForm();
        })
        .catch((err) => {
          Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Please Try Again',
            width: '50rem',
          });
        });
      // setIsLoading(false);
    } else {
      Swal.fire({
        icon: 'error',
        title: 'Erro',
        text: 'Invalid Weight',
        width: '50rem',
      });
    }
  };

  //Call api post method add user
  const handleAddFormSubmit = async (e) => {
    e.preventDefault();
    const newUser = {
      email: addFormData.email,
      password: addFormData.password,
      name: addFormData.name,
      weight: parseFloat(addFormData.weight),
      permissions: addFormData.permissions,
    };
    if (!isNaN(addFormData.weight) && newUser.weight <= 1.0 && newUser.weight > 0.0) {
      // setIsLoading(true);
      await request
        .post('/user_management/create', newUser, { headers: headers })
        .then((res) => {
          const newUsers = [...users, res.data.data];
          setUsers(newUsers);
          setModalAddOpen(false);
          Swal.fire({
            title: "Add New User Successfully",
            icon: "success",
            confirmButtonText: 'Done',
            width: '50rem',
          });
          resetForm();
        })
        .catch((err) => {
          Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Please Try Again',
            width: '50rem',
          });
        });
      // setIsLoading(false);
    } else {
      Swal.fire({
        icon: 'error',
        title: 'Lỗi',
        text: 'Invalid Weight',
        width: '50rem',
      });
    }
  };

  const handleDeleteFormSubmit = async (e) => {
    e.preventDefault();
    const deletedUser = {
      user_id: userIdDelete,
    };
    await request
      .delete('/user_management/delete', { headers: headers, data: deletedUser })
      .then((res) => {
        const newUsers = users.filter(user => user.id !== res.data.data.id)
        setUsers(newUsers)
        setModalDeleteOpen(false);
        Swal.fire({
          title: "Delete User Successfully",
          icon: "success",
          confirmButtonText: 'Done',
          width: '50rem',
        });
        resetForm();
      })
      .catch((err) => {
        console.log(err);
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: 'Please Try Again',
          width: '50rem',
        });
      });
  };




  return (
    <div>
      {
        checkPermission('1') ? (
          <div className={classes.wrapper}>
            <div className={classes.actions}>
              <ul className={classes['menu-list']}>
                <li className={classes['menu-item']}>
                  <Link to="/user_management" className={`${path.pathname.includes('/user_management') ? classes.active : ''}`}>
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
            <div className={classes['button_wrapper']}>
              <Button
                className={classes['button_add']}
                onClick={() => {
                  setModalAddOpen(true);
                }}
                label="New User"
                icon={<FontAwesomeIcon icon={faPlusCircle} className={classes.icon} />}
              >

              </Button>
            </div>
            {modalAddOpen && (
              <Modal
                labelTitle="Add New User In System"
                labelButton="Add"
                resetForm={resetForm}
                setOpenModal={setModalAddOpen}
                handleFormChange={handleAddFormChange}
                handleFormSubmit={handleAddFormSubmit}
                deleteModal={false}

              />
            )}
            {modalUpdateOpen && (
              <Modal
                labelTitle="Update User Information"
                labelButton="Update"
                userEdit={userEdit}
                openModal={modalUpdateOpen}
                resetForm={resetForm}
                setOpenModal={setModalUpdateOpen}
                handleFormChange={handleUpdateFormChange}
                handleFormSubmit={handleUpdateFormSubmit}
                deleteModal={false}

              />
            )}
            {modalDeleteOpen && (
              <Modal
                labelTitle="Delete User In System"
                labelButton="Delete"
                resetForm={resetForm}
                setOpenModal={setModalDeleteOpen}
                handleFormSubmit={handleDeleteFormSubmit}
                deleteModal={true}
              />
            )}
            <table className={classes['tableUser']}>
              <thead>
                <tr>
                  <th className={classes.header_user}>ID</th>
                  <th className={classes.header_user}>Email</th>
                  <th className={classes.header_user}>Name</th>
                  <th className={classes.header_user}>Weight</th>
                  <th className={classes.header_user_date}>Inserted At</th>
                  <th className={classes.header_user_date}>Updated At</th>
                  <th className={classes.header_user_edit}>Edit</th>
                </tr>
              </thead>
              <tbody>
                {users.map((user) => (
                  <tr key={user.id}>
                    <td className={classes.data_user}>{user.id}</td>
                    <td className={classes.data_user}>{user.email}</td>
                    <td className={classes.data_user}>{user.name}</td>
                    <td className={classes.data_user}>{user.weight}</td>
                    <td className={classes.data_user}>{user.inserted_at ? formatDate(user.inserted_at) : ''}</td>
                    <td className={classes.data_user}>{user.updated_at ? formatDate(user.updated_at) : ''}</td>
                    <td className={classes.edit_user}>
                      <Button
                        onClick={() => {
                          setModalUpdateOpen(true);
                          handleGetInforUserUpdate(user.id);
                        }}
                        icon={<FontAwesomeIcon icon={faPencil} />}
                      />
                      <Button
                        onClick={() => {
                          setModalDeleteOpen(true);
                          handleGetInforUserDelete(user.id)

                        }}

                        icon={<FontAwesomeIcon icon={faTrashCan} />}
                      />
                    </td>

                  </tr>
                ))}
              </tbody>
            </table>
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

export default UserManagement;