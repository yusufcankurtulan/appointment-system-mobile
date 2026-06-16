import React, { useState } from 'react'
import { Container, Box, TextField, Button, Typography } from '@mui/material'
import api from '../api'
import { useNavigate } from 'react-router-dom'

export default function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()

  const handle = async () => {
    setLoading(true)
    try {
      const res = await api.post('/auth/login/admin', { email, password })
      const { accessToken } = res.data
      if (accessToken) {
        localStorage.setItem('access_token', accessToken)
        if (res.data.refreshToken) localStorage.setItem('refresh_token', res.data.refreshToken)
        navigate('/owner-applications')
      } else {
        alert('No access token returned')
      }
    } catch (err: any) {
      console.error(err)
      alert(err?.response?.data?.message || 'Login failed')
    } finally {
      setLoading(false)
    }
  }

  return (
    <Container maxWidth="sm">
      <Box sx={{ mt: 8 }}>
        <Typography variant="h4" gutterBottom>
          Admin Login
        </Typography>
        <TextField label="Email" fullWidth margin="normal" value={email} onChange={(e) => setEmail(e.target.value)} />
        <TextField label="Password" type="password" fullWidth margin="normal" value={password} onChange={(e) => setPassword(e.target.value)} />
        <Button variant="contained" fullWidth sx={{ mt: 2 }} onClick={handle} disabled={loading}>
          {loading ? 'Signing in...' : 'Login'}
        </Button>
      </Box>
    </Container>
  )
}
