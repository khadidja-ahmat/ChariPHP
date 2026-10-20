// /assets/js/modules/{{MODULE_NAME}}.js
// Script du module {{MODULE_NAME_UPPER}}

window.initModule = function () {

    const $form = $('#mainForm');
    const $table = $('#dataTable{{MODULE_NAME_UPPER}}');
    const ajaxUrl = 'modules/{{MODULE_NAME}}/ajax_handler.php';

    // Modale Bootstrap 5
    const modal = bootstrap.Modal.getOrCreateInstance(
        document.getElementById('mainModal')
    );

    // --- DATATABLE ---
    const dataTable = $table.DataTable({
        processing: true,

        ajax: {
            url: ajaxUrl,
            type: 'POST',
            data: { action: 'fetch_items' },
            dataSrc: 'data'
        },

        columns: [
            {{DATATABLE_JS_COLUMNS}}

            {
                data: null,
                orderable: false,
                render: (data, type, row) => `
                    <div class="btn-group">
                        <button class="btn btn-warning btn-sm edit-btn"
                                data-id="${row.id}">
                            <i class="fas fa-edit"></i>
                        </button>

                        <button class="btn btn-danger btn-sm delete-btn"
                                data-id="${row.id}">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                `
            }
        ]
    });


    // --- AJOUTER ---
    $('#add-btn').on('click', function () {

        $form[0].reset();
        $('#id').val('');

        $('#mainModalLabel').text(
            'Ajouter {{MODULE_NAME_UPPER}}'
        );

        modal.show();
    });


    // --- MODIFIER ---
    $table.on('click', '.edit-btn', function () {

        const id = $(this).data('id');

        $.post(
            ajaxUrl,
            {
                action: 'fetch_single_item',
                id: id
            },
            function (response) {

                if (response.status !== 'success') {
                    toastr.error(response.message);
                    return;
                }

                const data = response.data;

                // Remplir automatiquement les champs du formulaire
                $form.find('[name]').each(function () {

                    const field = $(this).attr('name');

                    if (data[field] !== undefined) {
                        $(this).val(data[field]);
                    }
                });

                $('#id').val(data.id);

                $('#mainModalLabel').text(
                    'Modifier {{MODULE_NAME_UPPER}}'
                );

                modal.show();
            },
            'json'
        );
    });


    // --- AJOUT / MODIFICATION ---
    $form.on('submit', function (e) {

        e.preventDefault();

        $.ajax({
            url: ajaxUrl,
            type: 'POST',
            data: $form.serialize(),
            dataType: 'json',

            success: function (response) {

                if (response.status === 'success') {

                    toastr.success(response.message);

                    modal.hide();

                    dataTable.ajax.reload(null, false);

                } else {

                    toastr.error(response.message);
                }
            },

            error: function (xhr) {

                if (xhr.status === 401) {
                    window.location.href = '../login.php';
                    return;
                }

                toastr.error('Erreur de communication.');
            }
        });
    });


    // --- SUPPRIMER ---
    $table.on('click', '.delete-btn', function () {

        const id = $(this).data('id');

        if (!confirm(
            'Êtes-vous sûr de vouloir supprimer cet élément ?'
        )) {
            return;
        }

        $.post(
            ajaxUrl,
            {
                action: 'delete_item',
                id: id
            },
            function (response) {

                if (response.status === 'success') {

                    toastr.success(response.message);

                    dataTable.ajax.reload(null, false);

                } else {

                    toastr.error(response.message);
                }
            },
            'json'
        );
    });
};