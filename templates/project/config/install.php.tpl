{{PHP_TAG_OPEN}}
// install.php - Installation initiale du projet
// Généré par ChariPHP

declare(strict_types=1);

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start([
        'cookie_httponly' => true,
        'cookie_secure'   => isset($_SERVER['HTTPS']),
        'cookie_samesite' => 'Lax',
    ]);
}

$app = require __DIR__ . '/app.php';

require_once __DIR__ . '/database.php';


/*
|--------------------------------------------------------------------------
| Création de la table users
|--------------------------------------------------------------------------
*/

try {

    $sql = "
        CREATE TABLE IF NOT EXISTS users (
            id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(100) NOT NULL UNIQUE,
            email VARCHAR(190) NOT NULL UNIQUE,
            password_hash VARCHAR(255) NOT NULL,
            role VARCHAR(50) NOT NULL DEFAULT 'admin',
            is_active TINYINT(1) NOT NULL DEFAULT 1,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                ON UPDATE CURRENT_TIMESTAMP
        )
        ENGINE=InnoDB
        DEFAULT CHARSET=utf8mb4
        COLLATE=utf8mb4_unicode_ci
    ";

    $pdo->exec($sql);

} catch (Throwable $e) {

    error_log(
        'Erreur création table users : '
        . $e->getMessage()
    );

    exit(
        'Impossible de préparer le système utilisateur.'
    );
}


/*
|--------------------------------------------------------------------------
| Vérifier si un administrateur existe déjà
|--------------------------------------------------------------------------
*/

$stmt = $pdo->query(
    "SELECT COUNT(*) FROM users"
);

$userCount = (int) $stmt->fetchColumn();


/*
|--------------------------------------------------------------------------
| Token CSRF
|--------------------------------------------------------------------------
*/

if (empty($_SESSION['_csrf'])) {
    $_SESSION['_csrf'] = bin2hex(random_bytes(32));
}


$error_message = '';
$success_message = '';
$username_value = '';
$email_value = '';


/*
|--------------------------------------------------------------------------
| Création du premier administrateur
|--------------------------------------------------------------------------
*/

