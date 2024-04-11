const { getLocalItem } = require("./storageHelper");

const tokenAuth = 'Bearer ' + JSON.stringify(getLocalItem('token')).split('"').join('');
const headers = {
  Authorization: tokenAuth,
};

export default headers