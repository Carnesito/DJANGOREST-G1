import React, { useState, useEffect } from "react";
import { useHistory, useParams, Link } from "react-router-dom";
import { createAlbum, getAlbum, updateAlbum } from "../../services/album/albumService";

