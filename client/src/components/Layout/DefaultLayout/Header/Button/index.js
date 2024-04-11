import React from 'react';
import classes from './Button.module.scss'

const Button = (props) => {
  const { onClick, label, disabled, icon } = props;


  return (
    <div className={classes.wrapper}>
      <button
        className={classes['custom-button']}
        onClick={onClick}
        disabled={disabled}
      >
        {label}
        {icon}
      </button>
    </div>
  );
};

export default Button;
