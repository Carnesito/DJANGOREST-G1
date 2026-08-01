import React from "react";
import { Route, Redirect } from "react-router-dom";
import { isAuthenticated } from "../../services/authService";

export default function ProtectedRoute({ component: Component, ...rest }) {
  return (
    <Route
      {...rest}
      render={(props) =>
        isAuthenticated() ? (
          <Component {...props} />
        ) : (
          <Redirect to="/auth/login" />
        )
      }
    />
  );
}
