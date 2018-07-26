var langs = {
    es: {

        GENERAL_ERROR_NO_DATA_RECEIVED: 'No se recibieron datos',
        GENERAL_ERROR_INCOMPLETE_DATA: 'No se recibieron todos los datos requeridos',
        GENERAL_ERROR_DATA_BASE: 'Error de base de datos',
        GENERAL_ERROR_QUERY: 'Error en la consulta.',
        GENERAL_RESPONSE_SUCCESS: 'Completado',

        AUTH_AUTHENTICATION_EMPTY_HEADERS: 'No has enviado un Token',
        AUTH_AUTHENTICATION_FAILED: 'Tu token esta corrupto',
        AUTH_AUTHORIZATION_DENY: 'Tu usuario no cuenta con el acceso para realizar esta acción.',
        AUTH_AUTHORIZATION_HEADER_NOT_FOUND: 'Cabecera requerida no localizada.',

    },

    en: {
        GENERAL_ERROR_NO_DATA_RECEIVED: 'No data received',
        GENERAL_ERROR_INCOMPLETE_DATA: 'Not all required data are received',
        GENERAL_ERROR_DATA_BASE: 'Data base error',
        GENERAL_ERROR_QUERY: 'Query error.',
        GENERAL_RESPONSE_SUCCESS: 'Complet',

        AUTH_AUTHENTICATION_EMPTY_HEADERS: 'You did not provide a JSON Web Token in the Authorization header.',
        AUTH_AUTHENTICATION_FAILED: 'You token is corrupted',
        AUTH_AUTHORIZATION_DENY: 'You do not have permission to perform this action.',
        AUTH_AUTHORIZATION_HEADER_NOT_FOUND: 'Header required not localized.',

       

    }
}

module.exports = {
    langs: langs
};