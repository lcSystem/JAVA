import jwt_decode from "jwt-decode";

export const setToken = (token: string) => {
  localStorage.setItem("accessToken", token);
};

export const getToken = () => localStorage.getItem("accessToken");

export const decodeToken = (token: string) => jwt_decode(token);

export const logout = () => {
  localStorage.removeItem("accessToken");
};

