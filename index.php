<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChariPHP - Générateur de back-office</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        :root { --bs-primary: #0D47A1; --bs-secondary: #FF8F00; }
        body { background-color: #f4f6f9; }
        .navbar-brand { font-weight: 700; }
        .card-header { font-weight: 600; }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark bg-primary shadow-sm">
        <div class="container">
            <span class="navbar-brand mb-0 h1"><i class="fas fa-tools me-2"></i>ChariPHP</span>
        </div>
    </nav>

    <div class="container mt-4">
        <?php if(isset($_GET['status'])): ?>
            <div class="alert alert-<?php echo $_GET['status'] === 'success' ? 'success' : 'danger'; ?> alert-dismissible fade show">
                <?php echo htmlspecialchars($_GET['message']); ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <?php endif; ?>

        <!-- Section 1: Création de Projet -->
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <i class="fas fa-rocket me-2"></i>Créer un Nouveau Projet
            </div>
            <div class="card-body">
                <form action="forge.php" method="POST">
                    <input type="hidden" name="action" value="create_project">
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label for="project_name" class="form-label">Nom du Projet (sera le nom du dossier)</label>
                            <input type="text" class="form-control" id="project_name" name="project_name" placeholder="ex: ma_clinique, gestion_stock" required>
                        </div>
                    </div>
                    <fieldset class="border p-3 mb-3">
                        <legend class="float-none w-auto px-2 fs-6">Base de Données</legend>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label for="db_host" class="form-label">Hôte</label><input type="text" class="form-control" id="db_host" name="db_host" value="localhost" required></div>
                            <div class="col-md-6 mb-3"><label for="db_name" class="form-label">Nom de la BDD</label><input type="text" class="form-control" id="db_name" name="db_name" required></div>
                            <div class="col-md-6 mb-3"><label for="db_user" class="form-label">Utilisateur</label><input type="text" class="form-control" id="db_user" name="db_user" value="root" required></div>
                            <div class="col-md-6 mb-3"><label for="db_pass" class="form-label">Mot de passe</label><input type="password" class="form-control" id="db_pass" name="db_pass"></div>
                        </div>
                    </fieldset>
                    <button type="submit" class="btn btn-primary"><i class="fas fa-hammer me-2"></i>Forger le Projet</button>
                </form>
            </div>
        </div>

        <!-- Section 2: Gestion des Modules -->
        <div class="card shadow">
            <div class="card-header bg-secondary text-white">
                <i class="fas fa-puzzle-piece me-2"></i>Gérer les Projets Existants
            </div>
            <div class="card-body">
                <?php
                    // Scan intelligent pour trouver les projets créés
                   $projects = array_filter(
                        glob('../*', GLOB_ONLYDIR) ?: [],
                        function ($dir) {

                            return
                                file_exists($dir . '/config/database.php')
                                && file_exists($dir . '/config/modules.php')
                                && is_dir($dir . '/admin/modules');
                        }
                    );

                    if (empty($projects)):
                ?>
                    <p class="text-muted">Aucun projet ChariPHP trouvé. Créez-en un ci-dessus pour commencer.</p>
                <?php else: ?>
                    <ul class="list-group">
                        <?php foreach ($projects as $project_path): 
                            $project_name = basename($project_path);
                        ?>
                            <li class="list-group-item">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                     <div>
                                        <h5 class="mb-0"><?php echo htmlspecialchars($project_name); ?></h5>
                                        <small class="text-muted"><?php echo realpath($project_path); ?></small>
                                    </div>
                                </div>
                               
                                <form action="forge.php" method="POST" class="row g-2 align-items-end p-2 bg-light rounded">
                                    <input type="hidden" name="action" value="create_module">
                                    <input type="hidden" name="project_name" value="<?php echo htmlspecialchars($project_name); ?>">
                                    
                                    <div class="col-md-5">
                                        <label for="module_name_<?php echo $project_name; ?>" class="form-label small">Nom du nouveau module</label>
                                        <input type="text" name="module_name" id="module_name_<?php echo $project_name; ?>" class="form-control form-control-sm" placeholder="ex: enseignants" required>
                                    </div>
                                    
                                    <div class="col-md-5">
                                        <label for="table_name_<?php echo $project_name; ?>" class="form-label small">Table MySQL associée (optionnel)</label>
                                        <input type="text" name="table_name" id="table_name_<?php echo $project_name; ?>" class="form-control form-control-sm" placeholder="ex: enseignants">
                                    </div>

                                    <div class="col-md-2 d-grid">
                                        <button type="submit" class="btn btn-secondary btn-sm text-nowrap"><i class="fas fa-plus me-1"></i>Créer Module</button>
                                    </div>
                                    <div class="col-12">
                                        <small class="form-text text-muted">
                                            Si vous indiquez une table, ChariPHP tentera de générer un module CRUD complet.
                                        </small>
                                    </div>
                                </form>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>