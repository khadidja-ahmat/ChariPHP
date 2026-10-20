<?php
// ChariPHP - forge.php : génère un projet ou un module

// === GESTIONNAIRE D'ERREURS PERSONNALISÉ ===
// Pour une meilleure expérience, on intercepte les erreurs PHP 
// et on les transforme en messages clairs pour l'utilisateur.
set_error_handler(function ($severity, $message, $file, $line) {
    throw new ErrorException($message, 0, $severity, $file, $line);
});

// === ROUTEUR D'ACTIONS ===
// Aiguille la requête vers la bonne fonction en fonction de l'action demandée.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    $action = $_POST['action'];
    try {
        switch ($action) {
            case 'create_project':
                handle_create_project($_POST);
                break;
            case 'create_module':
                handle_create_module($_POST);
                break;
            default:
                throw new Exception("Action non reconnue.");
        }
    } catch (Exception $e) {
        // En cas d'erreur, on redirige vers l'index avec un message d'échec.
        redirect_with_message('error', $e->getMessage());
    }
} else {
    // Si le script est appelé sans action, on redirige simplement.
    header('Location: index.php');
    exit;
}





// =========================================================================
// FONCTION 1 : CRÉATION D'UN PROJET COMPLET
// =========================================================================
function handle_create_project($post_data) {
    // 1. Validation des entrées
    $project_name = preg_replace('/[^a-zA-Z0-9_-]/', '', $post_data['project_name']);
    if (empty($project_name)) {
        throw new Exception("Le nom du projet est invalide.");
    }
    
    $project_path = realpath(__DIR__ . '/..') . '/' . $project_name;
    if (file_exists($project_path)) {
        throw new Exception("Un dossier avec le nom '{$project_name}' existe déjà.");
    }
    // 2. Création de l'arborescence des dossiers
    $directories = [
        $project_path,
        $project_path . '/admin',
        $project_path . '/admin/modules',
        $project_path . '/admin/modules/dashboard',
        $project_path . '/pages',
        $project_path . '/assets',
        $project_path . '/assets/css',
        $project_path . '/assets/js',
        $project_path . '/assets/js/modules',
        $project_path . '/assets/images',
        $project_path . '/uploads',
        $project_path . '/includes',
        $project_path . '/config',
    ];

    foreach ($directories as $dir) {
        if (!mkdir($dir, 0755, true)) {
            throw new Exception("Impossible de créer le dossier : {$dir}");
        }
    }

    // 3. Définition des placeholders et de leurs valeurs
    $placeholders = [
        '{{PROJECT_NAME}}' => $project_name,
        '{{DB_HOST}}' => $post_data['db_host'],
        '{{DB_NAME}}' => $post_data['db_name'],
        '{{DB_USER}}' => $post_data['db_user'],
        '{{DB_PASS}}' => $post_data['db_pass'],
        '{{PHP_TAG_OPEN}}' => '<?php',
        '{{PRIMARY_COLOR}}' => '#0D47A1',
        '{{SECONDARY_COLOR}}' => '#FF8F00',
    ];

    // 4. Création des fichiers à partir des templates
    $files_to_create = [
        // Racine
        'templates/project/index.php.tpl' => $project_path . '/index.php',
        'templates/project/pages/accueil.php.tpl'=> $project_path . '/pages/accueil.php',
        'templates/project/login.php.tpl' => $project_path . '/login.php',
        'templates/project/logout.php.tpl' => $project_path . '/logout.php',
        // Administration
        'templates/project/admin/index.php.tpl' => $project_path . '/admin/index.php',
        'templates/project/admin/modules/dashboard/index.php.tpl' => $project_path . '/admin/modules/dashboard/index.php',
        // Configuration
        'templates/project/config/app.php.tpl' => $project_path . '/config/app.php',
        // Includes
        'templates/project/config/database.php.tpl' => $project_path . '/config/database.php',
        'templates/project/config/routes.php.tpl' => $project_path . '/config/routes.php',
        'templates/project/config/modules.php.tpl' => $project_path . '/config/modules.php',
        'templates/project/config/auth.php.tpl' => $project_path . '/config/auth.php',
        'templates/project/config/install.php.tpl' => $project_path . '/config/install.php',
        'templates/project/includes/header.php.tpl' => $project_path . '/includes/header.php',
        'templates/project/includes/sidebar.php.tpl' => $project_path . '/includes/sidebar.php',
        'templates/project/includes/footer.php.tpl' => $project_path . '/includes/footer.php',
        // Assets
        'templates/project/assets/js/main.js.tpl' => $project_path . '/assets/js/main.js',
        'templates/project/assets/css/style.css.tpl' => $project_path . '/assets/css/style.css',
    ];

    foreach ($files_to_create as $template_path => $destination_path) {
        create_file_from_template($template_path, $destination_path, $placeholders );
    }

    // 5. Redirection avec un message de succès
    redirect_with_message('success', "Le projet '{$project_name}' a été forgé avec succès !");
}


