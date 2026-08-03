import api from "../api";

export const getAlbums = async () => {
  const response = await api.get("albumes/");
  return response.data;
};

export const getAlbum = async (id) => {
  const response = await api.get(`albumes/${id}/`);
  return response.data;
};

export const createAlbum = async (data) => {
  const response = await api.post("albumes/", data);
  return response.data;
};

export const updateAlbum = async (id, data) => {
  const response = await api.put(`albumes/${id}/`, data);
  return response.data;
};

export const deleteAlbum = async (id) => {
  const response = await api.delete(`albumes/${id}/`);
  return response.data;
};
