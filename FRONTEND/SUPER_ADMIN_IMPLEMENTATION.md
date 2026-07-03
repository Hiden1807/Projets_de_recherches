# Implémentation du Rôle Super Administrateur

Ce document explique comment le rôle **Super Administrateur** a été implémenté dans la plateforme EcoRDC.

## 1. Objectif du Rôle
Le Super Administrateur dispose d'une vue globale sur la plateforme. Il est capable de consulter les statistiques générales (Citoyens, Autorités, Incidents) et de gérer les utilisateurs (suppression des comptes existants, création de nouveaux comptes pour les autorités).

## 2. Architecture et Fichiers Modifiés

L'ajout de ce rôle s'est appuyé sur les composants et concepts clés suivants de l'application React :

### a) Gestion des Données Fictives (Mocks) et API
- **Fichier :** `src/api/authApi.js`
- **Modifications :** 
  - La liste constante `MOCK_USERS` a été convertie en `let` pour permettre d'y ajouter et supprimer des éléments localement.
  - Ajout d'un compte de démonstration pour le superadmin (`superadmin@ecokinshasa.cd`).
  - Ajout des fonctions spécifiques à l'administration :
    - `getAllUsers()` : Retourne la liste complète des utilisateurs enregistrés sans leurs mots de passe.
    - `deleteUser(id)` : Permet de supprimer un utilisateur de la base fictive en fonction de son ID.
    - `createAuthorityAccount(data)` : Fonction simplifiée utilisant la logique d'inscription existante (`register`) mais forçant l'attribution du rôle `autorite`.

### b) API du Tableau de Bord
- **Fichier :** `src/api/dashboardApi.js`
- **Modifications :**
  - Ajout de la fonction `getStatsSuperAdmin()` qui simule un appel backend pour récupérer les statistiques à l'échelle de toute la plateforme (total citoyens, autorités, taux de résolution global, etc.).

### c) Système de Routage
- **Fichier :** `src/routes/AppRoutes.jsx`
- **Modifications :**
  - Ajout d'une nouvelle page `SuperAdminDashboard` importée de `../pages/SuperAdminDashboard`.
  - Intégration de cette page dans la zone protégée `DashboardLayout`, accessible *uniquement* si l'utilisateur connecté possède le rôle `superadmin` via le composant `PrivateRoute`.
  - Amélioration de la fonction de redirection (`getDefaultRoute`) pour rediriger correctement le Super Administrateur lors de ses connexions.

### d) Interface Utilisateur et Navigation
- **Fichiers :** `src/components/Sidebar.jsx` et `src/pages/Login.jsx`
- **Modifications :**
  - **Sidebar :** Un nouveau sous-menu (`menuSuperAdmin`) a été créé. Il s'affiche automatiquement lorsque le rôle détecté est `superadmin`. Un badge spécifique avec l'icône de couronne 👑 s'affiche pour ce rôle.
  - **Login :** Le compte de démonstration du Super Administrateur a été ajouté sous forme de bouton pour faciliter les tests de la fonctionnalité.

### e) Composant Principal : Le Tableau de Bord Super Admin
- **Fichier :** `src/pages/SuperAdminDashboard.jsx` (Nouveau)
- **Rôle :**
  - C'est le cœur de l'implémentation. Ce composant est composé :
    1. **D'un en-tête global :** Il affiche des `StatCard` (cartes de statistiques) alimentées par `getStatsSuperAdmin()`.
    2. **D'un tableau de gestion :** Une liste exhaustive des utilisateurs récupérée par `getAllUsers()`. Chaque ligne (sauf celles des Super Admins) possède un bouton de suppression appelant `deleteUser()`.
    3. **D'une Modal de Création :** Un formulaire interactif qui appelle `createAuthorityAccount()` pour générer instantanément de nouveaux comptes "Autorité".

## 3. Comprendre le Code

Tous les nouveaux fichiers et modifications ont été largement commentés :
- Des balises de description (JSDoc) précisent le rôle des nouvelles fonctions d'API.
- Les étapes de rendu React dans `SuperAdminDashboard.jsx` sont séparées par des titres clairs (`EN-TÊTE`, `STATISTIQUES GLOBALES`, `GESTION DES UTILISATEURS`).
- Des gardes-fous ont été mis en place (ex: un admin ne peut pas se supprimer lui-même, confirmation requise avant suppression).

## 4. Prochaines Étapes (Pour la Liaison Backend)

L'application utilise actuellement des données `mock`. Lors de l'intégration avec votre vrai backend (ex: Node.js, Django, Laravel), il suffira de :
1. Chercher les commentaires `🔧 BACKEND:` dans les fichiers d'API.
2. Décommenter/remplacer le code fictif par de vrais appels `axiosInstance.post(...)` ou `axiosInstance.delete(...)`.
3. S'assurer que le backend vérifie rigoureusement les droits (`middlewares` d'authentification) avant d'autoriser la création ou suppression de comptes via ces endpoints.
