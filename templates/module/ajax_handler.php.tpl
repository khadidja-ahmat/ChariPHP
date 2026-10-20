{{PHP_TAG_OPEN}}
// Logique serveur générique du module {{MODULE_NAME_UPPER}}

header('Content-Type: application/json; charset=utf-8');

// Vérifier la connexion utilisateur
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (empty($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode([
        'status' => 'error',
        'message' => 'Vous devez être connecté.'
    ]);
    exit;
}

// Connexion à la base de données
require_once __DIR__ . '/../../../config/database.php';

// Vraie table choisie dans ChariPHP
$table = '{{TABLE_NAME}}';

if (empty($table)) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Aucune table MySQL associée.'
    ]);
    exit;
}

$action = $_REQUEST['action'] ?? '';

$response = [
    'status' => 'error',
    'message' => 'Action inconnue.'
];

try {

    switch ($action) {

        // =====================================================
        // AFFICHER TOUS LES ÉLÉMENTS
        // =====================================================
        case 'fetch_items':

            $stmt = $pdo->query("SELECT * FROM `{$table}`");

            $response = [
                'status' => 'success',
                'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)
            ];

            break;


        // =====================================================
        // AFFICHER UN ÉLÉMENT
        // =====================================================
        case 'fetch_single_item':

            $id = $_POST['id'] ?? null;

            if (!$id) {
                throw new Exception("Identifiant manquant.");
            }

            $stmt = $pdo->prepare(
                "SELECT * FROM `{$table}` WHERE id = ?"
            );

            $stmt->execute([$id]);

            $item = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$item) {
                throw new Exception("Élément introuvable.");
            }

            $response = [
                'status' => 'success',
                'data' => $item
            ];

            break;


        // =====================================================
        // AJOUTER OU MODIFIER
        // =====================================================
        case 'save_item':

            // Lire les colonnes réelles de la table
            $columns = $pdo
                ->query("DESCRIBE `{$table}`")
                ->fetchAll(PDO::FETCH_ASSOC);

            $data = [];

            foreach ($columns as $column) {

                $field = $column['Field'];

                // Ignorer l'identifiant automatique
                if (
                    $column['Key'] === 'PRI'
                    || str_contains(
                        strtolower($column['Extra']),
                        'auto_increment'
                    )
                ) {
                    continue;
                }

                // Ignorer les dates automatiques
                if (in_array(
                    $field,
                    ['created_at', 'updated_at'],
                    true
                )) {
                    continue;
                }

                // Prendre seulement les champs envoyés
                if (array_key_exists($field, $_POST)) {
                    $data[$field] = $_POST[$field];
                }
            }

            if (empty($data)) {
                throw new Exception(
                    "Aucune donnée à enregistrer."
                );
            }

            $id = $_POST['id'] ?? null;


            // ---------- MODIFICATION ----------
            if ($id) {

                $updates = [];

                foreach (array_keys($data) as $field) {
                    $updates[] = "`{$field}` = ?";
                }

                $sql =
                    "UPDATE `{$table}` SET "
                    . implode(', ', $updates)
                    . " WHERE id = ?";

                $values = array_values($data);
                $values[] = $id;

                $stmt = $pdo->prepare($sql);
                $stmt->execute($values);

                $response = [
                    'status' => 'success',
                    'message' => 'Élément modifié avec succès.'
                ];


            // ---------- AJOUT ----------
            } else {

                $fields = array_keys($data);

                $columns_sql =
                    '`' . implode('`, `', $fields) . '`';

                $marks =
                    implode(
                        ', ',
                        array_fill(0, count($fields), '?')
                    );

                $sql =
                    "INSERT INTO `{$table}`
                    ({$columns_sql})
                    VALUES ({$marks})";

                $stmt = $pdo->prepare($sql);
                $stmt->execute(array_values($data));

                $response = [
                    'status' => 'success',
                    'message' => 'Élément ajouté avec succès.'
                ];
            }

            break;


        // =====================================================
        // SUPPRIMER
        // =====================================================
        case 'delete_item':

            $id = $_POST['id'] ?? null;

            if (!$id) {
                throw new Exception("Identifiant manquant.");
            }

            $stmt = $pdo->prepare(
                "DELETE FROM `{$table}` WHERE id = ?"
            );

            $stmt->execute([$id]);

            $response = [
                'status' => 'success',
                'message' => 'Élément supprimé avec succès.'
            ];

            break;
    }

} catch (PDOException $e) {

    error_log(
        'Erreur BDD module {{MODULE_NAME}} : '
        . $e->getMessage()
    );

    $response = [
        'status' => 'error',
        'message' => 'Une erreur de base de données est survenue.'
    ];

} catch (Exception $e) {

    $response = [
        'status' => 'error',
        'message' => $e->getMessage()
    ];
}

// Envoyer le résultat au JavaScript
echo json_encode(
    $response,
    JSON_UNESCAPED_UNICODE
);