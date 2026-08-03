import React, { useState, useEffect } from "react";
import { useHistory, useParams, Link } from "react-router-dom";
import { createAlbum, getAlbum, updateAlbum } from "../../services/album/albumService";

export default function AlbumForm() {
  const [formData, setFormData] = useState({});
  const history = useHistory();
  const { id } = useParams();

  useEffect(() => {
    if (id) {
      loadData();
    }
  }, [id]);

  const loadData = async () => {
    try {
      const data = await getAlbum(id);
      setFormData(data);
    } catch (error) {
      console.error("Error al cargar:", error);
    }
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (id) {
        await updateAlbum(id, formData);
      } else {
        await createAlbum(formData);
      }
      history.push("/dashboard/albumes");
    } catch (error) {
      console.error("Error al guardar:", error);
      if (error.response && error.response.data) {
        alert("Error: " + JSON.stringify(error.response.data));
      } else {
        alert("Ocurrió un error inesperado al guardar.");
      }
    }
  };

  return (
    <>
      <div className="flex content-center items-center justify-center h-full mt-8">
        <div className="w-full lg:w-8/12 px-4">
          <div className="relative flex flex-col min-w-0 break-words w-full mb-6 shadow-2xl rounded-lg bg-gray-900 border-0 text-white">
            <div className="rounded-t mb-0 px-6 py-6 bg-gray-800">
              <div className="text-center flex justify-between">
                <h6 className="text-green-400 text-xl font-bold">
                  {id ? "Editar Album" : "Crear Album"}
                </h6>
                <Link
                  to="/dashboard/albumes"
                  className="bg-gray-700 text-white active:bg-gray-600 font-bold uppercase text-xs px-4 py-2 rounded-full shadow hover:shadow-md outline-none focus:outline-none mr-1 ease-linear transition-all duration-150"
                >
                  Volver
                </Link>
              </div>
            </div>
            <div className="flex-auto px-4 lg:px-10 py-10 pt-0">
              <form onSubmit={handleSubmit} className="mt-8">
                <div className="flex flex-wrap">
                  <div className="w-full lg:w-6/12 px-4">
                    <div className="relative w-full mb-3">
                      <label className="block uppercase text-gray-400 text-xs font-bold mb-2">
                        Título
                      </label>
                      <input
                        type="text"
                        name="titulo"
                        value={formData.titulo || ""}
                        onChange={handleChange}
                        className="border-0 px-3 py-3 placeholder-gray-500 text-white bg-gray-800 rounded-lg text-sm shadow focus:outline-none focus:ring-2 focus:ring-green-400 w-full ease-linear transition-all duration-150"
                      />
                    </div>
                  </div>
                  <div className="w-full lg:w-6/12 px-4">
                    <div className="relative w-full mb-3">
                      <label className="block uppercase text-gray-400 text-xs font-bold mb-2">
                        Fecha Lanzamiento
                      </label>
                      <input
                        type="date"
                        name="fecha_lanzamiento"
                        value={formData.fecha_lanzamiento || ""}
                        onChange={handleChange}
                        className="border-0 px-3 py-3 placeholder-gray-500 text-white bg-gray-800 rounded-lg text-sm shadow focus:outline-none focus:ring-2 focus:ring-green-400 w-full ease-linear transition-all duration-150"
                      />
                    </div>
                  </div>
                  <div className="w-full lg:w-6/12 px-4">
                    <div className="relative w-full mb-3">
                      <label className="block uppercase text-gray-400 text-xs font-bold mb-2">
                        ID de Disquera
                      </label>
                      <input
                        type="number"
                        name="disquera"
                        value={formData.disquera || ""}
                        onChange={handleChange}
                        className="border-0 px-3 py-3 placeholder-gray-500 text-white bg-gray-800 rounded-lg text-sm shadow focus:outline-none focus:ring-2 focus:ring-green-400 w-full ease-linear transition-all duration-150"
                      />
                    </div>
                  </div>
                </div>
                <div className="flex justify-center mt-6">
                  <button
                    className="bg-green-500 text-gray-900 active:bg-green-600 font-bold uppercase text-sm px-6 py-3 rounded-full shadow hover:shadow-lg outline-none focus:outline-none ease-linear transition-all duration-150"
                    type="submit"
                  >
                    Guardar
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
