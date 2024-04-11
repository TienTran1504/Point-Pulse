import React, { useState, useEffect } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { setLocalItem, getLocalItem, setLocalObject, getLocalObject } from '~/utils/storageHelper';

import request from '~/utils/request';
import classes from './PointManagement.module.scss';
import Images from '~/assets/images';
function PointManagement() {
  const path = useLocation();

  const permissions = (() => {
    const storagePermissions = getLocalItem('permissions')
    return storagePermissions
  })();

  const checkPermission = () => {
    const permissions_list = permissions.split(',')
    return permissions_list.some(permission => permission === '5')
  }
  const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
  const headers = {
    Authorization: tokenAuth,
  };

  return (
    <div>
      {
        checkPermission('5') ? (
          <div className={classes.wrapper}>
            <div className={classes.actions}>
              <ul className={classes['menu-list']}>
                <li className={classes['menu-item']}>
                  <Link to="/point_management/personal" className={`${path.pathname.includes('/point_management/personal') ? classes.active : ''}`}>
                    Personal Project
                  </Link>
                </li>

                <li className={classes['menu-item']}>
                  <Link
                    to="/point_management/managing"
                    className={`${path.pathname.includes('/point_management/managing') ? classes.active : ''}`}
                  >
                    Managing Project
                  </Link>
                </li>

              </ul>
            </div>
            <h2>Point Management</h2>
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

export default PointManagement;