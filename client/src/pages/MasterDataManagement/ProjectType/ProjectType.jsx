import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import request from '~/utils/request';
import classes from './ProjectType.module.scss';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPencil, faPlusCircle, faTrashCan } from '@fortawesome/free-solid-svg-icons';
import Swal from 'sweetalert2';
import formatDate from '~/utils/formatDate';
import ModalProjectType from './ModalProjectType/ModalProjectType';
import checkPermission from '~/utils/checkPermission';
import { getLocalItem } from '~/utils/storageHelper';
function ProjectType() {
  const path = useLocation();
  const [projectTypes, setProjectTypes] = useState([])

  const [modalAddOpen, setModalAddOpen] = useState(false);
  const [modalUpdateOpen, setModalUpdateOpen] = useState(false);
  const [modalDeleteOpen, setModalDeleteOpen] = useState(false);
  const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
  const headers = {
    Authorization: tokenAuth,
  };
  const [addFormData, setAddFormData] = useState({
    name: '',
  });
  const [updateFormData, setUpdateFormData] = useState({
    name: '',
  });
  const [projectTypeEdit, setProjectTypeEdit] = useState({
    id: '',
    name: '',
  })
  const [projectTypeIdDelete, setProjectTypeIdDelete] = useState('')

  const resetForm = () => {
    setAddFormData({
      name: ''
    });
    setProjectTypeEdit({
      name: '',
    })
    setProjectTypeIdDelete('')
  };

  const fetchProjectTypes = async () => {
    try {
      const response = await request.get('master_data_management/get_all_project_types', {
        headers: headers,
      });
      setProjectTypes(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  useEffect(() => {
    fetchProjectTypes();
  }, []);

  const handleGetInforProjectTypeUpdate = async (id) => {
    try {
      const response = await request(`master_data_management/project_type/${id}`, { headers: headers })
      setProjectTypeEdit(response.data.data)
      setUpdateFormData({
        name: response.data.data.name,
      })

    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  const handleGetInforProjectTypeDelete = async (id) => {
    try {
      const response = await request(`master_data_management/project_type/${id}`, { headers: headers })
      setProjectTypeIdDelete(response.data.data.id)
    } catch (error) {
      console.error('Error fetching data:', error);
    }

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

    const newFormData = { ...addFormData };
    newFormData[fieldName] = fieldValue;

    setAddFormData(newFormData);

  };


  //Call api post method add project_type
  const handleUpdateFormSubmit = async (e) => {
    e.preventDefault();
    const updatedProjectType = {
      project_type_id: projectTypeEdit.id,
      name: updateFormData.name,
    };
    await request
      .patch('master_data_management/update_project_type', updatedProjectType, { headers: headers })
      .then((res) => {
        const newProjectTypes = projectTypes.map(project_type => project_type.id !== res.data.data.id ? project_type : res.data.data);
        setProjectTypes(newProjectTypes);
        setModalUpdateOpen(false);
        Swal.fire({
          title: "Update Project Type Successfully",
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
    const newProjectType = {
      name: addFormData.name,
    };
    await request
      .post('/master_data_management/create_project_type', newProjectType, { headers: headers })
      .then((res) => {
        const newProjectTypes = [...projectTypes, res.data.data];
        setProjectTypes(newProjectTypes);
        setModalAddOpen(false);
        Swal.fire({
          title: "New Project Type",
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

  const handleDeleteFormSubmit = async (e) => {
    e.preventDefault();
    const deletedProjectType = {
      project_type_id: projectTypeIdDelete,
    };
    await request
      .delete('master_data_management/delete_project_type', { headers: headers, data: deletedProjectType })
      .then((res) => {
        const newProjectTypes = projectTypes.filter(project_type => project_type.id !== res.data.data.id)
        setProjectTypes(newProjectTypes)
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
        checkPermission('2') ? (
          <div className={classes.wrapper}>
            <div className={classes.actions}>
              <ul className={classes['menu-list']}>
                <li className={classes['menu-item']}>
                  <Link to="/master_data_management/project_type" className={`${path.pathname.includes('/master_data_management/project_type') ? classes.active : ''}`}>
                    Project Type
                  </Link>
                </li>

                <li className={classes['menu-item']}>
                  <Link
                    to="/master_data_management/user_role"
                    className={`${path.pathname.includes('/master_data_management/user_role') ? classes.active : ''}`}
                  >
                    User Role
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
                label="New Project Type"
                icon={<FontAwesomeIcon icon={faPlusCircle} className={classes.icon} />}
              >

              </Button>
            </div>

            {modalAddOpen && (
              <ModalProjectType
                labelTitle="Add New Project Type"
                labelButton="Add"
                resetForm={resetForm}
                setOpenModal={setModalAddOpen}
                handleFormChange={handleAddFormChange}
                handleFormSubmit={handleAddFormSubmit}
                deleteModal={false}

              />
            )}
            {modalUpdateOpen && (
              <ModalProjectType
                labelTitle="Update Project Type"
                labelButton="Update"
                projectTypeEdit={projectTypeEdit}
                openModal={modalUpdateOpen}
                resetForm={resetForm}
                setOpenModal={setModalUpdateOpen}
                handleFormChange={handleUpdateFormChange}
                handleFormSubmit={handleUpdateFormSubmit}
                deleteModal={false}

              />
            )}
            {modalDeleteOpen && (
              <ModalProjectType
                labelTitle="Delete Project Type"
                labelButton="Delete"
                resetForm={resetForm}
                setOpenModal={setModalDeleteOpen}
                handleFormSubmit={handleDeleteFormSubmit}
                deleteModal={true}
              />
            )}

            <table className={classes.tableProjectType}>
              <thead>
                <tr>
                  <th className={classes.header_project_type}>ID</th>
                  <th className={classes.header_project_type}>Name</th>
                  <th className={classes.header_project_type}>Inserted At</th>
                  <th className={classes.header_project_type}>Updated At</th>
                  <th className={classes.header_project_type}>Edit</th>
                </tr>
              </thead>
              <tbody>
                {projectTypes.map((projectType) => (
                  <tr key={projectType.id}>
                    <td className={classes.data_project_type}>{projectType.id}</td>
                    <td className={classes.data_project_type}>{projectType.name}</td>
                    <td className={classes.data_project_type}>{projectType.inserted_at ? formatDate(projectType.inserted_at) : ''}</td>
                    <td className={classes.data_project_type}>{projectType.updated_at ? formatDate(projectType.updated_at) : ''}</td>
                    <td className={classes.edit_project_type}>
                      <Button
                        onClick={() => {
                          setModalUpdateOpen(true);
                          handleGetInforProjectTypeUpdate(projectType.id);
                        }}
                        icon={<FontAwesomeIcon icon={faPencil} />}
                      />
                      <Button
                        onClick={() => {
                          setModalDeleteOpen(true);
                          handleGetInforProjectTypeDelete(projectType.id)

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

export default ProjectType;