// =========================================================================
// FONCTION 2 : CRÉATION D'UN MODULE DANS UN PROJET EXISTANT
// =========================================================================
function handle_create_module($post_data) {

    // 1. Récupérer les informations du formulaire
    $project_name = preg_replace(
        '/[^a-zA-Z0-9_-]/',
        '',
        $post_data['project_name'] ?? ''
    );

    $module_name = strtolower(
        preg_replace(
            '/[^a-zA-Z0-9_]/',
            '',
            $post_data['module_name'] ?? ''
        )
    );

    $table_name = strtolower(
        preg_replace(
            '/[^a-zA-Z0-9_]/',
            '',
            $post_data['table_name'] ?? ''
        )
    );


    if (empty($project_name)) {
        throw new Exception("Le nom du projet est invalide.");
    }

    if (empty($module_name)) {
        throw new Exception("Le nom du module est invalide.");
    }


    // 2. Vérifier le projet
    $root_path = realpath(__DIR__ . '/..');

    if ($root_path === false) {
        throw new Exception("Impossible de trouver le dossier principal.");
    }

    $project_path = $root_path . '/' . $project_name;

    if (!is_dir($project_path)) {
        throw new Exception(
            "Le projet '{$project_name}' est introuvable."
        );
    }


    // 3. Vérifier que le module n'existe pas déjà
    $module_path =
        $project_path . '/admin/modules/' . $module_name;

    if (is_dir($module_path)) {
        throw new Exception(
            "Le module '{$module_name}' existe déjà."
        );
    }


    // 4. Vérifier config/modules.php
    $modules_file =
        $project_path . '/config/modules.php';

    if (!file_exists($modules_file)) {
        throw new Exception(
            "Le fichier config/modules.php est introuvable."
        );
    }

    $modules_content =
        file_get_contents($modules_file);

    if ($modules_content === false) {
        throw new Exception(
            "Impossible de lire config/modules.php."
        );
    }

    $marker = '    // CHARI_MODULES_HERE';

    if (strpos($modules_content, $marker) === false) {
        throw new Exception(
            "Le marqueur CHARI_MODULES_HERE est introuvable."
        );
    }


    // 5. Valeurs par défaut
    $datatable_columns = "
        <th>ID</th>
        <th>Actions</th>
    ";

    $datatable_js_columns =
    "{ data: 'id' },\n";

    $form_fields = "
        <div class=\"alert alert-info\">
            Aucune table MySQL associée à ce module.
        </div>
    ";


    // 6. Si une table MySQL est indiquée
    if ($table_name !== '') {

        $database_file =
            $project_path . '/config/database.php';

        if (!file_exists($database_file)) {
            throw new Exception(
                "Le fichier config/database.php est introuvable."
            );
        }


        // Charger la connexion PDO du projet
        $pdo = null;

        require $database_file;

        if (!($pdo instanceof PDO)) {
            throw new Exception(
                "Impossible de se connecter à la base de données."
            );
        }


        // Lire les colonnes de la table
        try {

            $stmt = $pdo->query(
                "DESCRIBE `{$table_name}`"
            );

            $columns =
                $stmt->fetchAll(PDO::FETCH_ASSOC);

        } catch (PDOException $e) {

            throw new Exception(
                "La table '{$table_name}' est introuvable."
            );
        }


        if (empty($columns)) {
            throw new Exception(
                "La table '{$table_name}' ne contient aucune colonne."
            );
        }


        $datatable_columns = '';
        $datatable_js_columns = '';
        $form_fields = '';


        // 7. Générer le tableau et le formulaire
        foreach ($columns as $column) {

            $name = $column['Field'];
            $datatable_js_columns .=
                "{ data: " . json_encode($name) . " },\n";

            $type = strtolower(
                $column['Type']
            );

            $label = ucwords(
                str_replace('_', ' ', $name)
            );


            // Colonne du tableau
            $datatable_columns .=
                "<th>{$label}</th>\n";


            // Ne pas mettre l'ID dans le formulaire
            if (
                $column['Key'] === 'PRI'
                || str_contains(
                    strtolower($column['Extra']),
                    'auto_increment'
                )
                || in_array(
                    $name,
                    ['created_at', 'updated_at'],
                    true
                )
            ) {
                continue;
            }


            // Champ obligatoire
            $required = '';

            if (
                $column['Null'] === 'NO'
                && $column['Default'] === null
            ) {
                $required = 'required';
            }


            // TEXT = textarea
            if (str_contains($type, 'text')) {

                $form_fields .= "
                    <div class=\"mb-3\">
                        <label
                            for=\"{$name}\"
                            class=\"form-label\"
                        >
                            {$label}
                        </label>

                        <textarea
                            id=\"{$name}\"
                            name=\"{$name}\"
                            class=\"form-control\"
                            {$required}
                        ></textarea>
                    </div>
                ";

                continue;
            }


            // Type du champ HTML
            $input_type = 'text';
            $step = '';

            if (str_contains($type, 'int')) {

                $input_type = 'number';

            } elseif (
                str_contains($type, 'decimal')
                || str_contains($type, 'float')
                || str_contains($type, 'double')
            ) {

                $input_type = 'number';
                $step = 'step="0.01"';

            } elseif (
                str_contains($type, 'datetime')
                || str_contains($type, 'timestamp')
            ) {

                $input_type = 'datetime-local';

            } elseif (
                str_starts_with($type, 'date')
            ) {

                $input_type = 'date';
            }


            $form_fields .= "
                <div class=\"mb-3\">
                    <label
                        for=\"{$name}\"
                        class=\"form-label\"
                    >
                        {$label}
                    </label>

                    <input
                        type=\"{$input_type}\"
                        id=\"{$name}\"
                        name=\"{$name}\"
                        class=\"form-control\"
                        {$step}
                        {$required}
                    >
                </div>
            ";
        }


        // Ajouter Actions à la fin du tableau
        $datatable_columns .=
            "<th>Actions</th>";
    }


    // 8. Créer le dossier du module
    if (!mkdir($module_path, 0755, true)) {
        throw new Exception(
            "Impossible de créer le dossier du module."
        );
    }


    // 9. Valeurs envoyées aux templates
    $placeholders = [

        '{{PHP_TAG_OPEN}}'
            => '<?php',

        '{{TABLE_NAME}}'
            => $table_name,

        '{{DATATABLE_COLUMNS}}'
            => $datatable_columns,

        '{{DATATABLE_JS_COLUMNS}}'
            => $datatable_js_columns,

        '{{FORM_FIELDS}}'
            => $form_fields
    ];

    $extra_vars = [
        'module_name' => $module_name
    ];


    // 10. Créer les fichiers du module
    create_file_from_template(
        'templates/module/index.php.tpl',
        $module_path . '/index.php',
        $placeholders,
        $extra_vars
    );

    create_file_from_template(
        'templates/module/ajax_handler.php.tpl',
        $module_path . '/ajax_handler.php',
        $placeholders,
        $extra_vars
    );

    create_file_from_template(
        'templates/module/script.js.tpl',
        $project_path
            . '/assets/js/modules/'
            . $module_name
            . '.js',
        $placeholders,
        $extra_vars
    );


    // 11. Ajouter le module dans config/modules.php
    $module_label =
        ucwords(
            str_replace('_', ' ', $module_name)
        );

    $new_module = "

    '{$module_name}' => [
        'label' => '{$module_label}',
        'icon' => 'fas fa-cube',
        'roles' => ['admin'],
    ],
";

    $modules_content = str_replace(
        $marker,
        $new_module . "\n" . $marker,
        $modules_content
    );

    if (
        file_put_contents(
            $modules_file,
            $modules_content
        ) === false
    ) {
        throw new Exception(
            "Impossible de mettre à jour config/modules.php."
        );
    }


    // 12. Terminé
    redirect_with_message(
        'success',
        "Le module '{$module_name}' a été créé avec succès."
    );
}


