import classes from './styles.module.scss';
import { Checkbox } from '@mui/material';
import { useEffect, useState } from 'react';
import request from '~/utils/request';

const sx = { '& .MuiSvgIcon-root': { fontSize: 18, color: '#6faf8c' } };

export default function DropdownUser(props) {
  const { setSelectedUsers, selectedUsers, users } = props

  const handleSelected = (user) => (e) => {
    if (e.target.checked) {
      setSelectedUsers((prevSelectedUsers) => [...prevSelectedUsers, user]);
    } else {
      setSelectedUsers((prevSelectedUsers) =>
        prevSelectedUsers.filter((selectedUser) => selectedUser.id !== user.id)
      );
    }
  };
  const checkedSelected = (user) => {
    const checked = selectedUsers.some((selected) => selected.id === user.id)
    return checked;
  }
  return (
    <div className={classes.main_container}>
      <div className={classes.title}>Filter Members</div>
      <div className={classes.filterItem}>
        {users.map((user) => (
          <div key={user.id} className={classes.checkbox}>
            <Checkbox
              // style={{ accentColor: '#6faf8c' }}
              checked={checkedSelected(user)}
              className={classes.checkbox__ic}
              sx={sx}
              onChange={handleSelected(user)}
            />
            <div className={classes.checkbox__label}>{user.name}</div>
          </div>
        ))}
      </div>
    </div>
  );
}