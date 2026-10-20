{{PHP_TAG_OPEN}}

declare(strict_types=1);

/*
|--------------------------------------------------------------------------
| Protection de l'administration
|--------------------------------------------------------------------------
|
| Ce fichier vérifie que l'utilisateur est authentifié avant
| d'accéder au Back-Office.
|
| Il vérifie également l'expiration de la session.
|
*/


/*
|--------------------------------------------------------------------------
| Démarrage sécurisé de la session
|--------------------------------------------------------------------------
*/

if (session_status() !== PHP_SESSION_ACTIVE) {

    session_start([
        'cookie_httponly' => true,
        'cookie_secure'   => isset($_SERVER['HTTPS']),
        'cookie_samesite' => 'Lax',
    ]);
}


/*
|--------------------------------------------------------------------------
| Configuration générale
|--------------------------------------------------------------------------
*/

$app = require __DIR__ . '/app.php';

// Chemin racine du projet dans l'URL
$scriptName = str_replace('\\', '/', $_SERVER['SCRIPT_NAME'] ?? '');

$adminPosition = strpos($scriptName, '/admin/');

$baseUrl = $adminPosition !== false
    ? substr($scriptName, 0, $adminPosition)
    : '';

$loginUrl = $baseUrl . '/login.php';


/*
|--------------------------------------------------------------------------
| Utilisateur connecté ?
|--------------------------------------------------------------------------
*/

if (empty($_SESSION['user_id'])) {

    header('Location: ' . $loginUrl);

    exit;
}


/*
|--------------------------------------------------------------------------
| Durée maximale d'inactivité
|--------------------------------------------------------------------------
*/

$sessionLifetime = (int) (
    $app['session_lifetime']
    ?? 1800
);


/*
|--------------------------------------------------------------------------
| Vérification expiration session
|--------------------------------------------------------------------------
*/

if (
    isset($_SESSION['last_activity'])
    &&
    (time() - (int) $_SESSION['last_activity'])
        > $sessionLifetime
) {

    /*
     * Session expirée.
     */

    $_SESSION = [];

    session_destroy();

    header(
        'Location: ' . $loginUrl . '?expired=1'
    );

    exit;
}


/*
|--------------------------------------------------------------------------
| Mise à jour activité
|--------------------------------------------------------------------------
*/

$_SESSION['last_activity'] = time();


/*
|--------------------------------------------------------------------------
| Informations utilisateur
|--------------------------------------------------------------------------
*/

$currentUser = [

    'id' => (int) (
        $_SESSION['user_id']
        ?? 0
    ),

    'username' => (
        $_SESSION['username']
        ?? ''
    ),

    'email' => (
        $_SESSION['email']
        ?? ''
    ),

    'role' => (
        $_SESSION['role']
        ?? ''
    ),

];