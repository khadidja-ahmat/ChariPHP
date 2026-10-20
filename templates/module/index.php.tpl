{{PHP_TAG_OPEN}}
// /admin/modules/{{MODULE_NAME}}/index.php
// Vue principale pour le module {{MODULE_NAME_UPPER}}.
// Généré intelligemment par ChariPHP
?>
<div class="container-fluid">
    <!-- Carte Principale du Module -->
    <div class="card shadow mb-4">
    
        <!-- En-tête de la Carte -->
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">Gestion des {{MODULE_NAME_UPPER}}s</h6>
            <button id="add-btn" class="btn btn-primary btn-icon-split btn-sm">
                <span class="icon text-white-50"><i class="fas fa-plus"></i></span>
                <span class="text">Ajouter un(e) {{MODULE_NAME_UPPER}}</span>
            </button>
        </div>
        
        <!-- Corps de la Carte -->
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-striped table-hover" id="dataTable{{MODULE_NAME_UPPER}}" width="100%" cellspacing="0">
                    <thead class="bg-primary text-white">
                        <tr>
                            <!-- colonnes générées dynamiquement -->
                            {{DATATABLE_COLUMNS}}
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Les données seront chargées ici par DataTables via AJAX -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modale d'ajout/modification -->
<div class="modal fade" id="mainModal" tabindex="-1" role="dialog" aria-labelledby="mainModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document"> <!-- Passage en modal-lg pour plus d'espace -->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="mainModalLabel">Ajouter un(e) {{MODULE_NAME_UPPER}}</h5>
                <button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="mainForm">
                <div class="modal-body">
                    <!-- Champ caché pour l'ID (pour la modification) -->
                    <input type="hidden" name="id" id="id">
                    <!-- Champ caché pour l'action -->
                    <input type="hidden" name="action" id="form_action" value="save_item">

                    <!-- Champs de formulaire générés dynamiquement -->
                    {{FORM_FIELDS}}

                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>