import classes from './styles.module.scss';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faInfoCircle, faSignOut } from '@fortawesome/free-solid-svg-icons';

export default function AccountDropdown({ handleLogOut }) {
  const user = JSON.parse(localStorage.getItem('user'));
  return (
    <div className={classes.main_container}>
      <div className={classes.item_container} onClick={null}>
        <FontAwesomeIcon icon={faInfoCircle} className={classes.item_info_icon} />
        <div className={classes.item_info_name}>{user.name}</div>
      </div>

      <div className={classes.divider} />

      <div className={classes.item_container} onClick={handleLogOut}>
        <FontAwesomeIcon icon={faSignOut} className={classes.item_logout_icon} />
        <div className={classes.item_logout_name}>Đăng xuất</div>
      </div>
    </div>
  );
}
