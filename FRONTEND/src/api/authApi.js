// =============================================================
// src/api/authApi.js — API d'authentification (simulée avec mock data)
// ⚠️ LIAISON BACKEND : Remplacer les Promises mock par des appels Axios réels
// =============================================================
import axiosInstance from './axiosInstance'

// Simulation d'un délai réseau réaliste (en ms)
const delay = (ms) => new Promise((res) => setTimeout(res, ms))

// Données utilisateurs fictifs pour la démonstration (modifié en `let` pour permettre la modification)
let MOCK_USERS = [
  {
    id: 1,
    name: 'Amara Diallo',
    email: 'citoyen@ecokinshasa.cd',
    password: 'password123',
    role: 'citoyen',
    commune: 'Gombe',
    phone: '+243 81 234 5678',
    avatar: null,
    token: 'mock-citizen-token-2024',
    stats: { signalements: 12, resolus: 8, enCours: 4 },
  },
  {
    id: 2,
    name: 'Inspecteur Kabila Mwamba',
    email: 'autorite@ecokinshasa.cd',
    password: 'admin2024',
    role: 'autorite',
    commune: 'Mairie de Kinshasa',
    phone: '+243 99 876 5432',
    avatar: null,
    token: 'mock-authority-token-2024',
    stats: { geres: 87, urgences: 5, communes: 24 },
  },
  {
    id: 3,
    name: 'Super Admin',
    email: 'superadmin@ecokinshasa.cd',
    password: 'superadmin2024',
    role: 'superadmin', // Nouveau rôle
    commune: 'Niveau National',
    phone: '+243 80 000 0000',
    avatar: null,
    token: 'mock-superadmin-token-2024',
    stats: {}, // Pas besoin de stats pour le moment pour ce compte
  }
]

/**
 * login — Authentifie un utilisateur par email et mot de passe
 * 🔧 BACKEND: Remplacer par axiosInstance.post('auth/login/', { email, password })
 * @param {string} email
 * @param {string} password
 * @returns {Promise<Object>} - Les données de l'utilisateur connecté
 */
export const login = async (email, password) => {
  await delay(800) // Simule la latence réseau
  const found = MOCK_USERS.find((u) => u.email === email && u.password === password)
  if (!found) throw new Error('Email ou mot de passe incorrect')
  // Retourne l'utilisateur sans le mot de passe
  const { password: _, ...userWithoutPassword } = found
  return userWithoutPassword
}

/**
 * register — Enregistre un nouvel utilisateur
 * 🔧 BACKEND: Remplacer par axiosInstance.post('auth/register/', formData)
 * @param {Object} data - Les données du formulaire d'inscription
 * @returns {Promise<Object>} - Les données de l'utilisateur créé
 */
export const register = async (data) => {
  await delay(1000)
  // Vérifie si l'email n'est pas déjà utilisé
  const exists = MOCK_USERS.find((u) => u.email === data.email)
  if (exists) throw new Error('Cet email est déjà utilisé')
  // Crée un nouvel utilisateur mock
  const newUser = {
    id: Date.now(),
    name: `${data.prenom || ''} ${data.nom || ''}`.trim() || data.name,
    email: data.email,
    password: data.password || 'default123',
    role: data.role || 'citoyen',
    commune: data.commune || 'Inconnue',
    phone: data.phone || '',
    avatar: null,
    token: `mock-token-${Date.now()}`,
    stats: { signalements: 0, resolus: 0, enCours: 0 },
  }
  MOCK_USERS.push(newUser) // Ajoute l'utilisateur à notre mock DB
  
  const { password, ...userWithoutPassword } = newUser
  return userWithoutPassword
}

/**
 * updateProfile — Met à jour les informations du profil utilisateur
 * 🔧 BACKEND: Remplacer par axiosInstance.patch('auth/profile/', formData)
 * @param {Object|FormData} data - Les nouvelles données du profil
 * @returns {Promise<Object>} - Le profil mis à jour
 */
export const updateProfile = async (data) => {
  await delay(700)
  return { ...data, updated: true }
}

// =============================================================
// NOUVELLES MÉTHODES POUR LE SUPER ADMINISTRATEUR
// =============================================================

/**
 * getAllUsers — Récupère tous les utilisateurs (Super Admin uniquement)
 * 🔧 BACKEND: Remplacer par axiosInstance.get('admin/users/')
 * @returns {Promise<Array>} - Liste des utilisateurs
 */
export const getAllUsers = async () => {
  await delay(500)
  // Retourne les utilisateurs sans le mot de passe pour des raisons de sécurité
  return MOCK_USERS.map(({ password, ...user }) => user)
}

/**
 * deleteUser — Supprime un utilisateur (citoyen ou autorité) par son ID
 * 🔧 BACKEND: Remplacer par axiosInstance.delete(`admin/users/${id}`)
 * @param {number} id - L'identifiant de l'utilisateur à supprimer
 */
export const deleteUser = async (id) => {
  await delay(600)
  MOCK_USERS = MOCK_USERS.filter((user) => user.id !== id)
  return true
}

/**
 * createAuthorityAccount — Crée un compte pour une nouvelle autorité
 * 🔧 BACKEND: Remplacer par axiosInstance.post('admin/authorities/', data)
 * @param {Object} data - Données de la nouvelle autorité
 */
export const createAuthorityAccount = async (data) => {
  // On réutilise register en forçant le rôle
  return register({ ...data, role: 'autorite' })
}
