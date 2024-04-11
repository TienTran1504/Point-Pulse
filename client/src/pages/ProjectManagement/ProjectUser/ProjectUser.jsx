import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import checkPermission from '~/utils/checkPermission';

import request from '~/utils/request';
import classes from './ProjectUser.module.scss';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBackward, faPencil, faPlusCircle, faTrashCan } from '@fortawesome/free-solid-svg-icons';
import Swal from 'sweetalert2';
import formatDate from '~/utils/formatDate';
import ModalProjectUser from './ModalProjectUser/ModalProjectUser';
import { getLocalItem } from '~/utils/storageHelper';

function ProjectUser() {
  const projectUserlNavigate = useNavigate();
  const { project_id } = useParams();
  const [projectUsers, setProjectUsers] = useState([])
  const [project, setProject] = useState({})
  const [usersOutside, setUsersOutside] = useState([])
  const [userRoles, setUserRoles] = useState([])

  const [modalAddOpen, setModalAddOpen] = useState(false);
  const [modalUpdateOpen, setModalUpdateOpen] = useState(false);
  const [modalDeleteOpen, setModalDeleteOpen] = useState(false);
  const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
  const headers = {
    Authorization: tokenAuth,
  };
  const [addFormData, setAddFormData] = useState({
    project_id: project_id,
    user_id: '',
    user_role_id: '',
  });
  const [updateFormData, setUpdateFormData] = useState({
    user_id: '',
    user_role_id: '',
  });
  const [projectUserEdit, setProjectUserEdit] = useState({
    project_id: project_id,
    user_name: '',
    user_id: '',
    user_role: '',
    user_role_id: '',
  })
  const [projectUserIdDelete, setProjectUserIdDelete] = useState('')

  const resetForm = () => {
    setAddFormData({
      project_id: project_id,
      user_id: '',
      user_role_id: '',
    });
    setProjectUserEdit({
      project_id: project_id,
      user_name: '',
      user_id: '',
      user_role: '',
      user_role_id: '',
    })
    setProjectUserIdDelete('')
  };

  const fetchProjectUsers = async () => {
    try {
      const response = await request.get(`project_management/users/${project_id}`, {
        headers: headers,
      });
      setProjectUsers(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };
  const fetchProject = async () => {
    try {
      const response = await request.get(`project_management/${project_id}`, {
        headers: headers,
      });
      setProject(response.data.data.project);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  const fetchUsersOutsideProject = async () => {
    try {
      const response = await request.get(`project_management/users_outside/${project_id}`, {
        headers: headers,
      });
      setUsersOutside(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  const fetchUserRoles = async () => {
    try {
      const response = await request.get(`project_management/role/get_all_roles`, {
        headers: headers,
      });
      setUserRoles(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  useEffect(() => {
    fetchProjectUsers();
    fetchUserRoles();
    fetchProject();
  }, []);
  useEffect(() => {
    fetchUsersOutsideProject();
  }, [projectUsers])
  const handleGetInforProjectUserUpdate = async (id) => {
    const projectUserInfo = {
      project_id: project_id,
      user_id: id
    }
    try {
      const response = await request.post(`project_management/project_user/get_info`, projectUserInfo, { headers: headers })
      await Promise.all([
        setProjectUserEdit({
          project_id: project_id,
          user_name: response.data.data.user_name,
          user_id: response.data.data.user_id,
          user_role: response.data.data.user_role,
          user_role_id: response.data.data.user_role_id,
        }),
        setUpdateFormData({
          user_id: response.data.data.user_id,
          user_role_id: response.data.data.user_role_id,
        }),
      ]);

    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  const handleGetInforProjectUserDelete = async (id) => {
    setProjectUserIdDelete(id);
  }

  const handleUpdateFormChange = (e) => {
    // e.preventDefault();

    const fieldName = e.target.getAttribute('name');
    const fieldValue = e.target.value;


    const newFormData = { ...updateFormData };
    newFormData[fieldName] = fieldValue;


    setUpdateFormData(newFormData);

  };

  const handleAddFormChange = (e) => {

    const fieldName = e.target.getAttribute('name');
    const fieldValue = e.target.value;

    // Kiểm tra xem trường có thuộc tính multiple không
    const isMultiple = e.target.multiple;

    let newFormData = { ...addFormData };

    // Xử lý giá trị khi trường có thuộc tính multiple
    if (isMultiple) {
      const selectedOptions = Array.from(e.target.selectedOptions, option => option.value);
      newFormData[fieldName] = selectedOptions;
    } else {
      newFormData[fieldName] = fieldValue;
    }

    setAddFormData(newFormData);

  };


  //Call api post method add project_type
  const handleUpdateFormSubmit = async (e) => {
    e.preventDefault();
    const updatedProjectUser = {
      project_id: project_id,
      user_id: updateFormData.user_id,
      user_role_id: updateFormData.user_role_id,
    };
    await request
      .patch('project_management/project_users/update', updatedProjectUser, { headers: headers })
      .then((res) => {
        const newProjectUsers = projectUsers.map(projectUser => projectUser.id !== res.data.data.id ? projectUser : res.data.data);
        setProjectUsers(newProjectUsers);

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
        console.log(err);
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: 'Please Try Again',
          width: '50rem',
        });
      });

  };


  // //Call api post method add project_type
  const handleAddFormSubmit = async (e) => {
    e.preventDefault();
    let newProjectUsers = projectUsers
    for (let i = 0; i < addFormData.user_id.length; i++) {
      const newProjectUser = {
        project_id: project_id,
        user_id: addFormData.user_id[i],
        user_role_id: addFormData.user_role_id,
      };
      if (newProjectUser.user_id) {
        await request
          .post('project_management/project_users/create', newProjectUser, { headers: headers })
          // eslint-disable-next-line no-loop-func
          .then((res) => {
            const filterUsers = usersOutside.filter(user => user.id !== res.data.data.user_id)
            newProjectUsers = [...newProjectUsers, res.data.data];
            setUsersOutside(filterUsers)
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
      }
    }
    setProjectUsers(newProjectUsers);

    setModalAddOpen(false);
    Swal.fire({
      title: "Add New Member To Project Successfully",
      icon: 'success',
      confirmButtonText: 'Done',
      width: '50rem',
    });
    resetForm();

  };

  const handleDeleteFormSubmit = async (e) => {
    e.preventDefault();
    const deletedProjectUser = {
      project_id: parseInt(project_id),
      user_id: projectUserIdDelete,
    };
    await request
      .delete('project_management/project_users/delete', { headers: headers, data: deletedProjectUser })
      .then((res) => {
        const newProjectUsers = projectUsers.filter(project_user => project_user.user_id !== deletedProjectUser.user_id)
        setProjectUsers(newProjectUsers)
        setModalDeleteOpen(false);
        Swal.fire({
          title: "Delete Successfully",
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
        checkPermission('3') ? (
          <div className={classes.wrapper}>
            <div className={classes.header_wrapper}>
              <h2>{project.name}</h2>
              <div className={classes['button_wrapper']}>
                {usersOutside.length > 0 ? (
                  <Button
                    className={classes['button_add']}
                    onClick={() => {
                      setModalAddOpen(true);
                    }}
                    label="New Member"
                    icon={<FontAwesomeIcon icon={faPlusCircle} className={classes.icon} />}
                  >

                  </Button>
                ) : (<Button
                  className={classes['button_add']}
                  onClick={() => {
                    setModalAddOpen(true);
                  }}
                  label="New Member"
                  disabled
                  icon={<FontAwesomeIcon icon={faPlusCircle} className={classes.icon} />}
                >

                </Button>)}

              </div>
            </div>
            {modalAddOpen && (
              <ModalProjectUser
                labelTitle="Add New Member"
                labelButton="Add"
                resetForm={resetForm}
                users={usersOutside}
                userRoles={userRoles}
                setOpenModal={setModalAddOpen}
                handleFormChange={handleAddFormChange}
                handleFormSubmit={handleAddFormSubmit}
                deleteModal={false}

              />
            )}
            {modalUpdateOpen && (
              <ModalProjectUser
                labelTitle="Update Member's Role"
                labelButton="Role"
                projectUserEdit={projectUserEdit}
                userRoles={userRoles}
                openModal={modalUpdateOpen}
                resetForm={resetForm}
                setOpenModal={setModalUpdateOpen}
                handleFormChange={handleUpdateFormChange}
                handleFormSubmit={handleUpdateFormSubmit}
                deleteModal={false}

              />
            )}
            {modalDeleteOpen && (
              <ModalProjectUser
                labelTitle="Delete Member In Project"
                labelButton="Delete"
                resetForm={resetForm}
                setOpenModal={setModalDeleteOpen}
                handleFormSubmit={handleDeleteFormSubmit}
                deleteModal={true}
              />
            )}

            <table className={classes.tableProjectUser}>
              <thead>
                <tr>
                  <th className={classes.header_project_user}>User ID</th>
                  <th className={classes.header_project_user}>Name</th>
                  <th className={classes.header_project_user}>Email</th>
                  <th className={classes.header_project_user}>Role</th>
                  <th className={classes.header_project_user_date}>Inserted At</th>
                  <th className={classes.header_project_user_date}>Updated At</th>
                  <th className={classes.header_project_user}>Edit</th>
                </tr>
              </thead>
              <tbody>
                {projectUsers.map((projectUser) => (
                  <tr key={projectUser.id}>
                    <td className={classes.data_project_user}>{projectUser.user_id}</td>
                    <td className={classes.data_project_user}>{projectUser.user_name}</td>
                    <td className={classes.data_project_user}>{projectUser.user_email}</td>
                    <td className={classes.data_project_user}>{projectUser.user_role}</td>
                    <td className={classes.data_project_user}>{projectUser.inserted_at ? formatDate(projectUser.inserted_at) : ''}</td>
                    <td className={classes.data_project_user}>{projectUser.updated_at ? formatDate(projectUser.updated_at) : ''}</td>
                    <td className={classes.data_project_user_edit}>
                      <Button
                        onClick={() => {
                          setModalUpdateOpen(true);
                          handleGetInforProjectUserUpdate(projectUser.user_id);
                          return null;
                        }}
                        icon={<FontAwesomeIcon icon={faPencil} />}
                      />
                      <Button
                        onClick={() => {
                          setModalDeleteOpen(true);
                          handleGetInforProjectUserDelete(projectUser.user_id)
                          return null;

                        }}

                        icon={<FontAwesomeIcon icon={faTrashCan} />}
                      />
                    </td>

                  </tr>
                ))}
              </tbody>
            </table>

            <div className={classes['button-wrapper']}>
              <Button
                className={classes['button_add']}
                onClick={() => {
                  projectUserlNavigate('/project_management')
                }}
                label="Back"
                icon={<FontAwesomeIcon icon={faBackward} className={classes.icon} />}
              >

              </Button>
            </div>
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

export default ProjectUser;