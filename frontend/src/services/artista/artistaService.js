import api from "../api";

export const getArtistas = async () => {
  const response = await api.get("artistas/");
  return response.data;
};

export const getArtista = async (id) => {
  const response = await api.get(`artistas/${id}/`);
  return response.data;
};

export const createArtista = async (data) => {
  const response = await api.post("artistas/", data);
  return response.data;
};

export const updateArtista = async (id, data) => {
  const response = await api.put(`artistas/${id}/`, data);
  return response.data;
};

export const deleteArtista = async (id) => {
  const response = await api.delete(`artistas/${id}/`);
  return response.data;
};
