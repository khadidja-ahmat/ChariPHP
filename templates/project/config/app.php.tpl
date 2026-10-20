{{PHP_TAG_OPEN}}

declare(strict_types=1);

/*
|--------------------------------------------------------------------------
| Configuration générale du projet
|--------------------------------------------------------------------------
|
| Ce fichier contient les informations générales de l'application.
| Il peut être modifié pour adapter ChariPHP à n'importe quel projet.
|
*/

return [

    /*
    |--------------------------------------------------------------------------
    | Identité du projet
    |--------------------------------------------------------------------------
    */

    'name' => '{{PROJECT_NAME}}',

    'description' => '',

    'public_title' => '{{PROJECT_NAME}}',

    'admin_title' => 'Administration - {{PROJECT_NAME}}',


    /*
    |--------------------------------------------------------------------------
    | Navigation par défaut
    |--------------------------------------------------------------------------
    */

    'default_public_page' => 'accueil',

    'default_admin_module' => 'dashboard',


    /*
    |--------------------------------------------------------------------------
    | Sessions
    |--------------------------------------------------------------------------
    |
    | Durée d'inactivité maximale avant déconnexion.
    | Valeur exprimée en secondes.
    | 1800 secondes = 30 minutes.
    |
    */

    'session_lifetime' => 1800,

];