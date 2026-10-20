{{PHP_TAG_OPEN}}
// login.php - Portail d'authentification du backend
// Généré par ChariPHP

declare(strict_types=1);

// Démarrer la session en mode sécurisé
if (session_status() === PHP_SESSION_NONE) {
    session_start([
        'cookie_httponly' => true,
        'cookie_secure' => isset($_SERVER['HTTPS']),
        'cookie_samesite' => 'Lax',
    ]);
}

// Connexion à la base de données
require_once __DIR__ . '/config/database.php';

// Si l'utilisateur est déjà connecté, le rediriger vers le Back-Office.
if (isset($_SESSION['user_id'])) {
    header('Location: admin/');
    exit;
}

// Créer le token CSRF s'il n'existe pas.
if (empty($_SESSION['_csrf'])) {
    $_SESSION['_csrf'] = bin2hex(random_bytes(32));
}

$error_message = '';
$username_value = '';

// Message si la session a expiré.
if (isset($_GET['expired'])) {
    $error_message = 'Votre session a expiré. Veuillez vous reconnecter.';
}

// Traitement du formulaire
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';
    $csrf = $_POST['_csrf'] ?? '';

    $username_value = $username;

    // Vérification CSRF
    if (
        empty($_SESSION['_csrf'])
        || !is_string($csrf)
        || !hash_equals($_SESSION['_csrf'], $csrf)
    ) {
        $error_message = 'Session invalide. Rechargez la page.';

    } elseif (empty($username) || empty($password)) {

        $error_message = 'Veuillez saisir tous les champs.';

    } else {

        try {

            $stmt = $pdo->prepare("
                SELECT
                    id,
                    username,
                    email,
                    password_hash,
                    role,
                    is_active
                FROM users
                WHERE username = ?
                LIMIT 1
            ");

            $stmt->execute([$username]);

            $user = $stmt->fetch();

            if (!$user || !password_verify($password, $user['password_hash'])) {

                $error_message = 'Identifiants incorrects.';

            } elseif ((int) $user['is_active'] !== 1) {

                $error_message = 'Ce compte est désactivé.';

            } else {

                // Sécurité : renouveler l'identifiant de session
                session_regenerate_id(true);

                $_SESSION['user_id'] = $user['id'];
                $_SESSION['username'] = $user['username'];
                $_SESSION['email'] = $user['email'];
                $_SESSION['role'] = $user['role'];
                $_SESSION['last_activity'] = time();

                // Renouveler également le token CSRF
                $_SESSION['_csrf'] = bin2hex(random_bytes(32));

                header('Location: admin/');
                exit;
            }

        } catch (PDOException $e) {

            error_log('Login Error: ' . $e->getMessage());

            $error_message = 'Une erreur technique est survenue.';
        }
    }
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

    <title>Connexion - Administration {{PROJECT_NAME}}</title>

    <!-- CSS -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet"
    >

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
    >

    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet"
    >

    <link rel="stylesheet" href="assets/css/style.css">

    <link rel="stylesheet" href="assets/css/login.css">

</head>

<body>

    <div class="container-fluid p-0 login-container">

        <!-- Volet Gauche -->
        <div class="col-lg-7 d-none d-lg-flex login-left">

            <div>

                <!--
                <img
                    src="assets/images/logo-white.png"
                    alt="Logo"
                    class="logo"
                >
                -->

                <h1>Administration</h1>

                <p class="lead mt-3">
                    Panel de gestion du projet {{PROJECT_NAME}}.
                </p>

            </div>

        </div>


        <!-- Volet Droit -->
        <div class="col-lg-5 col-12 login-right">

            <div class="login-form">

                <h2 class="mb-2">
                    Accès Sécurisé
                </h2>

                <p class="text-muted mb-4">
                    Veuillez vous authentifier.
                </p>


                <?php if (!empty($error_message)): ?>

                    <div class="alert alert-danger">

                        <?= htmlspecialchars(
                            $error_message,
                            ENT_QUOTES,
                            'UTF-8'
                        ); ?>

                    </div>

                <?php endif; ?>


                <form
                    method="POST"
                    action="login.php"
                    id="loginForm"
                >

                    <!-- Protection CSRF -->
                    <input
                        type="hidden"
                        name="_csrf"
                        value="<?= htmlspecialchars(
                            $_SESSION['_csrf'],
                            ENT_QUOTES,
                            'UTF-8'
                        ); ?>"
                    >


                    <div class="mb-3">

                        <label
                            for="username"
                            class="form-label"
                        >
                            Nom d'utilisateur
                        </label>

                        <input
                            type="text"
                            class="form-control"
                            id="username"
                            name="username"
                            value="<?= htmlspecialchars(
                                $username_value,
                                ENT_QUOTES,
                                'UTF-8'
                            ); ?>"
                            required
                            autofocus
                        >

                    </div>


                    <div class="mb-4">

                        <label
                            for="password"
                            class="form-label"
                        >
                            Mot de passe
                        </label>

                        <input
                            type="password"
                            class="form-control"
                            id="password"
                            name="password"
                            required
                        >

                    </div>


                    <div class="d-grid">

                        <button
                            type="submit"
                            class="btn btn-primary btn-lg"
                            id="submitBtn"
                        >

                            <span
                                class="spinner-border spinner-border-sm d-none"
                                role="status"
                                aria-hidden="true"
                            ></span>

                            <span class="btn-text">
                                Se Connecter
                            </span>

                        </button>

                    </div>

                </form>

            </div>

        </div>

    </div>


    <script>

        document
            .getElementById('loginForm')
            .addEventListener('submit', function () {

                const btn =
                    document.getElementById('submitBtn');

                btn.disabled = true;

                btn
                    .querySelector('.spinner-border')
                    .classList.remove('d-none');

                btn
                    .querySelector('.btn-text')
                    .textContent = 'Connexion...';
            });

    </script>

</body>
</html>