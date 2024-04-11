import React, { useEffect, useRef } from 'react';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import classes from './Modal.module.scss';



function Modal(props) {
  const { deleteModal, setOpenModal, handleFormChange, handleFormSubmit, resetForm, labelTitle, labelButton, userEdit } = props;
  const inputWeight = useRef();
  const inputUserManagement = useRef();
  const inputProjectManagement = useRef();
  const inputProjectPointManagement = useRef();
  const inputViewReport = useRef();
  const inputMasterDataManagement = useRef();
  useEffect(() => {
    if (userEdit) {
      inputWeight.current.value = userEdit.weight;
      inputUserManagement.current.checked = userEdit.permissions.includes(1) ? true : false;
      inputMasterDataManagement.current.checked = userEdit.permissions.includes(2) ? true : false;
      inputProjectManagement.current.checked = userEdit.permissions.includes(3) ? true : false;
      inputProjectPointManagement.current.checked = userEdit.permissions.includes(4) ? true : false;
      inputViewReport.current.checked = userEdit.permissions.includes(6) ? true : false;
    }
  }, [userEdit]);

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
              <p style={{ fontWeight: 500, color: 'red' }}>Are You Sure Want To Delete This User ?</p>
            </>
          ) : (
            <>

              <div className={classes.body}>
                <div className={classes.adding}>
                  {userEdit ? (
                    <>
                      <div className={classes.userEmail}>
                        <p>Email</p>
                        <input
                          type="text"
                          required="required"
                          placeholder="Enter Email"
                          value={userEdit.email}
                          name="email"
                          onChange={handleFormChange}
                        />
                      </div>


                      <div className={classes.userName}>
                        <p>Name</p>
                        <input
                          type="text"
                          required="required"
                          placeholder="Enter User's Name"
                          name="name"
                          value={userEdit.name}
                          onChange={handleFormChange}
                        />
                      </div>

                      <div className={classes.userWeight}>
                        <p>Weight</p>
                        <input
                          type="number"
                          step={0.01}
                          required="required"
                          placeholder="Input User Weight's Point (from 0.0 to 1.0)"
                          name="weight"
                          ref={inputWeight}
                          onChange={handleFormChange}
                        />
                      </div>
                      <div className={classes.userPermissions}>
                        <p>Permissions List</p>

                        <div className={classes['wrapper-checkbox']}>
                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="userManagement"
                            name="userManagement"
                            ref={inputUserManagement}
                            // checked={userEdit.permissions.includes(1) ? true : false}
                            value={1}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="userManagement">User Management</label>
                        </div>
                        <div className={classes['wrapper-checkbox']}>

                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="masterDataManagement"
                            name="masterDataManagement"
                            ref={inputMasterDataManagement}
                            // checked={userEdit.permissions.includes(2) ? true : false}
                            value={2}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="masterDataManagement">Master Data Management</label>
                        </div>
                        <div className={classes['wrapper-checkbox']}>

                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="projectManagement"
                            name="projectManagement"
                            ref={inputProjectManagement}
                            // checked={userEdit.permissions.includes(3) ? true : false}
                            value={3}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="projectManagement">Project Management</label>
                        </div>
                        <div className={classes['wrapper-checkbox']}>

                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="projectPointManagement"
                            name="projectPointManagement"
                            ref={inputProjectPointManagement}
                            // checked={userEdit.permissions.includes(4) ? true : false}
                            value={4}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="projectPointManagement">Project Point Management</label>
                        </div>
                        <div className={classes['wrapper-checkbox']}>
                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="viewReportManage"
                            name="viewReportManage"
                            ref={inputViewReport}
                            // checked={userEdit.permissions.includes(6) ? true : false}
                            value={6}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="viewReportManage">View Report Management</label>
                        </div>

                      </div>
                    </>
                  ) : (
                    <>
                      <div className={classes.userEmail}>
                        <p>Email</p>
                        <input
                          type="text"
                          required="required"
                          placeholder="Enter Email"
                          name="email"
                          onChange={handleFormChange}
                        />
                      </div>
                      <div className={classes.userPassword}>
                        <p>Mật khẩu</p>
                        <input
                          type="password"
                          required="required"
                          placeholder="Enter Password"
                          name="password"
                          onChange={handleFormChange}
                        />
                      </div>

                      <div className={classes.userName}>
                        <p>Name</p>
                        <input
                          type="text"
                          required="required"
                          placeholder="Enter User's Name"
                          name="name"
                          onChange={handleFormChange}
                        />
                      </div>

                      <div className={classes.userWeight}>
                        <p>Weight</p>
                        <input
                          type="number"
                          step={0.01}
                          required="required"
                          placeholder="Input User Weight's Point (from 0.0 to 1.0)"
                          name="weight"
                          onChange={handleFormChange}
                        />
                      </div>
                      <div className={classes.userPermissions}>
                        <p>Permissions List</p>

                        <div className={classes['wrapper-checkbox']}>
                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="userManagement"
                            name="userManagement"
                            value={1}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="userManagement">User Management</label>
                        </div>
                        <div className={classes['wrapper-checkbox']}>

                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="masterDataManagement"
                            name="masterDataManagement"
                            value={2}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="masterDataManagement">Master Data Management</label>
                        </div>
                        <div className={classes['wrapper-checkbox']}>

                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="projectManagement"
                            name="projectManagement"
                            value={3}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="projectManagement">Project Management</label>
                        </div>
                        <div className={classes['wrapper-checkbox']}>

                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="projectPointManagement"
                            name="projectPointManagement"
                            value={4}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="projectPointManagement">Project Point Management</label>
                        </div>
                        <div className={classes['wrapper-checkbox']}>
                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="viewReportManage"
                            name="viewReportManage"
                            value={6}
                            onChange={handleFormChange}
                          />
                          <label htmlFor="viewReportManage">View Report Management</label>
                        </div>

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

export default Modal;
