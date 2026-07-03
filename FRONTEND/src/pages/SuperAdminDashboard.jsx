// =============================================================
// src/pages/SuperAdminDashboard.jsx — Tableau de bord global
// Réservé au Super Administrateur. Permet de voir les stats
// globales et de gérer les utilisateurs (citoyens et autorités).
// =============================================================
import React, { useState, useEffect } from 'react'
import { getStatsSuperAdmin } from '../api/dashboardApi'
import { getAllUsers, deleteUser, createAuthorityAccount } from '../api/authApi'
import Loader, { InlineLoader } from '../components/Loader' // Loader (default) + InlineLoader (named)

const SuperAdminDashboard = () => {
  // États pour les données
  const [stats, setStats] = useState(null)
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)
  
  // États pour les actions (suppression, création)
  const [actionLoading, setActionLoading] = useState(false)
  const [showCreateModal, setShowCreateModal] = useState(false)
  const [newAuthority, setNewAuthority] = useState({ name: '', email: '', commune: '', phone: '' })
  const [message, setMessage] = useState(null) // { type: 'success' | 'error', text: '' }

  /**
   * fetchData — Charge les statistiques globales et la liste des utilisateurs
   */
  const fetchData = async () => {
    setLoading(true)
    try {
      const [statsData, usersData] = await Promise.all([
        getStatsSuperAdmin(),
        getAllUsers(),
      ])
      setStats(statsData)
      setUsers(usersData)
    } catch (error) {
      console.error('Erreur lors du chargement des données:', error)
      setMessage({ type: 'error', text: 'Impossible de charger les données.' })
    } finally {
      setLoading(false)
    }
  }

  // Chargement initial
  useEffect(() => {
    fetchData()
  }, [])

  /**
   * handleDeleteUser — Supprime un utilisateur après confirmation
   * @param {number} id - ID de l'utilisateur
   * @param {string} name - Nom pour le message de confirmation
   */
  const handleDeleteUser = async (id, name) => {
    if (!window.confirm(`Êtes-vous sûr de vouloir supprimer le compte de ${name} ? Cette action est irréversible.`)) {
      return
    }

    setActionLoading(true)
    try {
      await deleteUser(id)
      setMessage({ type: 'success', text: `L'utilisateur ${name} a été supprimé avec succès.` })
      // Met à jour la liste localement
      setUsers(users.filter(u => u.id !== id))
    } catch (error) {
      setMessage({ type: 'error', text: `Erreur lors de la suppression de ${name}.` })
    } finally {
      setActionLoading(false)
    }
  }

  /**
   * handleCreateAuthority — Gère la soumission du formulaire de création d'autorité
   */
  const handleCreateAuthority = async (e) => {
    e.preventDefault()
    setActionLoading(true)
    try {
      const newUser = await createAuthorityAccount(newAuthority)
      setMessage({ type: 'success', text: `Le compte autorité pour ${newUser.name} a été créé.` })
      setShowCreateModal(false)
      setNewAuthority({ name: '', email: '', commune: '', phone: '' })
      // Recharger les données pour inclure le nouvel utilisateur
      fetchData()
    } catch (error) {
      setMessage({ type: 'error', text: error.message || 'Erreur lors de la création du compte.' })
    } finally {
      setActionLoading(false)
    }
  }

  if (loading) return <Loader message="Chargement de l'espace global..." fullScreen />

  return (
    <div className="container-fluid py-4 animate-fade-in">
      {/* ==================== EN-TÊTE ==================== */}
      <div className="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
          <h1 className="h3 fw-bold mb-1" style={{ color: 'var(--eco-text-primary)' }}>
            <i className="bi bi-globe2 me-2" style={{ color: 'var(--eco-accent)' }}></i>
            Plateforme Globale EcoRDC
          </h1>
          <p className="mb-0 text-muted">Vue d'ensemble et gestion des comptes utilisateurs</p>
        </div>
        <button 
          className="btn btn-eco shadow-sm"
          onClick={() => setShowCreateModal(true)}
        >
          <i className="bi bi-person-plus-fill me-2"></i>
          Nouvelle Autorité
        </button>
      </div>

      {/* Affichage des messages de succès/erreur */}
      {message && (
        <div className={`alert ${message.type === 'success' ? 'alert-success' : 'alert-danger'} alert-dismissible fade show`} role="alert">
          {message.type === 'success' ? <i className="bi bi-check-circle-fill me-2"></i> : <i className="bi bi-exclamation-triangle-fill me-2"></i>}
          {message.text}
          <button type="button" className="btn-close" onClick={() => setMessage(null)}></button>
        </div>
      )}

      {/* ==================== STATISTIQUES GLOBALES ==================== */}
      <div className="row g-4 mb-5">
        <div className="col-12 col-sm-6 col-lg-3">
          <StatCard title="Total Citoyens" value={stats?.totalCitoyens.toLocaleString()} icon="bi-people-fill" color="#4caf80" />
        </div>
        <div className="col-12 col-sm-6 col-lg-3">
          <StatCard title="Autorités Urbaines" value={stats?.totalAutorites} icon="bi-shield-fill-check" color="#2196f3" />
        </div>
        <div className="col-12 col-sm-6 col-lg-3">
          <StatCard title="Total Signalements" value={stats?.signalementsGlobaux.toLocaleString()} icon="bi-collection-fill" color="#ff9800" />
        </div>
        <div className="col-12 col-sm-6 col-lg-3">
          <StatCard title="Incidents Critiques" value={stats?.incidentsCritiques} icon="bi-exclamation-triangle-fill" color="#f44336" />
        </div>
      </div>

      {/* ==================== GESTION DES UTILISATEURS ==================== */}
      <div className="card eco-card shadow-sm border-0">
        <div className="card-header bg-transparent border-0 pt-4 pb-0 px-4">
          <h5 className="fw-bold mb-0" style={{ color: 'var(--eco-text-primary)' }}>Gestion des Comptes</h5>
        </div>
        <div className="card-body p-4">
          <div className="table-responsive">
            <table className="table table-hover align-middle">
              <thead>
                <tr>
                  <th>Utilisateur</th>
                  <th>Rôle</th>
                  <th>Email</th>
                  <th>Commune</th>
                  <th className="text-end">Actions</th>
                </tr>
              </thead>
              <tbody>
                {users.map(user => (
                  <tr key={user.id}>
                    <td>
                      <div className="d-flex align-items-center gap-3">
                        <div 
                          className="rounded-circle d-flex align-items-center justify-content-center text-white fw-bold"
                          style={{ width: 40, height: 40, background: user.role === 'autorite' ? '#2196f3' : (user.role === 'superadmin' ? '#9c27b0' : '#4caf80') }}
                        >
                          {user.name.charAt(0).toUpperCase()}
                        </div>
                        <div className="fw-semibold text-truncate" style={{ maxWidth: 200, color: 'var(--eco-text-primary)' }}>
                          {user.name}
                        </div>
                      </div>
                    </td>
                    <td>
                      <span className={`badge rounded-pill ${
                        user.role === 'autorite' ? 'bg-primary' : (user.role === 'superadmin' ? 'bg-purple' : 'bg-success')
                      }`} style={user.role === 'superadmin' ? { backgroundColor: '#9c27b0' } : {}}>
                        {user.role}
                      </span>
                    </td>
                    <td className="text-muted">{user.email}</td>
                    <td>{user.commune}</td>
                    <td className="text-end">
                      {/* On empêche le Super Admin de se supprimer lui-même (ou les autres super admins s'il y en a) */}
                      {user.role !== 'superadmin' && (
                        <button 
                          className="btn btn-sm btn-outline-danger" 
                          title="Supprimer le compte"
                          onClick={() => handleDeleteUser(user.id, user.name)}
                          disabled={actionLoading}
                        >
                          <i className="bi bi-trash-fill"></i>
                        </button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* ==================== MODAL CRÉATION AUTORITÉ ==================== */}
      {showCreateModal && (
        <div className="modal show d-block" style={{ backgroundColor: 'rgba(0,0,0,0.5)', zIndex: 1050 }}>
          <div className="modal-dialog modal-dialog-centered">
            <div className="modal-content border-0 shadow" style={{ background: 'var(--eco-bg-primary)' }}>
              <div className="modal-header border-bottom-0 pb-0">
                <h5 className="modal-title fw-bold" style={{ color: 'var(--eco-text-primary)' }}>
                  <i className="bi bi-shield-plus text-primary me-2"></i>
                  Créer un compte Autorité
                </h5>
                <button type="button" className="btn-close" onClick={() => setShowCreateModal(false)}></button>
              </div>
              <div className="modal-body p-4">
                <form onSubmit={handleCreateAuthority}>
                  <div className="mb-3">
                    <label className="form-label text-muted fw-semibold small">Nom de l'autorité / Inspecteur</label>
                    <input 
                      type="text" 
                      className="eco-input" 
                      required 
                      value={newAuthority.name}
                      onChange={(e) => setNewAuthority({...newAuthority, name: e.target.value})}
                    />
                  </div>
                  <div className="mb-3">
                    <label className="form-label text-muted fw-semibold small">Adresse Email Pro</label>
                    <input 
                      type="email" 
                      className="eco-input" 
                      required 
                      value={newAuthority.email}
                      onChange={(e) => setNewAuthority({...newAuthority, email: e.target.value})}
                    />
                  </div>
                  <div className="mb-3">
                    <label className="form-label text-muted fw-semibold small">Mot de passe</label>
                    <input 
                      type="password" 
                      className="eco-input" 
                      required 
                      value={newAuthority.password || ''}
                      onChange={(e) => setNewAuthority({...newAuthority, password: e.target.value})}
                    />
                  </div>
                  <div className="mb-3">
                    <label className="form-label text-muted fw-semibold small">Commune de juridiction</label>
                    <select 
                      className="eco-input" 
                      required
                      value={newAuthority.commune}
                      onChange={(e) => setNewAuthority({...newAuthority, commune: e.target.value})}
                    >
                      <option value="">Sélectionner une commune...</option>
                      <option value="Gombe">Gombe</option>
                      <option value="Limete">Limete</option>
                      <option value="Ngaliema">Ngaliema</option>
                      <option value="Lemba">Lemba</option>
                      <option value="Kinshasa">Kinshasa</option>
                    </select>
                  </div>
                  <div className="mb-4">
                    <label className="form-label text-muted fw-semibold small">Téléphone</label>
                    <input 
                      type="tel" 
                      className="eco-input"
                      value={newAuthority.phone}
                      onChange={(e) => setNewAuthority({...newAuthority, phone: e.target.value})}
                    />
                  </div>
                  <div className="d-flex justify-content-end gap-2">
                    <button type="button" className="btn btn-light" onClick={() => setShowCreateModal(false)}>Annuler</button>
                    <button type="submit" className="btn btn-primary px-4" disabled={actionLoading}>
                      {actionLoading ? <InlineLoader size="sm" /> : 'Créer le compte'}
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

// Composant utilitaire pour les cartes de statistiques
const StatCard = ({ title, value, icon, color }) => (
  <div className="card eco-card border-0 shadow-sm h-100" style={{ background: 'var(--eco-card-bg)' }}>
    <div className="card-body d-flex align-items-center gap-3">
      <div 
        className="rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" 
        style={{ width: 56, height: 56, background: `${color}15`, color: color, fontSize: '1.5rem' }}
      >
        <i className={icon}></i>
      </div>
      <div>
        <div className="text-muted small fw-semibold text-uppercase" style={{ letterSpacing: '0.5px' }}>{title}</div>
        <div className="fw-bold" style={{ fontSize: '1.5rem', color: 'var(--eco-text-primary)' }}>{value}</div>
      </div>
    </div>
  </div>
)

export default SuperAdminDashboard
