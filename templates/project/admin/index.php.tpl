{{PHP_TAG_OPEN}}
// /admin/index.php - Point d'entrée principal du Back-Office
// Généré par ChariPHP

declare(strict_types=1);

// Vérifier que l'utilisateur est authentifié.
require_once __DIR__ . '/../config/auth.php';

// Configuration générale du projet.
$app = require __DIR__ . '/../config/app.php';

// Configuration des modules.
$modules = require __DIR__ . '/../config/modules.php';

// Module affiché par défaut.
$defaultModule = $app['default_admin_module'] ?? 'dashboard';

// Titre du module par défaut.
$defaultModuleTitle =
    $modules[$defaultModule]['label']
    ?? 'Tableau de Bord';

// S'assurer qu'un token CSRF existe.
if (empty($_SESSION['_csrf'])) {
    $_SESSION['_csrf'] = bin2hex(random_bytes(32));
}

// Le header contient le DOCTYPE, <head>, et l'ouverture du <body>.
require_once __DIR__ . '/../includes/header.php';

// La sidebar est le menu de navigation principal.
require_once __DIR__ . '/../includes/sidebar.php';

?>

<!-- Conteneur principal de la page -->
<div
    id="page-content-wrapper"
    data-default-module="<?= htmlspecialchars(
        $defaultModule,
        ENT_QUOTES,
        'UTF-8'
    ) ?>"
>

    <!-- Barre de Navigation Supérieure -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white mb-4 shadow-sm">

        <div class="container-fluid">

            <!-- Le titre du module sera mis à jour par JavaScript -->
            <span
                class="navbar-brand mb-0 h1"
                id="module-title"
            >
                <?= htmlspecialchars(
                    $defaultModuleTitle,
                    ENT_QUOTES,
                    'UTF-8'
                ) ?>
            </span>


            <!-- Menu Utilisateur -->
            <ul class="navbar-nav ms-auto">

                <li class="nav-item dropdown">

                    <a
                        class="nav-link dropdown-toggle"
                        href="#"
                        id="userDropdown"
                        role="button"
                        data-bs-toggle="dropdown"
                        aria-expanded="false"
                    >

                        <i class="fas fa-user-circle fa-lg me-2"></i>

                        <?= htmlspecialchars(
                            $_SESSION['username'] ?? 'Admin',
                            ENT_QUOTES,
                            'UTF-8'
                        ) ?>

                    </a>


                    <ul
                        class="dropdown-menu dropdown-menu-end"
                        aria-labelledby="userDropdown"
                    >

                        <li>
                            <a
                                class="dropdown-item"
                                href="#"
                            >
                                Mon Profil
                            </a>
                        </li>


                        <li>
                            <hr class="dropdown-divider">
                        </li>


                        <li>

                            <!-- Déconnexion sécurisée -->
                            <form
                                method="POST"
                                action="../logout.php"
                                class="m-0"
                            >

                                <input
                                    type="hidden"
                                    name="_csrf"
                                    value="<?= htmlspecialchars(
                                        $_SESSION['_csrf'],
                                        ENT_QUOTES,
                                        'UTF-8'
                                    ) ?>"
                                >

                                <button
                                    type="submit"
                                    class="dropdown-item text-danger"
                                >

                                    <i class="fas fa-sign-out-alt fa-fw me-2"></i>

                                    Déconnexion

                                </button>

                            </form>

                        </li>

                    </ul>

                </li>

            </ul>

        </div>

    </nav>


    <!-- Zone de Contenu Dynamique -->
    <main class="container-fluid position-relative">

        <!-- Spinner de chargement pour les modules AJAX -->
        <div
            id="content-loader"
            class="spinner-border text-primary"
            style="
                width: 3rem;
                height: 3rem;
                display: none;
                position: absolute;
                top: calc(50% + 50px);
                left: calc(50% + 130px);
                transform: translate(-50%, -50%);
                z-index: 1060;
            "
            role="status"
        >

            <span class="visually-hidden">
                Chargement...
            </span>

        </div>


        <!-- Le contenu des modules sera injecté ici par main.js -->
        <div id="main-content">

            <!-- Le module défini dans config/app.php sera chargé au démarrage -->

        </div>

    </main>

</div>
<!-- /#page-content-wrapper -->


</div>
<!-- /#wrapper (ouvert dans header.php) -->


<?php
// Le footer contient les librairies JavaScript
// et ferme les balises </body> et </html>.
require_once __DIR__ . '/../includes/footer.php';