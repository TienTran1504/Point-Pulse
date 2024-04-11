/* eslint-disable import/no-anonymous-default-export */
/**
 * localStorage ~5MB, saved for infinity or until the user manually deletes it.
 * sessionStorage ~5MB, saved for the life of the CURRENT TAB
 */

const setLocalItem = (name, value) => {
  localStorage.setItem(name, value);
}

const setLocalObject = (name, obj) => {
  setLocalItem(name, JSON.stringify(obj));
}

const getLocalItem = (name) => {
  return localStorage.getItem(name);
}

const getLocalObject = (name) => {
  return JSON.parse(getLocalItem(name));
}

const removeLocalItem = (name) => {
  localStorage.removeItem(name);
}

const setSessionItem = (name, value) => {
  sessionStorage.setItem(name, value);
}

const setSessionObject = (name, obj) => {
  setSessionItem(name, JSON.stringify(obj));
}

const getSessionItem = (name) => {
  return sessionStorage.getItem(name);
}

const getSessionObject = (name) => {
  return JSON.parse(getSessionItem(name));
}

const removeSessionItem = (name) => {
  sessionStorage.removeItem(name);
}

export {
  setLocalItem,
  getLocalItem,
  setLocalObject,
  getLocalObject,
  removeLocalItem,
  setSessionItem,
  getSessionItem,
  setSessionObject,
  getSessionObject,
  removeSessionItem,
};
