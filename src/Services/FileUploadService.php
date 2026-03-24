<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

use BbfdesignFormbuilder\Models\FormEntry;

class FileUploadService
{
    private const UPLOAD_DIR = 'media/formbuilder/uploads/';

    private const ALLOWED_MIME_TYPES = [
        'image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml',
        'application/pdf',
        'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'text/plain', 'text/csv',
        'application/zip', 'application/x-rar-compressed',
    ];

    private const MAX_FILE_SIZE = 10485760; // 10 MB

    /**
     * Handle file uploads for a submission.
     */
    public function handleUploads(int $entryId, array $fields, array $files): array
    {
        $uploadedFiles = [];
        $entryModel = new FormEntry();

        foreach ($fields as $field) {
            if ($field['type'] !== 'file_upload') {
                continue;
            }

            $fieldId = $field['id'];
            if (!isset($files[$fieldId]) || $files[$fieldId]['error'] === UPLOAD_ERR_NO_FILE) {
                continue;
            }

            $file = $files[$fieldId];

            // Validate
            $this->validateFile($file, $field);

            // Generate safe filename
            $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
            $extension = preg_replace('/[^a-zA-Z0-9]/', '', $extension);
            $storedName = bin2hex(random_bytes(16)) . '.' . $extension;

            $uploadDir = \PFAD_ROOT . self::UPLOAD_DIR . date('Y/m/');
            if (!is_dir($uploadDir)) {
                mkdir($uploadDir, 0755, true);
            }

            // Write .htaccess to prevent direct execution
            $htaccess = \PFAD_ROOT . self::UPLOAD_DIR . '.htaccess';
            if (!file_exists($htaccess)) {
                file_put_contents($htaccess, "# Prevent script execution\nRemoveHandler .php .phtml .php3 .php4 .php5\nAddType text/plain .php .phtml .php3 .php4 .php5\n");
            }

            $filePath = self::UPLOAD_DIR . date('Y/m/') . $storedName;
            $fullPath = \PFAD_ROOT . $filePath;

            if (!move_uploaded_file($file['tmp_name'], $fullPath)) {
                throw new \RuntimeException('Datei-Upload fehlgeschlagen für ' . htmlspecialchars($file['name']));
            }

            $fileId = $entryModel->saveFile([
                'entry_id'      => $entryId,
                'field_id'      => $fieldId,
                'original_name' => mb_substr($file['name'], 0, 255),
                'stored_name'   => $storedName,
                'file_path'     => $filePath,
                'mime_type'     => $file['type'],
                'file_size'     => $file['size'],
            ]);

            $uploadedFiles[$fieldId] = [
                'id'            => $fileId,
                'original_name' => $file['name'],
                'file_path'     => $filePath,
            ];
        }

        return $uploadedFiles;
    }

    private function validateFile(array $file, array $fieldConfig): void
    {
        if ($file['error'] !== UPLOAD_ERR_OK) {
            throw new \RuntimeException('Upload-Fehler: Code ' . $file['error']);
        }

        // MIME type check using finfo (not trusting client-reported type)
        $finfo = new \finfo(FILEINFO_MIME_TYPE);
        $actualMime = $finfo->file($file['tmp_name']);

        $allowedTypes = $fieldConfig['validation']['allowed_types'] ?? self::ALLOWED_MIME_TYPES;
        if (!in_array($actualMime, $allowedTypes, true)) {
            throw new \RuntimeException('Dateityp nicht erlaubt: ' . htmlspecialchars($actualMime));
        }

        // File size check
        $maxSize = $fieldConfig['validation']['max_size'] ?? self::MAX_FILE_SIZE;
        if ($file['size'] > $maxSize) {
            throw new \RuntimeException('Datei zu groß. Maximum: ' . round($maxSize / 1048576, 1) . ' MB');
        }
    }
}
