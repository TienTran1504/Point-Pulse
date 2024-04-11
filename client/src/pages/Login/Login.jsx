import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { setLocalItem, getLocalItem, setLocalObject } from '~/utils/storageHelper';

import request from '~/utils/request';
import classes from './Login.module.scss';
import Images from '~/assets/images';
import Swal from 'sweetalert2';

export default function LoginPage() {

  const loginNavigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [currentUser, setCurrentUser] = useState(() => {
    const storageUserState = getLocalItem('user-state')
    return storageUserState;
  });

  useEffect(() => {
    if (currentUser) loginNavigate('/point_management');
  }, [currentUser]);

  async function handleSubmit(e) {
    e.preventDefault();
    if (email && password) {
      const objLogin = {
        email: email,
        password: password,
      };

      try {
        const response = await request.post('users/sign_in', objLogin);
        setLocalItem('user-state', true)
        setLocalObject('user', response.data.data)
        setLocalItem('token', response.data.data.token)
        setLocalItem('permissions', response.data.data.permissions)
        setCurrentUser(true);
        Swal.fire({
          title: 'Login Successfully!',
          icon: 'success',
          confirmButtonText: 'Done',
          width: '50rem',
        });
      } catch (error) {
        Swal.fire({
          icon: 'error',
          title: 'Error',
          text: 'Invalid Credentials',
          width: '50rem',
        });
      }

    }
    else {
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Please Enter Your Credentials',
        width: '50rem',
      });
    }
  }

  return (
    <div className={classes.wrapper}>
      <div className={classes.wrapper__logo}>
        <img src={Images.logoImage} alt="none" />
      </div>
      <div className={classes.wrapper__form}>
        <h2>Login Account</h2>
        <form action="/" onSubmit={handleSubmit}>
          <p>
            <input
              type="text"
              name="first__name"
              placeholder="Enter Your Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </p>
          <p>
            <input
              type="password"
              name="password"
              placeholder="Nhập mật khẩu của bạn"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            <br />

          </p>
          <p>
            <button id={classes.sub__btn} type="submit">
              Login
            </button>
          </p>
        </form>

      </div>
    </div>
  );
}