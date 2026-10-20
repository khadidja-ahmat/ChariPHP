{{PHP_TAG_OPEN}}

declare(strict_types=1);

/*
|--------------------------------------------------------------------------
| Connexion à la base de données
|--------------------------------------------------------------------------
|
| Ce fichier centralise la connexion PDO de l'application.
| Toutes les requêtes SQL du projet utiliseront cette connexion.
|
*/

define('DB_HOST', '{{DB_HOST}}');
define('DB_NAME', '{{DB_NAME}}');
define('DB_USER', '{{DB_USER}}');
define('DB_PASS', '{{DB_PASS}}');
define('DB_CHARSET', 'utf8mb4');


/*
|--------------------------------------------------------------------------
| DSN
|--------------------------------------------------------------------------
*/

$dsn = sprintf(
    'mysql:host=%s;dbname=%s;charset=%s',
    DB_HOST,
    DB_NAME,
    DB_CHARSET
);


/*
|--------------------------------------------------------------------------
| Options PDO
|--------------------------------------------------------------------------
*/

$options = [

    PDO::ATTR_ERRMODE =>
        PDO::ERRMODE_EXCEPTION,

    PDO::ATTR_DEFAULT_FETCH_MODE =>
        PDO::FETCH_ASSOC,

    PDO::ATTR_EMULATE_PREPARES =>
        false,
];


/*
|--------------------------------------------------------------------------
| Connexion PDO
|--------------------------------------------------------------------------
*/

try {

    $pdo = new PDO(
        $dsn,
        DB_USER,
        DB_PASS,
        $options
    );

} catch (PDOException $e) {

    error_log(
        'Erreur connexion BDD : '
        . $e->getMessage()
    );

    http_response_code(500);

    exit(
        'Impossible de se connecter à la base de données.'
    );
}