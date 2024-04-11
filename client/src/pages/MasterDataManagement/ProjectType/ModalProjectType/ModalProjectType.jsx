import React, { useEffect, useRef } from 'react';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import classes from './Modal.module.scss';



function ModalProjectType(props) {
  const { deleteModal, setOpenModal, handleFormChange, handleFormSubmit, resetForm, labelTitle, labelButton, projectTypeEdit } = props;
  const inputName = useRef();

  useEffect(() => {
    if (projectTypeEdit) {
      inputName.current.value = projectTypeEdit.name;
    }
  }, [projectTypeEdit]);

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
              <p style={{ fontWeight: 500, color: 'red' }}>Are You Sure Want To Delete This Project Type ?</p>
            </>
          ) : (
            <>

              <div className={classes.body}>
                <div className={classes.adding}>
                  {projectTypeEdit ? (
                    <>
                      <div className={classes.projectTypeName}>
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
                      <div className={classes.projectTypeName}>
                        <p>Name</p>
                        <input
                          type="text"
                          required="required"
                          placeholder="Enter Name"
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

export default ModalProjectType;
