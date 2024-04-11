import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import checkPermission from '~/utils/checkPermission';
import request from '~/utils/request';
import classes from './Project.module.scss';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faEye, faPencil, faPlusCircle, faTrashCan } from '@fortawesome/free-solid-svg-icons';
import Swal from 'sweetalert2';
import formatDate from '~/utils/formatDate';
import ModalProject from './ModalProject/ModalProject';
import { getLocalItem } from '~/utils/storageHelper';

function Project() {
  const [projects, setProjects] = useState([])
  const [projectTypes, setProjectTypes] = useState([])
  const projectUserNavigate = useNavigate();
  const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
  const headers = {
    Authorization: tokenAuth,
  };

  const [modalAddOpen, setModalAddOpen] = useState(false);
  const [modalUpdateOpen, setModalUpdateOpen] = useState(false);
  const [modalDeleteOpen, setModalDeleteOpen] = useState(false);

  const [addFormData, setAddFormData] = useState({
    name: '',
    type_id: '',
    start_date: '',
    end_date: '',
    locked: false,
  });
  const [updateFormData, setUpdateFormData] = useState({
    name: '',
    type_id: '',
    start_date: '',
    end_date: '',
    locked: '',
  });
  const [projectEdit, setProjectEdit] = useState({
    id: '',
    name: '',
    type_id: '',
    start_date: '',
    end_date: '',
    locked: '',
  })
  const [projectIdDelete, setProjectIdDelete] = useState('')

  const resetForm = () => {
    setAddFormData({
      name: '',
      type_id: '',
      start_date: '',
      end_date: '',
      locked: false,
    });
    setProjectEdit({
      name: '',
      type_id: '',
      start_date: '',
      end_date: '',
      locked: '',
    })
    setProjectIdDelete('')
  };

  const fetchProjects = async () => {
    try {
      const response = await request.get('project_management/get_all', {
        headers: headers,
      });
      setProjects(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };
  const fetchProjectTypes = async () => {
    try {
      const response = await request.get('project_management/type/get_all_project_types', {
        headers: headers,
      });
      setProjectTypes(response.data.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }



  useEffect(() => {
    fetchProjects();
    fetchProjectTypes();
  }, []);

  const handleGetInforProjectUpdate = async (id) => {
    try {
      const response = await request(`project_management/${id}`, { headers: headers })

      setProjectEdit(response.data.data.project)
      setUpdateFormData({
        name: response.data.data.project.name,
        type_id: response.data.data.project.type_id,
        start_date: response.data.data.project.start_date,
        end_date: response.data.data.project.end_date,
        locked: response.data.data.project.locked,
      })

    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }
  const handleGetInforProjectDelete = async (id) => {
    try {
      const response = await request(`project_management/${id}`, { headers: headers })
      setProjectIdDelete(response.data.data.project.id)
    } catch (error) {
      console.error('Error fetching data:', error);
    }

  }

  const handleUpdateFormChange = (e) => {
    // e.preventDefault();
    const fieldType = e.target.getAttribute('type')
    const fieldName = e.target.getAttribute('name');
    if (fieldType === 'checkbox') {
      const isChecked = e.target.checked;
      const newFormData = { ...updateFormData };
      newFormData[fieldName] = isChecked;

      setUpdateFormData(newFormData);
    } else {

      const fieldValue = e.target.value;

      const newFormData = { ...updateFormData };
      newFormData[fieldName] = fieldValue;

      setUpdateFormData(newFormData);
    }

  };

  const handleAddFormChange = (e) => {
    const fieldType = e.target.getAttribute('type')
    const fieldName = e.target.getAttribute('name');

    if (fieldType === 'checkbox') {
      const isChecked = e.target.checked;


      const newFormData = { ...addFormData };
      newFormData[fieldName] = isChecked;

      setAddFormData(newFormData);
    } else {

      const fieldValue = e.target.value;

      const newFormData = { ...addFormData };
      newFormData[fieldName] = fieldValue;

      setAddFormData(newFormData);
    }

  };


  //Call api post method add project_type
  const handleUpdateFormSubmit = async (e) => {
    e.preventDefault();
    const updatedProject = {
      project_id: projectEdit.id,
      name: updateFormData.name,
      type_id: updateFormData.type_id,
      start_date: updateFormData.start_date.split('T')[0],
      end_date: updateFormData.end_date.split('T')[0],
      locked: updateFormData.locked
    };
    await request
      .patch('project_management/update', updatedProject, { headers: headers })
      .then((res) => {

        const foundType = projectTypes.find((type) => type.id === res.data.data.type_id);
        res.data.data.project_type = foundType.name;
        const newProjects = projects.map(project_type => project_type.id !== res.data.data.id ? project_type : res.data.data);
        setProjects(newProjects);

        setModalUpdateOpen(false);
        Swal.fire({
          title: "Update Successfully",
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
    const newProject = {
      name: addFormData.name,
      type_id: addFormData.type_id,
      start_date: addFormData.start_date,
      end_date: addFormData.end_date,
      locked: addFormData.locked,
    };
    await request
      .post('/project_management/create', newProject, { headers: headers })
      .then((res) => {
        const foundType = projectTypes.find((type) => type.id === res.data.data.type_id);
        res.data.data.project_type = foundType.name;
        const newProjects = [...projects, res.data.data];
        setProjects(newProjects);

        setModalAddOpen(false);
        Swal.fire({
          title: "Add New Project Successfully",
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
    const deletedProject = {
      project_id: projectIdDelete,
    };
    await request
      .delete('project_management/delete', { headers: headers, data: deletedProject })
      .then((res) => {
        const newProjects = projects.filter(project_type => project_type.id !== res.data.data.id)
        setProjects(newProjects)
        setModalDeleteOpen(false);
        Swal.fire({
          title: "Delete Project Successfully",
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

            <div className={classes['button_wrapper']}>
              <Button
                className={classes['button_add']}
                onClick={() => {
                  setModalAddOpen(true);
                }}
                label="New Project"
                icon={<FontAwesomeIcon icon={faPlusCircle} className={classes.icon} />}
              >

              </Button>
            </div>

            {modalAddOpen && (
              <ModalProject
                labelTitle="Add New Project"
                labelButton="Add"
                resetForm={resetForm}
                setOpenModal={setModalAddOpen}
                handleFormChange={handleAddFormChange}
                addFormData={addFormData}
                handleFormSubmit={handleAddFormSubmit}
                projectTypes={projectTypes}
                deleteModal={false}
              />
            )}
            {modalUpdateOpen && (
              <ModalProject
                labelTitle="Update Project"
                labelButton="Update"
                projectEdit={projectEdit}
                openModal={modalUpdateOpen}
                resetForm={resetForm}
                updateFormData={updateFormData}
                setOpenModal={setModalUpdateOpen}
                handleFormChange={handleUpdateFormChange}
                handleFormSubmit={handleUpdateFormSubmit}
                projectTypes={projectTypes}
                deleteModal={false}

              />
            )}
            {modalDeleteOpen && (
              <ModalProject
                labelTitle="Delete Project"
                labelButton="Delete"
                resetForm={resetForm}
                setOpenModal={setModalDeleteOpen}
                handleFormSubmit={handleDeleteFormSubmit}
                deleteModal={true}
              />
            )}

            <table className={classes.tableProject}>
              <thead>
                <tr>
                  <th className={classes.header_project}>STT</th>
                  <th className={classes.header_project}>Name</th>
                  <th className={classes.header_project}>Type</th>
                  <th className={classes.header_project}>Status</th>
                  <th className={classes.header_project_date}>Start Date</th>
                  <th className={classes.header_project_date}>End Date</th>
                  <th className={classes.header_project}>Edit</th>
                </tr>
              </thead>
              <tbody>
                {projects.map((project, index) => (
                  <tr key={project.id}>
                    <td className={classes.data_project}>{index + 1}</td>
                    <td className={classes.data_project}>{project.name}</td>
                    <td className={classes.data_project}>{project.project_type}</td>
                    <td className={classes.data_project}>{project.locked ? ("Locked") : ("UnLocked")}</td>
                    <td className={classes.data_project}>{project.start_date ? formatDate(project.start_date) : ''}</td>
                    <td className={classes.data_project}>{project.end_date ? formatDate(project.end_date) : ''}</td>
                    <td className={classes.data_project_edit}>

                      <Button
                        onClick={() => {
                          projectUserNavigate(`/project_management/project_user/${project.id}`)
                        }}
                        icon={<FontAwesomeIcon icon={faEye} />}
                      >
                      </Button>
                      <Button
                        onClick={() => {
                          setModalUpdateOpen(true);
                          handleGetInforProjectUpdate(project.id);
                        }}
                        icon={<FontAwesomeIcon icon={faPencil} />}
                      />
                      <Button
                        onClick={() => {
                          setModalDeleteOpen(true);
                          handleGetInforProjectDelete(project.id)

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

export default Project;