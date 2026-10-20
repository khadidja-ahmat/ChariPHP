{{PHP_TAG_OPEN}}
// /includes/sidebar.php - Menu de navigation latéral
// Généré par ChariPHP

$modules = require __DIR__ . '/../config/modules.php';
$userRole = $_SESSION['role'] ?? '';

?>

<!-- Sidebar -->
<div id="sidebar-wrapper">

    <div class="sidebar-heading">

        <a href="index.php" class="text-white text-decoration-none d-flex align-items-center">

            <!-- <img src="../assets/images/logo-white.png" alt="Logo" height="40" class="me-2"> -->

            <i class="fas fa-shield-alt fa-2x me-3"></i>

            <span>{{PROJECT_NAME}}</span>

        </a>

    </div>


    <div class="list-group list-group-flush mt-3">

        <?php foreach ($modules as $moduleName => $module): ?>

            <?php
            $roles = $module['roles'] ?? [];

            // Ne pas afficher le module si le rôle n'est pas autorisé.
            if (
                !empty($roles)
                && !in_array($userRole, $roles, true)
            ) {
                continue;
            }

            $label = $module['label'] ?? $moduleName;
            $icon = $module['icon'] ?? 'fas fa-question-circle';
            ?>

            <a
                href="#"
                class="list-group-item"
                data-module="<?= htmlspecialchars($moduleName, ENT_QUOTES, 'UTF-8') ?>"
            >

                <i class="<?= htmlspecialchars($icon, ENT_QUOTES, 'UTF-8') ?> fa-fw me-3"></i>

                <?= htmlspecialchars($label, ENT_QUOTES, 'UTF-8') ?>

            </a>

        <?php endforeach; ?>

    </div>

</div>
<!-- /#sidebar-wrapper -->