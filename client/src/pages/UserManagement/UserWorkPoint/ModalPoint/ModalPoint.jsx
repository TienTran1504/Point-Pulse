import React, { useEffect, useRef } from 'react';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import classes from './ModalPoint.module.scss';



function ModalPoint(props) {
  const { setOpenModal, handleFormChange, handleFormSubmit, resetForm, labelTitle, labelButton, pointEdit, createUserWorkPoint } = props;
  const inputWorkPoint = useRef();

  useEffect(() => {
    if (pointEdit) {
      inputWorkPoint.current.value = (pointEdit.work_point);
    }
  }, [pointEdit]);

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

          <div className={classes.body}>
            <div className={classes.adding}>
              {pointEdit ? (
                <>
                  <div className={classes.userPoint}>
                    <p>Point</p>
                    <input
                      type="number"
                      step={0.01}
                      required="required"
                      placeholder="Insert Work Point"
                      name="work_point"
                      ref={inputWorkPoint}
                      onChange={handleFormChange}
                    />
                  </div>
                </>
              ) : (
                <>
                  <div className={classes.fromDate}>
                    <label htmlFor="fromDate">From Date:</label>
                    <input
                      type="date"
                      id="from_date"
                      name="from_date"
                      value={createUserWorkPoint.from_date}
                      onChange={handleFormChange}
                    />
                  </div>

                  <div className={classes.toDate}>
                    <label htmlFor="toDate">To Date:</label>
                    <input
                      type="date"
                      id="to_date"
                      name="to_date"
                      value={createUserWorkPoint.to_date}
                      onChange={handleFormChange}
                      min={createUserWorkPoint.from_date} // Ngày tối thiểu có thể chọn là ngày đã chọn trong ô "from date"
                    />
                  </div>
                  <div className={classes.userPoint}>
                    <p>Point</p>
                    <input
                      type="number"
                      step={0.01}
                      required="required"
                      placeholder="Insert Work Point"
                      name="work_point"
                      onChange={handleFormChange}
                    />
                  </div>


                </>
              )}

            </div>
          </div>
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

export default ModalPoint;
