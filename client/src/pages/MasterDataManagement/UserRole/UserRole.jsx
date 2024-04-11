import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import checkPermission from '~/utils/checkPermission';

import request from '~/utils/request';
import classes from './UserRole.module.scss';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPencil, faPlusCircle, faTrashCan } from '@fortawesome/free-solid-svg-icons';
import Swal from 'sweetalert2';
import formatDate from '~/utils/formatDate';
import ModalUserRole from './ModalUserRole/ModalUserRole';
import { getLocalItem } from '~/utils/storageHelper';

function UserRole() {
    const path = useLocation();
    const [userRoles, setUserRoles] = useState([])

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
    const [userRoleEdit, setUserRoleEdit] = useState({
        id: '',
        name: '',
    })
    const [userRoleIdDelete, setUserRoleIdDelete] = useState('')


    const resetForm = () => {
        setAddFormData({
            name: ''
        });
        setUserRoleEdit({
            name: '',
        })
        setUserRoleIdDelete('')
    };

    const fetchUserRoles = async () => {
        try {
            const response = await request.get('master_data_management/get_all_roles', {
                headers: headers,
            });
            setUserRoles(response.data.data);
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    };

    useEffect(() => {
        fetchUserRoles();
    }, []);

    const handleGetInforUserRoleUpdate = async (id) => {
        try {
            const response = await request(`master_data_management/user_role/${id}`, { headers: headers })
            setUserRoleEdit(response.data.data)
            setUpdateFormData({
                name: response.data.data.name,
            })

        } catch (error) {
            console.error('Error fetching data:', error);
        }
    }

    const handleGetInforUserRoleDelete = async (id) => {
        try {
            const response = await request(`master_data_management/user_role/${id}`, { headers: headers })
            setUserRoleIdDelete(response.data.data.id)
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


    //Call api post method add user_role
    const handleUpdateFormSubmit = async (e) => {
        e.preventDefault();
        const updatedUserRole = {
            user_role_id: userRoleEdit.id,
            name: updateFormData.name,
        };
        await request
            .patch('master_data_management/update_role', updatedUserRole, { headers: headers })
            .then((res) => {

                const newUserRoles = userRoles.map(user_role => user_role.id !== res.data.data.id ? user_role : res.data.data);
                setUserRoles(newUserRoles);

                setModalUpdateOpen(false);
                Swal.fire({
                    title: "Update User Role Successfully",
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

    // //Call api post method add user_role
    const handleAddFormSubmit = async (e) => {
        e.preventDefault();
        const newUserRole = {
            name: addFormData.name,
        };
        await request
            .post('/master_data_management/create_role', newUserRole, { headers: headers })
            .then((res) => {
                const newUserRoles = [...userRoles, res.data.data];
                setUserRoles(newUserRoles);

                setModalAddOpen(false);
                Swal.fire({
                    title: "Add New User Role Successfuly",
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
        const deletedUserRole = {
            user_role_id: userRoleIdDelete,
        };
        await request
            .delete('master_data_management/delete_role', { headers: headers, data: deletedUserRole })
            .then((res) => {
                const newUserRoles = userRoles.filter(user_role => user_role.id !== res.data.data.id)
                setUserRoles(newUserRoles)
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
                                label="New User Role"
                                icon={<FontAwesomeIcon icon={faPlusCircle} className={classes.icon} />}
                            >

                            </Button>
                        </div>

                        {modalAddOpen && (
                            <ModalUserRole
                                labelTitle="Add New User Role"
                                labelButton="Add"
                                resetForm={resetForm}
                                setOpenModal={setModalAddOpen}
                                handleFormChange={handleAddFormChange}
                                handleFormSubmit={handleAddFormSubmit}
                                deleteModal={false}

                            />
                        )}
                        {modalUpdateOpen && (
                            <ModalUserRole
                                labelTitle="Update User Role"
                                labelButton="Update"
                                userRoleEdit={userRoleEdit}
                                openModal={modalUpdateOpen}
                                resetForm={resetForm}
                                setOpenModal={setModalUpdateOpen}
                                handleFormChange={handleUpdateFormChange}
                                handleFormSubmit={handleUpdateFormSubmit}
                                deleteModal={false}

                            />
                        )}
                        {modalDeleteOpen && (
                            <ModalUserRole
                                labelTitle="Delete User Role"
                                labelButton="Delete"
                                resetForm={resetForm}
                                setOpenModal={setModalDeleteOpen}
                                handleFormSubmit={handleDeleteFormSubmit}
                                deleteModal={true}
                            />
                        )}

                        <table className={classes.tableRole}>
                            <thead >
                                <tr>
                                    <th className={classes.header_role}>ID</th>
                                    <th className={classes.header_role}>Name</th>
                                    <th className={classes.header_role}>Inserted At</th>
                                    <th className={classes.header_role}>Updated At</th>
                                    <th className={classes.header_role} >Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                                {userRoles.map((userRole) => (
                                    <tr key={userRole.id}>
                                        <td className={classes.data_role}>{userRole.id}</td>
                                        <td className={classes.data_role}>{userRole.name}</td>
                                        <td className={classes.data_role}>{userRole.inserted_at ? formatDate(userRole.inserted_at) : ''}</td>
                                        <td className={classes.data_role}>{userRole.updated_at ? formatDate(userRole.updated_at) : ''}</td>
                                        <td className={classes.edit_role}>
                                            <Button
                                                onClick={() => {
                                                    setModalUpdateOpen(true);
                                                    handleGetInforUserRoleUpdate(userRole.id);
                                                }}
                                                icon={<FontAwesomeIcon icon={faPencil} />}
                                            />
                                            <Button
                                                onClick={() => {
                                                    setModalDeleteOpen(true);
                                                    handleGetInforUserRoleDelete(userRole.id)

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

export default UserRole;