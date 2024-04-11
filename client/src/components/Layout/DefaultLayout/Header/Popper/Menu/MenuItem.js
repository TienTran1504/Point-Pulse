import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import classes from './MenuItem.module.scss'
// import {
//     faCartShopping,
//     faCircleQuestion,
//     faCoins,
//     faSignIn,
//     faSignOut,
//     faUser,
// } from '@fortawesome/free-solid-svg-icons';
function MenuItem({ handleLogOut, data }) {

    return (
        <div className={classes.wrapper}>
            <button
                className={classes['custom-button']}
                onClick={handleLogOut}
                disabled={data.disabled}
            >
                <FontAwesomeIcon icon={data.icon} className={classes.icon} />
                {data.title}
            </button>
        </div>
    );
}

export default MenuItem;