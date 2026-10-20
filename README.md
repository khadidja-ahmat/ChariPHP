# ChariPHP – Générateur de back-office en PHP natif

ChariPHP est un petit générateur que j'ai écrit pour créer rapidement l'administration d'un site en **PHP natif** (sans framework) : un projet complet avec connexion, tableau de bord et menu, puis un module de gestion (liste, ajout, modification, suppression) pour chaque table MySQL.

Exemple d'utilisation : [Clinique Espoir – version ChariPHP](https://github.com/khadidja-ahmat/Clinique-Espoir-ChariPHP).

## Ce que ça génère

- **Un projet** : dossier `admin/`, page de connexion et déconnexion, installation du premier administrateur (`config/install.php`), configuration de la base (`config/database.php`), menu latéral et tableau de bord.
- **Un module par table** : page de liste (tableau avec recherche et tri), formulaires d'ajout et de modification, suppression, le tout en AJAX. Les colonnes sont lues automatiquement dans MySQL.
- **Un code sans dépendance** : PDO avec requêtes préparées, jeton CSRF, sessions, mots de passe hachés en bcrypt.

## Utilisation (démonstration)

Prérequis : PHP 8+ avec `pdo_mysql`, MySQL ou MariaDB, un serveur local (XAMPP, WAMP, Laragon…).

1. Copiez le dossier `ChariPHP` dans le dossier de votre serveur local (par exemple `htdocs`).
2. Créez une base de données MySQL.
3. Ouvrez `http://localhost/ChariPHP/` dans le navigateur.
4. Remplissez le formulaire « Nouveau projet » (nom du dossier et accès à la base) : le projet est créé **à côté** du dossier `ChariPHP`.
5. Ouvrez `http://localhost/<nom_du_projet>/config/install.php` pour créer le compte administrateur, puis connectez-vous sur `login.php`.
6. Pour chaque table, retournez sur `ChariPHP`, choisissez votre projet, donnez un nom de module et la table MySQL associée : le module apparaît dans le menu de l'administration.

## Structure

```
index.php        Interface du générateur
forge.php        Création des projets et des modules
templates/
  project/       Modèle d'un projet (connexion, menu, configuration...)
  module/        Modèle d'un module (liste, formulaire, traitement AJAX)
```

## Sécurité

Le générateur est un **outil de développement** : ne le laissez pas accessible sur un serveur public. Supprimez ou protégez le dossier `ChariPHP` en production, et supprimez `config/install.php` des projets une fois l'administrateur créé.

