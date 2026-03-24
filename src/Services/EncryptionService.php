<?php

declare(strict_types=1);

namespace BbfdesignFormbuilder\Services;

class EncryptionService
{
    private const KEY_FILE = 'includes/.bbf_formbuilder_key';

    /**
     * Get or generate the encryption key.
     */
    private function getKey(): string
    {
        $keyFile = \PFAD_ROOT . self::KEY_FILE;

        if (!file_exists($keyFile)) {
            $key = sodium_crypto_secretbox_keygen();
            $dir = dirname($keyFile);
            if (!is_dir($dir)) {
                mkdir($dir, 0755, true);
            }
            file_put_contents($keyFile, base64_encode($key));
            chmod($keyFile, 0600);

            // Write .htaccess to deny direct access
            $htaccess = $dir . '/.htaccess';
            if (!file_exists($htaccess)) {
                file_put_contents($htaccess, "Deny from all\n");
            }
        }

        $encoded = file_get_contents($keyFile);
        if ($encoded === false) {
            throw new \RuntimeException('Verschlüsselungsschlüssel konnte nicht gelesen werden.');
        }

        return base64_decode($encoded);
    }

    /**
     * Encrypt plaintext data.
     */
    public function encrypt(string $plaintext): string
    {
        $key = $this->getKey();
        $nonce = random_bytes(SODIUM_CRYPTO_SECRETBOX_NONCEBYTES);
        $cipher = sodium_crypto_secretbox($plaintext, $nonce, $key);

        return base64_encode($nonce . $cipher);
    }

    /**
     * Decrypt encrypted data.
     */
    public function decrypt(string $encrypted): string
    {
        $key = $this->getKey();
        $decoded = base64_decode($encrypted);

        if ($decoded === false || strlen($decoded) < SODIUM_CRYPTO_SECRETBOX_NONCEBYTES) {
            throw new \RuntimeException('Ungültige verschlüsselte Daten.');
        }

        $nonce = substr($decoded, 0, SODIUM_CRYPTO_SECRETBOX_NONCEBYTES);
        $cipher = substr($decoded, SODIUM_CRYPTO_SECRETBOX_NONCEBYTES);

        $plain = sodium_crypto_secretbox_open($cipher, $nonce, $key);
        if ($plain === false) {
            throw new \RuntimeException('Entschlüsselung fehlgeschlagen. Schlüssel ungültig oder Daten beschädigt.');
        }

        return $plain;
    }

    /**
     * Check if encryption key exists.
     */
    public function hasKey(): bool
    {
        return file_exists(\PFAD_ROOT . self::KEY_FILE);
    }
}
