import axios from 'axios'

const api = axios.create({ baseURL: process.env.REACT_APP_API_URL || 'http://localhost:4000' })

// Attach access token from localStorage for admin requests
api.interceptors.request.use((config) => {
	try {
		const token = localStorage.getItem('access_token');
		if (token && config.headers) {
			(config.headers as any)['Authorization'] = `Bearer ${token}`
		}
	} catch (err) {
		// ignore
	}
	return config
})

// Response interceptor: if 401, try refresh with refresh token and retry once
let isRefreshing = false;
let refreshQueue: Array<(token?: string) => void> = [];

async function refreshToken(): Promise<string | null> {
	const refresh = localStorage.getItem('refresh_token');
	if (!refresh) return null;
	try {
		const res = await axios.post((process.env.REACT_APP_API_URL || 'http://localhost:4000') + '/auth/refresh', { token: refresh });
		const newAccess = res.data.accessToken;
		if (newAccess) {
			localStorage.setItem('access_token', newAccess);
			return newAccess;
		}
		return null;
	} catch (err) {
		return null;
	}
}

api.interceptors.response.use(
	(r) => r,
	async (error) => {
		const original = error.config;
		if (error.response && error.response.status === 401 && !original._retry) {
			if (isRefreshing) {
				// queue request
				return new Promise((resolve, reject) => {
					refreshQueue.push((token?: string) => {
						if (token) {
							original.headers['Authorization'] = `Bearer ${token}`;
							resolve(axios(original));
						} else {
							reject(error);
						}
					});
				});
			}
			original._retry = true;
			isRefreshing = true;
			const newToken = await refreshToken();
			isRefreshing = false;
			refreshQueue.forEach((cb) => cb(newToken));
			refreshQueue = [];
			if (newToken) {
				original.headers['Authorization'] = `Bearer ${newToken}`;
				return axios(original);
			}
		}
		return Promise.reject(error);
	}
)

export default api
