const { getLocalItem } = require("./storageHelper");

const checkPermission = (auth) => {
  const storagePermissions = getLocalItem('permissions')
  const permissions_list = storagePermissions.split(',')
  return permissions_list.some(permission => permission === auth)
}

export default checkPermission