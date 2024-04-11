import React, { useEffect, useRef } from 'react';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import classes from './Modal.module.scss';



function ModalProjectUser(props) {
  const { deleteModal, setOpenModal, handleFormChange, handleFormSubmit, resetForm, labelTitle, labelButton, projectUserEdit, users, userRoles } = props;
  const inputUserId = useRef();
  const inputUserRoleId = useRef();

  useEffect(() => {
    if (projectUserEdit) {
      inputUserRoleId.current.value = projectUserEdit.user_role_id;
    }

  }, [projectUserEdit]);

  return (
    <div className={classes.modalBackground}>
      <div className={classes.modalContainer}>
        <div className={classes.title}>
          <p className={classes['titleName']}>{labelTitle}</p>
          <div className={classes.titleCloseBtn}>
            <button
              onClick={() => {
                setOpenModal(false);
                resetForm()
              }}
            >
              X
            </button>
          </div>
        </div>
        <form className={classes['modal-form']} onSubmit={handleFormSubmit}>
          {deleteModal ? (
            <>
              <p style={{ fontWeight: 500, color: 'red' }}>Are You Sure Want To Delete This Member From Project ?</p>
            </>
          ) : (
            <>

              <div className={classes.body}>
                <div className={classes.adding}>
                  {projectUserEdit ? (
                    <>
                      <div className={classes.Users}>
                        <p>Member</p>
                        <input
                          type="text"
                          placeholder="Member's Name"
                          name="name"
                          readOnly={true}
                          value={projectUserEdit.user_name}
                        />
                      </div>

                      <div className={classes.Roles}>
                        <p>Role</p>
                        <select
                          name="user_role_id"
                          ref={inputUserRoleId}
                          onChange={handleFormChange}
                        >
                          <option value="" disabled hidden>Member's Role</option>
                          {userRoles.map((user_role) => (
                            <option key={user_role.id} value={user_role.id}>{user_role.name}</option>
                          ))}
                        </select>
                      </div>

                    </>
                  ) : (
                    <>
                      <div className={classes.Users}>
                        <p>Member</p>
                        <select
                          name="user_id"
                          ref={inputUserId}
                          defaultValue={[""]}
                          onChange={handleFormChange}
                          multiple
                        >
                          <option value="" disabled hidden>Members</option>
                          {users.map((user) => (
                            <option key={user.id} value={user.id}>{user.name}</option>
                          ))}
                        </select>
                      </div>

                      <div className={classes.Roles}>
                        <p>Role</p>
                        <select
                          name="user_role_id"
                          defaultValue=""
                          onChange={handleFormChange}
                          required
                        >
                          <option value="" disabled hidden>Member's Role</option>
                          {userRoles.map((user_role) => (
                            <option key={user_role.id} value={user_role.id}>{user_role.name}</option>
                          ))}
                        </select>
                      </div>
                    </>
                  )}

                </div>
              </div>
            </>

          )}
          <div className={classes.footer}>
            <Button
              onClick={() => {
                setOpenModal(false);
                resetForm();
              }}
              label='Cancel'
            >

            </Button>
            <Button label={labelButton} type="submit">
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default ModalProjectUser;