if (
    $_SERVER['REQUEST_METHOD'] === 'POST'
    && $userCount === 0
) {

    $csrf = (string) ($_POST['_csrf'] ?? '');

    if (
        empty($csrf)
        || !hash_equals($_SESSION['_csrf'], $csrf)
    ) {

        $error_message =
            'Session invalide. Rechargez la page.';

    } else {

        $username_value = trim(
            (string) ($_POST['username'] ?? '')
        );

        $email_value = trim(
            (string) ($_POST['email'] ?? '')
        );

        $password =
            (string) ($_POST['password'] ?? '');

        $password_confirmation =
            (string) ($_POST['password_confirmation'] ?? '');


        if (
            $username_value === ''
            || $email_value === ''
            || $password === ''
            || $password_confirmation === ''
        ) {

            $error_message =
                'Veuillez remplir tous les champs.';

        } elseif (
            !filter_var(
                $email_value,
                FILTER_VALIDATE_EMAIL
            )
        ) {

            $error_message =
                'Adresse email invalide.';

        } elseif (strlen($password) < 8) {

            $error_message =
                'Le mot de passe doit contenir au moins 8 caractères.';

        } elseif (
            $password !== $password_confirmation
        ) {

            $error_message =
                'Les mots de passe ne correspondent pas.';

        } else {

            try {

                $passwordHash = password_hash(
                    $password,
                    PASSWORD_DEFAULT
                );

                $stmt = $pdo->prepare(
                    "
                    INSERT INTO users
                    (
                        username,
                        email,
                        password_hash,
                        role,
                        is_active
                    )
                    VALUES
                    (
                        :username,
                        :email,
                        :password_hash,
                        'admin',
                        1
                    )
                    "
                );

                $stmt->execute([
                    ':username'      => $username_value,
                    ':email'         => $email_value,
                    ':password_hash' => $passwordHash,
                ]);

                $success_message =
                    'Compte administrateur créé avec succès.';

                $userCount = 1;

            } catch (Throwable $e) {

                error_log(
                    'Erreur création administrateur : '
                    . $e->getMessage()
                );

                $error_message =
                    'Impossible de créer le compte administrateur.';
            }
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

    <title>
        Installation -
        <?= htmlspecialchars(
            $app['name'] ?? 'Application',
            ENT_QUOTES,
            'UTF-8'
        ) ?>
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
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet"
    >

    <link
        rel="stylesheet"
        href="../assets/css/style.css"
    >

    <link
        rel="stylesheet"
        href="../assets/css/login.css"
    >

</head>

<body>

<div class="container-fluid p-0 login-container">

    <!-- Même design que le login -->

    <div class="col-lg-7 d-none d-lg-flex login-left">

        <div>

            <h1>
                Installation
            </h1>

            <p class="lead mt-3">

                Configuration initiale du projet

                <?= htmlspecialchars(
                    $app['name'] ?? 'Application',
                    ENT_QUOTES,
                    'UTF-8'
                ) ?>.

            </p>

        </div>

    </div>


    <div class="col-lg-5 col-12 login-right">

        <div class="login-form">

            <h2 class="mb-2">
                Premier administrateur
            </h2>

            <p class="text-muted mb-4">
                Créez le premier compte du Back-Office.
            </p>


            <?php if ($success_message !== ''): ?>

                <div class="alert alert-success">

                    <?= htmlspecialchars(
                        $success_message,
                        ENT_QUOTES,
                        'UTF-8'
                    ) ?>

                </div>

                <a
                    href="../login.php"
                    class="btn btn-primary btn-lg w-100"
                >
                    Aller à la connexion
                </a>


            <?php elseif ($userCount > 0): ?>

                <div class="alert alert-info">
                    L'installation initiale a déjà été effectuée.
                </div>

                <a
                    href="../login.php"
                    class="btn btn-primary btn-lg w-100"
                >
                    Aller à la connexion
                </a>


            <?php else: ?>


                <?php if ($error_message !== ''): ?>

                    <div class="alert alert-danger">

                        <?= htmlspecialchars(
                            $error_message,
                            ENT_QUOTES,
                            'UTF-8'
                        ) ?>

                    </div>

                <?php endif; ?>


                <form method="POST">

                    <input
                        type="hidden"
                        name="_csrf"
                        value="<?= htmlspecialchars(
                            $_SESSION['_csrf'],
                            ENT_QUOTES,
                            'UTF-8'
                        ) ?>"
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
                            id="username"
                            name="username"
                            class="form-control"
                            value="<?= htmlspecialchars(
                                $username_value,
                                ENT_QUOTES,
                                'UTF-8'
                            ) ?>"
                            required
                        >

                    </div>


                    <div class="mb-3">

                        <label
                            for="email"
                            class="form-label"
                        >
                            Adresse email
                        </label>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            class="form-control"
                            value="<?= htmlspecialchars(
                                $email_value,
                                ENT_QUOTES,
                                'UTF-8'
                            ) ?>"
                            required
                        >

                    </div>


                    <div class="mb-3">

                        <label
                            for="password"
                            class="form-label"
                        >
                            Mot de passe
                        </label>

                        <input
                            type="password"
                            id="password"
                            name="password"
                            class="form-control"
                            minlength="8"
                            required
                        >

                    </div>


                    <div class="mb-4">

                        <label
                            for="password_confirmation"
                            class="form-label"
                        >
                            Confirmer le mot de passe
                        </label>

                        <input
                            type="password"
                            id="password_confirmation"
                            name="password_confirmation"
                            class="form-control"
                            minlength="8"
                            required
                        >

                    </div>


                    <div class="d-grid">

                        <button
                            type="submit"
                            class="btn btn-primary btn-lg"
                        >
                            Créer l'administrateur
                        </button>

                    </div>

                </form>

            <?php endif; ?>

        </div>

    </div>

</div>

</body>

</html>