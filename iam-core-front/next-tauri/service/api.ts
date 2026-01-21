import axios from "axios";

const api = axios.create({
  baseURL: "http://localhost:8080/iam-core", // tu backend Spring Boot
});

export const login = async (username: string, password: string) => {
  const response = await api.post("/auth/login", { username, password });
  return response.data; // { accessToken, refreshToken }
};

export default api;

