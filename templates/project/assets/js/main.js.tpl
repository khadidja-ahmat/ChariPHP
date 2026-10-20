/*
 * /assets/js/main.js
 * Cerveau de la navigation modulaire AJAX du backend.
 * Généré par ChariPHP
 */

$(function () {
    // =========================================================================
    // 1. CONFIGURATIONS GLOBALES
    // =========================================================================
    
    // Configuration par défaut pour les notifications Toastr
    toastr.options = {
        "closeButton": true,
        "debug": false,
        "newestOnTop": true,
        "progressBar": true,
        "positionClass": "toast-top-right",
        "preventDuplicates": false,
        "onclick": null,
        "showDuration": "300",
        "hideDuration": "1000",
        "timeOut": "5000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    };
    
    // Configuration par défaut pour DataTables en français
    $.extend(true, $.fn.dataTable.defaults, {
        language: {
            url: "https://cdn.datatables.net/plug-ins/2.0.8/i18n/fr-FR.json",
        }
    });


    // =========================================================================
    // 2. LOGIQUE DE CHARGEMENT DE MODULE
    // =========================================================================

    const $mainContent = $('#main-content');
    const $loader = $('#content-loader');
    const $moduleTitle = $('#module-title');
    const $body = $('body');
    const $moduleScriptContainer = $('#module-script-container');

    // Le module par défaut vient maintenant de admin/index.php.
    const defaultModule =
        $('[data-default-module]').first().data('default-module')
        || 'dashboard';


    /**
     * Charge un module de manière asynchrone dans la zone de contenu principal.
     * @param {string} moduleName - Le nom du module (et de son dossier).
     * @param {jQuery} linkElement - L'élément <a> du menu qui a été cliqué.
     */
    function loadModule(moduleName, linkElement) {

        // Afficher le loader et griser le contenu
        $body.addClass('is-loading');
        $loader.show();
        
        $.ajax({
            // Depuis /admin/, ce chemin charge :
            // /admin/modules/<module>/index.php
            url: `modules/${moduleName}/index.php`,

            type: 'GET',
            dataType: 'html',

            success: function (response) {

                // 1. Injecter le nouveau contenu HTML
                $mainContent.html(response);
                
                // 2. Mettre à jour le titre de la page
                $moduleTitle.text(
                    $(linkElement).text().trim()
                );


                // 3. Gérer le script spécifique du module
                $moduleScriptContainer.empty();

                // Éviter de conserver initModule() de l'ancien module
                window.initModule = undefined;

                // Depuis /admin/, il faut remonter vers /assets/
                const scriptPath =
                    `../assets/js/modules/${moduleName}.js?v=${new Date().getTime()}`;
                

                // Vérifier si le script existe avant de le charger
                $.get(scriptPath)

                    .done(function (scriptContent) {

                        $moduleScriptContainer.html(
                            `<script>${scriptContent}<\/script>`
                        );

                        // Initialiser le module si son JS fournit initModule()
                        if (typeof window.initModule === 'function') {
                            window.initModule();
                        }
                    })

                    .fail(function () {

                        console.warn(
                            `Aucun script trouvé pour le module '${moduleName}' à l'emplacement '${scriptPath}'.`
                        );
                    });


                // 4. Mettre à jour l'état "actif" dans la sidebar
                $('#sidebar-wrapper .list-group-item')
                    .removeClass('active');

                $(linkElement).addClass('active');
            },


            error: function (xhr) {

                // Si la session a expiré
                if (xhr.status === 401) {
                    window.location.href = '../login.php';
                    return;
                }


                // Gestion des erreurs de chargement du module
                let errorMsg =
                    `<strong>Erreur lors du chargement du module : ${moduleName}.</strong>`;


                if (xhr.status === 404) {

                    errorMsg +=
                        `<br>Fichier introuvable : `
                        + `<code>/admin/modules/${moduleName}/index.php</code>. `
                        + `Vérifiez que le module a été créé correctement.`;

                } else if (xhr.status === 403) {

                    errorMsg +=
                        `<br>Vous n'avez pas la permission d'accéder à ce module.`;

                } else if (xhr.status === 500) {

                    errorMsg +=
                        `<br>Une erreur interne du serveur s'est produite `
                        + `dans le code PHP du module.`;
                }


                $mainContent.html(
                    `<div class="alert alert-danger">${errorMsg}</div>`
                );

                toastr.error(
                    "Impossible de charger le module.",
                    "Erreur Critique"
                );
            },


            complete: function () {

                // Cacher le loader et réactiver le contenu
                $loader.hide();
                $body.removeClass('is-loading');
            }
        });
    }


    // =========================================================================
    // 3. GESTIONNAIRES D'ÉVÉNEMENTS
    // =========================================================================
    
    // Intercepter les clics sur les liens de module dans la sidebar
    $('#sidebar-wrapper').on(
        'click',
        '.list-group-item[data-module]',
        function (e) {

            e.preventDefault();

            const moduleName =
                $(this).data('module');

            // Ne rien faire si le module est déjà actif
            if (
                moduleName
                && !$(this).hasClass('active')
            ) {
                loadModule(
                    moduleName,
                    this
                );
            }
        }
    );


    // =========================================================================
    // 4. INITIALISATION
    // =========================================================================
    
    // Avant : "accueil" était écrit en dur.
    // Maintenant le module par défaut vient de config/app.php.
    const $initialLink =
        $('#sidebar-wrapper .list-group-item[data-module="' +
            defaultModule +
        '"]');


    if ($initialLink.length) {

        loadModule(
            defaultModule,
            $initialLink
        );

    } else {

        $loader.hide();
        $body.removeClass('is-loading');

        console.warn(
            `Le module par défaut '${defaultModule}' est introuvable.`
        );
    }
});