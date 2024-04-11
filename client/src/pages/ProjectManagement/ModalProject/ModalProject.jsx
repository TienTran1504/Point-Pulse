import React, { useEffect, useRef } from 'react';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import classes from './Modal.module.scss';


function ModalProject(props) {
  const { deleteModal, setOpenModal, handleFormChange, handleFormSubmit, resetForm, labelTitle, labelButton, projectEdit, projectTypes, addFormData, updateFormData } = props;
  const inputName = useRef();
  const inputTypeId = useRef();
  const inputLocked = useRef();
  const inputStartDate = useRef();
  const inputEndDate = useRef();
  useEffect(() => {
    if (projectEdit) {
      inputStartDate.current.value = projectEdit.start_date.split('T')[0];
      inputEndDate.current.value = projectEdit.end_date.split('T')[0];
      inputName.current.value = projectEdit.name;
      inputTypeId.current.value = projectEdit.type_id;
      inputLocked.current.checked = projectEdit.locked;
    }
  }, [projectEdit]);
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
              <p style={{ fontWeight: 500, color: 'red' }}>Are You Sure Want To Delete This Project ?</p>
            </>
          ) : (
            <>

              <div className={classes.body}>
                <div className={classes.adding}>
                  {projectEdit ? (
                    <>
                      <div className={classes.startDate}>
                        <label htmlFor="startDate">Start Date:</label>
                        <input
                          type="date"
                          required="required"
                          id="start_date"
                          name="start_date"
                          ref={inputStartDate}
                          onChange={handleFormChange}
                          max={updateFormData.end_date}
                        />
                      </div>

                      <div className={classes.endDate}>
                        <label htmlFor="endDate">End Date:</label>
                        <input
                          type="date"
                          required="required"
                          id="end_date"
                          name="end_date"
                          ref={inputEndDate}
                          onChange={handleFormChange}
                          min={updateFormData.start_date} // Ngày tối thiểu có thể chọn là ngày đã chọn trong ô "from date"
                        />
                      </div>
                      <div className={classes.projectName}>
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
                      <div className={classes.projectType}>
                        <p>Project Type</p>
                        <select
                          name="type_id"
                          ref={inputTypeId}
                          onChange={handleFormChange}
                        >
                          <option value="" disabled hidden>Choose Type</option>
                          {projectTypes.map((projectType) => (
                            <option key={projectType.id} value={projectType.id}>{projectType.name}</option>
                          ))}
                        </select>
                      </div>

                      <div className={classes.projectLocked}>
                        <p>Locked</p>
                        <div className={classes['wrapper-checkbox']}>

                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="locked"
                            name="locked"
                            ref={inputLocked}
                            onChange={handleFormChange}
                          />
                        </div>
                      </div>

                    </>
                  ) : (
                    <>
                      <div className={classes.startDate}>
                        <label htmlFor="startDate">Start Date:</label>
                        <input
                          type="date"
                          required="required"
                          id="start_date"
                          name="start_date"
                          // ref={inputStartDate}
                          onChange={handleFormChange}
                          max={addFormData.end_date}
                        />
                      </div>

                      <div className={classes.endDate}>
                        <label htmlFor="endDate">End Date:</label>
                        <input
                          type="date"
                          required="required"
                          id="end_date"
                          name="end_date"
                          // ref={inputEndDate}
                          onChange={handleFormChange}
                          min={addFormData.start_date} // Ngày tối thiểu có thể chọn là ngày đã chọn trong ô "from date"
                        />
                      </div>
                      <div className={classes.projectName}>
                        <p>Name</p>
                        <input
                          type="text"
                          required="required"
                          placeholder="Enter Name"
                          name="name"

                          onChange={handleFormChange}
                        />
                      </div>

                      <div className={classes.projectType}>
                        <p>Project Type</p>
                        <select
                          className="selection"
                          name="type_id"
                          defaultValue=""
                          onChange={handleFormChange}
                        >
                          <option value="" disabled hidden>Choose Type</option>
                          {projectTypes.map((projectType) => (
                            <option key={projectType.id} value={projectType.id}>{projectType.name}</option>
                          ))}
                        </select>
                      </div>

                      <div className={classes.projectLocked}>
                        <p>Locked</p>
                        <div className={classes['wrapper-checkbox']}>
                          <input
                            className={classes.inputCheckBox}
                            type="checkbox"
                            id="locked"
                            name="locked"
                            value={true}
                            onChange={handleFormChange}
                          />
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

export default ModalProject;
