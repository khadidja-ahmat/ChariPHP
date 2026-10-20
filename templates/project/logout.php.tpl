{{PHP_TAG_OPEN}}
// /logout.php - Script de déconnexion sécurisée
// Généré par ChariPHP

declare(strict_types=1);

// 1. Démarrer la session pour pouvoir la manipuler.
if (session_status() === PHP_SESSION_NONE) {
    session_start([
        'cookie_httponly' => true,
        'cookie_secure' => isset($_SERVER['HTTPS']),
        'cookie_samesite' => 'Lax',
    ]);
}

// 2. La déconnexion doit venir du bouton de déconnexion.
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: login.php');
    exit;
}

// 3. Vérifier le token CSRF.
$csrf = $_POST['_csrf'] ?? '';

if (
    empty($_SESSION['_csrf'])
    || !is_string($csrf)
    || !hash_equals($_SESSION['_csrf'], $csrf)
) {
    http_response_code(403);
    exit('Requête de déconnexion invalide.');
}

// 4. Vider le tableau de session.
$_SESSION = [];

// 5. Détruire le cookie de session côté client.
if (ini_get('session.use_cookies')) {
    $params = session_get_cookie_params();

    setcookie(
        session_name(),
        '',
        time() - 42000,
        $params['path'],
        $params['domain'],
        $params['secure'],
        $params['httponly']
    );
}

// 6. Détruire la session côté serveur.
session_destroy();

// 7. Rediriger vers la page de connexion.
header('Location: login.php');

// 8. Arrêter l'exécution.
exit;