// nota breve 19
import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter, Route, Switch, Redirect, HashRouter } from "react-router-dom";

import "@fortawesome/fontawesome-free/css/all.min.css";
import "assets/styles/index.css";

// layouts

import Admin from "layouts/Admin";
import Auth from "layouts/Auth";

// views without layouts

import Landing from "views/Landing";
import Profile from "views/Profile";
import Index from "views/Index";

import ProtectedRoute from "components/Auth/ProtectedRoute";

ReactDOM.render(
  <BrowserRouter>
    <Switch>
      {/* add routes with layouts */}
      <ProtectedRoute path="/dashboard" component={Admin} />
      <Route path="/auth" component={Auth} />
      {/* add routes without layouts */}
      <Route path="/landing" exact component={Landing} />
      <Route path="/profile" exact component={Profile} />
      <Redirect from="/" exact to="/auth/login" />
      {/* add redirect for first page */}
      <Redirect from="*" to="/dashboard" />
    </Switch>
  </BrowserRouter>,
  document.getElementById("root")
);
