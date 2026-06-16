import React, { useEffect, useState } from 'react'
import { Container, Typography, Paper, Table, TableHead, TableRow, TableCell, TableBody, Button } from '@mui/material'
import api from '../api'

type OwnerApp = {
  id: string
  fullName: string
  phone: string
  status: string
  shop: { id: string; name: string; address: string; city: string; district?: string } | null
  createdAt: string
}

export default function OwnerApplications() {
  const [apps, setApps] = useState<OwnerApp[]>([])
  const navigate = useNavigate()

  useEffect(() => {
    fetchApps()
  }, [])

  const fetchApps = async () => {
    try {
      const res = await api.get('/admin/owner-applications')
      setApps(res.data)
    } catch (err) {
      console.error(err)
      alert('Failed to fetch owner applications (ensure admin auth)')
    }
  }

  const action = async (id: string, approve = true) => {
    try {
      await api.patch(`/admin/owner-applications/${id}/${approve ? 'approve' : 'reject'}`)
      fetchApps()
    } catch (err) {
      console.error(err)
      alert('Action failed')
    }
  }

  return (
    <Container maxWidth="lg">
      <Button sx={{ float: 'right', mt: 2 }} variant="outlined" color="secondary" onClick={() => {
        const refresh = localStorage.getItem('refresh_token')
        const access = localStorage.getItem('access_token')
        if (access) {
          // call logout endpoint
          api.post('/auth/logout', { token: refresh }).catch(() => {})
        }
        localStorage.removeItem('access_token')
        localStorage.removeItem('refresh_token')
        navigate('/login')
      }}>
        Logout
      </Button>
      <Typography variant="h4" sx={{ mt: 4, mb: 2 }}>
        Owner Applications
      </Typography>
      <Paper>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Applicant</TableCell>
              <TableCell>Shop</TableCell>
              <TableCell>Address</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {apps.map((a) => (
              <TableRow key={a.id}>
                <TableCell>{a.fullName}<br />{a.phone}</TableCell>
                <TableCell>{a.shop?.name ?? '-'}</TableCell>
                <TableCell>{a.shop ? `${a.shop.address}, ${a.shop.city}` : '-'}</TableCell>
                <TableCell>{a.status}</TableCell>
                <TableCell>
                  <Button variant="contained" color="primary" size="small" onClick={() => action(a.id, true)} sx={{ mr: 1 }}>
                    Approve
                  </Button>
                  <Button variant="outlined" color="error" size="small" onClick={() => action(a.id, false)}>
                    Reject
                  </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </Paper>
    </Container>
  )
}
