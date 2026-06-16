import React from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import Login from './pages/Login'
import OwnerApplications from './pages/OwnerApplications'

export default function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/owner-applications" element={<OwnerApplications />} />
      <Route path="/" element={<Navigate to="/owner-applications" replace />} />
    </Routes>
  )
}