// =========================================================================
// FONCTIONS UTILITAIRES
// =========================================================================

/**
 * Crée un fichier à partir d'un template en remplaçant les placeholders.
 * @param string $template_path Chemin vers le fichier template.
 * @param string $destination_path Chemin où créer le nouveau fichier.
 * @param array $placeholders Tableau des placeholders globaux à remplacer.
 * @param array $extra_vars Tableau de variables spécifiques (ex: nom du module).
 */
function create_file_from_template($template_path, $destination_path, $placeholders, $extra_vars = []) {
    if (!file_exists($template_path)) {
        throw new Exception("Template manquant : {$template_path}");
    }
    
    // Lire le contenu du template
    $content = file_get_contents($template_path);
    
    // Remplacer les placeholders spécifiques au contexte (ex: module)
    if (!empty($extra_vars['module_name'])) {
        $content = str_replace('{{MODULE_NAME_UPPER}}', ucfirst($extra_vars['module_name']), $content);
        $content = str_replace('{{MODULE_NAME}}', $extra_vars['module_name'], $content);
    }
    
    // Remplacer les placeholders globaux
    $content = str_replace(array_keys($placeholders), array_values($placeholders), $content);
    
    // Écrire le nouveau fichier
    if (file_put_contents($destination_path, $content) === false) {
        throw new Exception("Impossible d'écrire le fichier : {$destination_path}");
    }
}

/**
 * Redirige vers index.php avec un message de statut.
 * @param string $status 'success' ou 'error'.
 * @param string $message Le message à afficher.
 */
function redirect_with_message($status, $message) {
    header('Location: index.php?status=' . $status . '&message=' . urlencode($message));
    exit;
}

