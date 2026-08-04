import React, { useState, useEffect } from "react";
import { useHistory, useParams, Link } from "react-router-dom";
import { createArtista, getArtista, updateArtista } from "../../services/artista/artistaService";

export default function ArtistaForm() {
  const [formData, setFormData] = useState({});
  const history = useHistory();
  const { id } = useParams();

  useEffect(() => {
    if (id) {
      fetchArtista();
    }
  }, [id]);

  const fetchArtista = async () => {
    try {
      const res = await getArtista(id);
      setFormData(res);
    } catch (error) {
      console.error("Error al cargar artista:", error);
    }
  };

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      if (id) {
        await updateArtista(id, formData);
      } else {
        await createArtista(formData);
      }
      history.push("/dashboard/artistas");
    } catch (error) {
      console.error("Error al guardar artista:", error);
    }
  };

  return (
    <>
      <div className="flex flex-wrap mt-4">
        <div className="w-full mb-12 px-4">
          <div className="relative flex flex-col min-w-0 break-words w-full mb-6 shadow-xl rounded-lg bg-gray-900 text-green-200">
            <div className="rounded-t mb-0 px-4 py-4 border-0 bg-gray-800">
              <div className="flex flex-wrap items-center">
                <div className="relative w-full px-4 max-w-full flex-grow flex-1">
                  <h3 className="font-bold text-xl text-green-400" style={{ fontSize: '24px' }}>
                    {id ? "Editar Artista" : "Crear Artista"}
                  </h3>
                </div>
                <div className="relative w-full px-4 max-w-full flex-grow flex-1 text-right">
                  <Link
                    to="/dashboard/artistas"
                    className="bg-green-500 hover:bg-green-400 text-gray-900 text-sm font-bold uppercase px-4 py-2 rounded-full shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                  >
                    Volver
                  </Link>
                </div>
              </div>
            </div>
            <div className="flex-auto px-4 lg:px-10 py-10 pt-0">
              <form onSubmit={handleSubmit}>
                <div className="flex flex-wrap">
                  <div className="w-full lg:w-6/12 px-4">
                    <div className="relative w-full mb-3">
                      <label className="block uppercase text-green-300 text-xs font-bold mb-2">
                        Nombre Artístico
                      </label>
                      <input
                        type="text"
                        name="nombre_artistico"
                        value={formData.nombre_artistico || ""}
                        onChange={handleChange}
                        className="border-0 px-3 py-3 placeholder-gray-500 text-green-200 bg-gray-800 rounded-lg text-sm shadow focus:outline-none focus:ring-2 focus:ring-green-400 w-full ease-linear transition-all duration-150"
                      />
                    </div>
                  </div>
                  <div className="w-full lg:w-6/12 px-4">
                    <div className="relative w-full mb-3">
                      <label className="block uppercase text-green-300 text-xs font-bold mb-2">
                        Género Principal
                      </label>
                      <input
                        type="text"
                        name="genero_principal"
                        value={formData.genero_principal || ""}
                        onChange={handleChange}
                        className="border-0 px-3 py-3 placeholder-gray-500 text-green-200 bg-gray-800 rounded-lg text-sm shadow focus:outline-none focus:ring-2 focus:ring-green-400 w-full ease-linear transition-all duration-150"
                      />
                    </div>
                  </div>
                  <div className="w-full lg:w-6/12 px-4">
                    <div className="relative w-full mb-3">
                      <label className="block uppercase text-green-300 text-xs font-bold mb-2">
                        Año de Inicio
                      </label>
                      <input
                        type="number"
                        name="anio_inicio"
                        value={formData.anio_inicio || ""}
                        onChange={handleChange}
                        className="border-0 px-3 py-3 placeholder-gray-500 text-green-200 bg-gray-800 rounded-lg text-sm shadow focus:outline-none focus:ring-2 focus:ring-green-400 w-full ease-linear transition-all duration-150"
                      />
                    </div>
                  </div>
                </div>
                <div className="text-right mt-6">
                  <button
                    type="submit"
                    className="bg-green-500 hover:bg-green-400 text-gray-900 active:bg-green-700 text-sm font-bold uppercase px-6 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
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
