/*
 * /assets/css/style.css
 * Feuille de style principale pour le backend.
 * Généré par ChariPHP
 */

/* ========================================================================= */
/*                           VARIABLES GLOBALES                              */
/* ========================================================================= */
/* C'est le centre de contrôle de l'identité visuelle de l'application. */
:root {
    --bs-primary: {{PRIMARY_COLOR}};
    --bs-secondary: {{SECONDARY_COLOR}};
    --bs-light: #f8f9fa;
    --bs-dark: #212529;
    --bs-primary-rgb: 13, 71, 161;
    --bs-secondary-rgb: 255, 143, 0;
    --font-primary: 'Poppins', sans-serif;
    --body-bg: #f4f6f9; /* Un gris très clair pour le fond */
    --sidebar-width: 260px;
}


/* ========================================================================= */
/*                              STYLES DE BASE                               */
/* ========================================================================= */
body {
    font-family: var(--font-primary);
    background-color: var(--body-bg);
    overflow-x: hidden; /* Empêche le défilement horizontal */
}

/* Structure principale Flexbox */
#wrapper {
    display: flex;
    min-height: 100vh;
}

/* Améliorations visuelles pour les cartes */
.card {
    border: none;
    border-radius: 0.5rem;
    box-shadow: 0 0 1.25rem rgba(31, 45, 61, .08);
}
.card-header {
    background-color: #fff;
    border-bottom: 1px solid #e3e6f0;
    font-weight: 600;
}


/* ========================================================================= */
/*                              SIDEBAR                                      */
/* ========================================================================= */
#sidebar-wrapper {
    width: var(--sidebar-width);
    background-color: var(--bs-primary);
    color: white;
    transition: margin-left 0.3s ease;
}
.sidebar-heading {
    padding: 1rem 1.25rem;
    font-size: 1.5rem;
    font-weight: 700;
    border-bottom: 1px solid rgba(255, 255, 255, 0.15);
}
#sidebar-wrapper .list-group-item {
    background-color: transparent;
    border: 0;
    color: rgba(255, 255, 255, 0.8);
    padding: 1rem 1.5rem;
    font-weight: 500;
    transition: all 0.2s ease-in-out;
    cursor: pointer;
}
#sidebar-wrapper .list-group-item:hover,
#sidebar-wrapper .list-group-item.active {
    background-color: rgba(255, 255, 255, 0.1);
    color: white;
    border-left: 4px solid var(--bs-secondary);
}
#sidebar-wrapper .list-group-item.active {
    background-color: #0b3a82; /* Un bleu légèrement plus foncé pour l'état actif */
}


/* ========================================================================= */
/*                             CONTENU DE LA PAGE                            */
/* ========================================================================= */
#page-content-wrapper {
    flex: 1;
    padding: 1.5rem;
    overflow-x: hidden;
    width: calc(100% - var(--sidebar-width));
}

/* Barre de navigation supérieure */
.navbar {
    border-radius: 0.5rem;
}


/* ========================================================================= */
/*                      INDICATEURS DE CHARGEMENT AJAX                       */
/* ========================================================================= */
/* Gère l'effet de fondu et le blocage des clics lors du chargement d'un module. */
.is-loading #main-content {
    opacity: 0.5;
    pointer-events: none;
    transition: opacity 0.2s;
}

#content-loader {
    display: none; /* Affiché via JS */
}

/* Spinner pour les boutons */
.btn .spinner-border {
    margin-right: 0.5rem;
}

/* ========================================================================= */
/*                         STYLES POUR LE LOGIN                            */
/* ========================================================================= */
/* On inclut ces styles ici pour les rendre disponibles pour la page de connexion */
.login-container { display: flex; width: 100%; height: 100vh; }
.login-left {
    background: linear-gradient(rgba(13, 71, 161, 0.85), rgba(13, 71, 161, 0.85)), url('assets/images/login-bg.jpg');
    background-size: cover; background-position: center; color: white;
    display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; padding: 3rem;
}
.login-left h1 { font-weight: 700; }
.login-right { display: flex; justify-content: center; align-items: center; padding: 2rem; }
.login-form { width: 100%; max-width: 400px; }