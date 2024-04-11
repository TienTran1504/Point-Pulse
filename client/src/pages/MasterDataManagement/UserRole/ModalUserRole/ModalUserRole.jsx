import React, { useEffect, useRef } from 'react';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import classes from './Modal.module.scss';



function ModalUserRole(props) {
  const { deleteModal, setOpenModal, handleFormChange, handleFormSubmit, resetForm, labelTitle, labelButton, userRoleEdit } = props;
  const inputName = useRef();

  useEffect(() => {
    if (userRoleEdit) {
      inputName.current.value = userRoleEdit.name;
    }
  }, [userRoleEdit]);

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
              <p style={{ fontWeight: 500, color: 'red' }}>Are You Sure Want To Delete This Role ?</p>
            </>
          ) : (
            <>

              <div className={classes.body}>
                <div className={classes.adding}>
                  {userRoleEdit ? (
                    <>
                      <div className={classes.userRoleName}>
                        <p>Name</p>
                        <input
                          type="text"
                          required="required"
                          placeholder="Enter Name"
                          name="name"
                          ref={inputName}
                          onChange={handleFormChange}
                        />
                      </div>

                    </>
                  ) : (
                    <>
                      <div className={classes.userRoleName}>
                        <p>Name</p>
                        <input
                          type="text"
                          required="required"
                          placeholder="Enter Role"
                          name="name"
                          onChange={handleFormChange}
                        />
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

export default ModalUserRole;
