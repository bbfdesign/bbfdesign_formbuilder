<?php

// Simple PSR-4 autoloader for BbfdesignFormbuilder namespace
spl_autoload_register(function ($class) {
    $prefix = 'BbfdesignFormbuilder\\';
    $baseDir = __DIR__ . '/../src/';

    $len = strlen($prefix);
    if (strncmp($prefix, $class, $len) !== 0) {
        return;
    }

    $relativeClass = substr($class, $len);
    $file = $baseDir . str_replace('\\', '/', $relativeClass) . '.php';

    if (file_exists($file)) {
        require $file;
    }
});
