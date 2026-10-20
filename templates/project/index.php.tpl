{{PHP_TAG_OPEN}}

declare(strict_types=1);

// Charger les routes publiques
$app = require __DIR__ . '/config/app.php';
$routes = require __DIR__ . '/config/routes.php';

// Page demandée.
// Si aucune page n'est indiquée, on affiche l'accueil.
$page = $_GET['page'] ?? $app['default_public_page'];

// Vérifier que la route existe
if (!isset($routes[$page])) {
    http_response_code(404);
    $page = $app['default_public_page'];
}

$route = $routes[$page];

// Fichier de la page à afficher
$page_file = __DIR__ . '/pages/' . $route['file'];

// Vérification de sécurité
if (!file_exists($page_file)) {
    http_response_code(404);
    die('Page introuvable.');
}

?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>
        <?= htmlspecialchars($route['label']) ?>
        - {{PROJECT_NAME}}
    </title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet"
    >

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
    >

    <link
        rel="stylesheet"
        href="assets/css/style.css"
    >
</head>

<body>

    <!-- Navigation publique -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">

        <div class="container">

            <a
                class="navbar-brand"
                href="index.php"
            >
                {{PROJECT_NAME}}
            </a>


            <button
                class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#publicNavbar"
            >
                <span class="navbar-toggler-icon"></span>
            </button>


            <div
                class="collapse navbar-collapse"
                id="publicNavbar"
            >

                <ul class="navbar-nav me-auto">

                    <?php foreach ($routes as $route_name => $route_data): ?>

                        <li class="nav-item">

                            <a
                                class="nav-link <?= $page === $route_name ? 'active' : '' ?>"
                                href="index.php?page=<?= urlencode($route_name) ?>"
                            >
                                <?= htmlspecialchars($route_data['label']) ?>
                            </a>

                        </li>

                    <?php endforeach; ?>

                </ul>


                <!-- Accès administration -->
                <a
                    href="login.php"
                    class="btn btn-outline-light btn-sm"
                >
                    <i class="fas fa-lock me-1"></i>
                    Administration
                </a>

            </div>

        </div>

    </nav>


    <!-- Contenu de la page demandée -->
    <main>

        <?php require $page_file; ?>

    </main>


    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
    </script>

</body>
</html>