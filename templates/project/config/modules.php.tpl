{{PHP_TAG_OPEN}}

declare(strict_types=1);

/*
|--------------------------------------------------------------------------
| Modules du Back-Office
|--------------------------------------------------------------------------
|
| Ce fichier définit les onglets de l'administration.
| Pour ajouter ou retirer un onglet, il suffit de modifier ce tableau.
|
*/

return [

    'dashboard' => [
        'label' => 'Tableau de bord',
        'icon'  => 'fa-solid fa-chart-line',
        'roles' => ['admin'],
    ],

    // CHARI_MODULES_HERE
];