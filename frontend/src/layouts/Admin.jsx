// nota breve 20
import React from "react";
import { Switch, Route, Redirect } from "react-router-dom";

// components

import AdminNavbar from "components/Navbars/AdminNavbar";
import Sidebar from "components/Sidebar/Sidebar";
import HeaderStats from "components/Headers/HeaderStats";
import FooterAdmin from "components/Footers/FooterAdmin";

// views

import Dashboard from "pages/dashboard";
import Disqueras from "pages/disquera/Disqueras";
import DisqueraForm from "pages/disquera/DisqueraForm";
import Artistas from "pages/artista/Artistas";
import ArtistaForm from "pages/artista/ArtistaForm";
import Albumes from "pages/album/Albumes";
import AlbumForm from "pages/album/AlbumForm";
import Canciones from "pages/cancion/Canciones";
import CancionForm from "pages/cancion/CancionForm";
import Generos from "pages/genero/Generos";
import GeneroForm from "pages/genero/GeneroForm";
import Usuarios from "pages/usuario/Usuarios";
import UsuarioForm from "pages/usuario/UsuarioForm";

export default function Admin() {
  return (
    <>
      <Sidebar />
      <div className="relative md:ml-64 bg-blueGray-100">
        <AdminNavbar />
        {/* Header */}
        <HeaderStats />
        <div className="px-4 md:px-10 mx-auto w-full -m-24">
          <Switch>
            <Route path="/dashboard" exact component={Dashboard} />
            <Route path="/dashboard/disqueras" exact component={Disqueras} />
            <Route path="/dashboard/disqueras/crear" exact component={DisqueraForm} />
            <Route path="/dashboard/disqueras/editar/:id" exact component={DisqueraForm} />
            <Route path="/dashboard/artistas" exact component={Artistas} />
            <Route path="/dashboard/artistas/crear" exact component={ArtistaForm} />
            <Route path="/dashboard/artistas/editar/:id" exact component={ArtistaForm} />
            <Route path="/dashboard/albumes" exact component={Albumes} />
            <Route path="/dashboard/albumes/crear" exact component={AlbumForm} />
            <Route path="/dashboard/albumes/editar/:id" exact component={AlbumForm} />
            <Route path="/dashboard/canciones" exact component={Canciones} />
            <Route path="/dashboard/canciones/crear" exact component={CancionForm} />
            <Route path="/dashboard/canciones/editar/:id" exact component={CancionForm} />
            <Route path="/dashboard/generos" exact component={Generos} />
            <Route path="/dashboard/generos/crear" exact component={GeneroForm} />
            <Route path="/dashboard/generos/editar/:id" exact component={GeneroForm} />
            <Route path="/dashboard/usuarios" exact component={Usuarios} />
            <Route path="/dashboard/usuarios/crear" exact component={UsuarioForm} />
            <Route path="/dashboard/usuarios/editar/:id" exact component={UsuarioForm} />
            <Redirect from="/admin" to="/dashboard" />
          </Switch>
          <FooterAdmin />
        </div>
      </div>
    </>
  );
}
