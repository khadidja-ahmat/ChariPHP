{{PHP_TAG_OPEN}}
// /admin/modules/dashboard/index.php
// Tableau de bord générique du Back-Office
// Généré par ChariPHP

require_once __DIR__ . '/../../../config/auth.php';

$modules = require __DIR__ . '/../../../config/modules.php';

?>

<div class="container-fluid">

    <!-- Titre -->
    <div class="mb-4">
        <h4 class="mb-1">Tableau de Bord</h4>

        <p class="text-muted mb-0">
            Bienvenue dans l'administration de {{PROJECT_NAME}}.
        </p>
    </div>


    <div class="row">

        <!-- Projet -->
        <div class="col-xl-4 col-md-6 mb-4">

            <div class="card shadow h-100">

                <div class="card-body">

                    <div class="d-flex align-items-center">

                        <div class="me-3">
                            <i class="fas fa-folder-open fa-2x text-primary"></i>
                        </div>

                        <div>
                            <div class="text-muted small">
                                Projet
                            </div>

                            <div class="fw-bold">
                                {{PROJECT_NAME}}
                            </div>
                        </div>

                    </div>

                </div>

            </div>

        </div>


        <!-- Modules -->
        <div class="col-xl-4 col-md-6 mb-4">

            <div class="card shadow h-100">

                <div class="card-body">

                    <div class="d-flex align-items-center">

                        <div class="me-3">
                            <i class="fas fa-cubes fa-2x text-primary"></i>
                        </div>

                        <div>
                            <div class="text-muted small">
                                Modules disponibles
                            </div>

                            <div class="fw-bold">
                                <?= count($modules) ?>
                            </div>
                        </div>

                    </div>

                </div>

            </div>

        </div>


        <!-- Utilisateur -->
        <div class="col-xl-4 col-md-6 mb-4">

            <div class="card shadow h-100">

                <div class="card-body">

                    <div class="d-flex align-items-center">

                        <div class="me-3">
                            <i class="fas fa-user-circle fa-2x text-primary"></i>
                        </div>

                        <div>
                            <div class="text-muted small">
                                Utilisateur connecté
                            </div>

                            <div class="fw-bold">
                                <?= htmlspecialchars(
                                    $_SESSION['username'] ?? 'Admin',
                                    ENT_QUOTES,
                                    'UTF-8'
                                ) ?>
                            </div>
                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>


    <!-- Carte principale -->
    <div class="card shadow mb-4">

        <div class="card-header py-3">

            <h6 class="m-0 font-weight-bold text-primary">
                Administration
            </h6>

        </div>

        <div class="card-body">

            <p class="mb-0">
                Utilisez le menu à gauche pour accéder aux différents modules du projet.
            </p>

        </div>

    </div>

</div>