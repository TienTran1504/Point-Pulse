import classes from './Header.module.scss';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  faSignIn,
} from '@fortawesome/free-solid-svg-icons';
import { getLocalItem, removeLocalItem } from '~/utils/storageHelper';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { useEffect, useState } from 'react';
import Button from '~/components/Layout/DefaultLayout/Header/Button';
import Images from '~/assets/images';
import request from '~/utils/request';
import Swal from 'sweetalert2';
import images from '~/assets/images';

import AccountDropdown from '~/components/AccountDropdown/AccountDropdown';
import checkPermission from '~/utils/checkPermission';

function Header() {
  const [currentUser, setCurrentUser] = useState(false);
  const [activeAccountDropdown, setActiveAccountDropdown] = useState(false);
  const user = JSON.parse(localStorage.getItem('user'));

  const loginNavigate = useNavigate();

  useEffect(() => {
    const storageUserState = JSON.parse(localStorage.getItem('user-state'));
    setCurrentUser(storageUserState);
  }, []);

  const path = useLocation();
  const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
  const headers = {
    Authorization: tokenAuth,
  };

  const handleLogOut = async () => {
    await request
      .post('users/sign_out', null, {
        headers: headers
      })
      .then((res) => {
        Swal.fire({
          title: 'Đăng xuất thành công',
          icon: 'success',
          confirmButtonText: 'Hoàn tất',
          width: '50rem',
        });
      })
      .catch((err) => {
        console.log(err)
      });
    removeLocalItem('user-state')
    removeLocalItem('user')
    removeLocalItem('token')
    removeLocalItem('permissions')
    loginNavigate('/')

  };

  return (
    <div className={classes.wrapper}>
      <div className={classes.inner}>
        <div className={classes.wrapper__logo}>
          <img src={Images.logoImage} alt="none" />
        </div>
        {currentUser ? (
          <>
            <div className={classes.actions}>
              <ul className={classes['menu-list']}>
                {checkPermission('1') && (
                  <li className={classes['menu-item']}>
                    <Link to="/user_management" className={`${path.pathname.includes('/user_management') ? classes.active : ''}`}>
                      User
                    </Link>
                  </li>
                )}

                {checkPermission('2') && (
                  <li className={classes['menu-item']}>
                    <Link
                      to="/master_data_management/project_type"
                      className={`${path.pathname.includes('/master_data_management') ? classes.active : ''}`}
                    >
                      Master Data
                    </Link>
                  </li>
                )}

                {checkPermission('3') && (
                  <li className={classes['menu-item']}>
                    <Link
                      to="/project_management"
                      className={`${path.pathname.includes('/project_management') ? classes.active : ''}`}
                    >
                      Project
                    </Link>
                  </li>
                )}

                {checkPermission('4') && (
                  <li className={classes['menu-item']}>
                    <Link
                      to="/project_point_management"
                      className={`${path.pathname.includes('/project_point_management') ? classes.active : ''}`}
                    >
                      Project Point
                    </Link>
                  </li>
                )}

                {checkPermission('5') && (
                  <li className={classes['menu-item']}>
                    <Link
                      to="/point_management"
                      className={`${path.pathname.includes('/point_management') ? classes.active : ''}`}
                    >
                      Point
                    </Link>
                  </li>
                )}
                {checkPermission('6') && (
                  <li className={classes['menu-item']}>
                    <Link to="/report" className={`${path.pathname.includes('/report') ? classes.active : ''}`}>
                      View Report
                    </Link>
                  </li>
                )}
              </ul>
            </div>
            <div className={classes.avatar_container}>
              <img
                src={images.avatarImage}
                className={`${classes['avatar']} ${activeAccountDropdown ? classes['avatar--active'] : ''}`}
                onClick={() => setActiveAccountDropdown(!activeAccountDropdown)}
                alt="avatar"
              >

              </img>
              <div className={classes.accountName}>
                {user.name}
              </div>
              {activeAccountDropdown && (
                <div className={classes.accountDropdown_container}>
                  <AccountDropdown handleLogOut={handleLogOut} className={classes.accountDropdown_container} />
                </div>
              )}
            </div>
          </>
        ) : (
          <Link to="/">
            <Button
              label="Log in"
              icon={<FontAwesomeIcon icon={faSignIn} className={classes.icon} />}
            />
          </Link>
        )}
      </div>
    </div>
  )
}

export default Header;
