import api from "./api";

export const login = async (username, password) => {
  const response = await api.post("token/", {
    username,
    password,
  });
  const { access, refresh } = response.data;
  if (access) {
    localStorage.setItem("token", access);
  }
  if (refresh) {
    localStorage.setItem("refreshToken", refresh);
  }
  return response.data;
};

export const logout = () => {
  localStorage.removeItem("token");
  localStorage.removeItem("refreshToken");
};

export const isAuthenticated = () => {
  return !!localStorage.getItem("token");
};

export const getToken = () => {
  return localStorage.getItem("token");
};

