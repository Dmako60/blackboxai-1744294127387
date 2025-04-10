<?php
/**
 * Installation script for Property App
 * This script helps set up the necessary directories and configurations
 */

// Configuration
$requiredPhpVersion = '7.4.0';
$requiredExtensions = [
    'pdo',
    'pdo_mysql',
    'fileinfo',
    'gd',
    'json',
    'mbstring',
    'openssl'
];

$directories = [
    'admin_dashboard/uploads',
    'admin_dashboard/uploads/properties',
    'admin_dashboard/uploads/temp'
];

$configFiles = [
    'admin_dashboard/config.example.php' => 'admin_dashboard/config.php'
];

// Header
echo "===========================================\n";
echo "Property App Installation Script\n";
echo "===========================================\n\n";

// Check PHP version
echo "Checking PHP version... ";
if (version_compare(PHP_VERSION, $requiredPhpVersion, '>=')) {
    echo "OK (", PHP_VERSION, ")\n";
} else {
    echo "FAILED\n";
    echo "Required PHP version: ", $requiredPhpVersion, " or higher\n";
    echo "Current PHP version: ", PHP_VERSION, "\n";
    exit(1);
}

// Check required extensions
echo "\nChecking required PHP extensions...\n";
$missingExtensions = [];
foreach ($requiredExtensions as $ext) {
    echo "  - $ext... ";
    if (extension_loaded($ext)) {
        echo "OK\n";
    } else {
        echo "MISSING\n";
        $missingExtensions[] = $ext;
    }
}

if (!empty($missingExtensions)) {
    echo "\nError: The following PHP extensions are required but missing:\n";
    foreach ($missingExtensions as $ext) {
        echo "  - $ext\n";
    }
    exit(1);
}

// Create directories
echo "\nCreating required directories...\n";
foreach ($directories as $dir) {
    echo "  - $dir... ";
    if (!file_exists($dir)) {
        if (mkdir($dir, 0777, true)) {
            echo "CREATED\n";
        } else {
            echo "FAILED\n";
            echo "Error: Unable to create directory: $dir\n";
            exit(1);
        }
    } else {
        echo "EXISTS\n";
    }
}

// Copy configuration files
echo "\nSetting up configuration files...\n";
foreach ($configFiles as $source => $dest) {
    echo "  - $dest... ";
    if (!file_exists($dest)) {
        if (copy($source, $dest)) {
            echo "CREATED\n";
        } else {
            echo "FAILED\n";
            echo "Error: Unable to copy $source to $dest\n";
            exit(1);
        }
    } else {
        echo "EXISTS\n";
    }
}

// Database setup
echo "\nDatabase Setup\n";
echo "===========================================\n";
echo "Please enter your database credentials:\n";

$dbHost = readline("Database Host (default: localhost): ") ?: 'localhost';
$dbName = readline("Database Name (default: property_app): ") ?: 'property_app';
$dbUser = readline("Database Username (default: root): ") ?: 'root';
$dbPass = readline("Database Password: ");

// Test database connection
echo "\nTesting database connection... ";
try {
    $pdo = new PDO(
        "mysql:host=$dbHost",
        $dbUser,
        $dbPass,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
    
    // Create database if it doesn't exist
    $pdo->exec("CREATE DATABASE IF NOT EXISTS `$dbName`");
    $pdo->exec("USE `$dbName`");
    
    echo "OK\n";
    
    // Import database schema
    echo "Importing database schema... ";
    $sql = file_get_contents('database.sql');
    $pdo->exec($sql);
    echo "OK\n";
    
    // Update config file with database credentials
    echo "Updating configuration file... ";
    $configFile = 'admin_dashboard/config.php';
    $config = file_get_contents($configFile);
    $config = str_replace("'localhost'", "'$dbHost'", $config);
    $config = str_replace("'property_app'", "'$dbName'", $config);
    $config = str_replace("'root'", "'$dbUser'", $config);
    $config = str_replace("''", "'$dbPass'", $config);
    file_put_contents($configFile, $config);
    echo "OK\n";
    
} catch (PDOException $e) {
    echo "FAILED\n";
    echo "Error: " . $e->getMessage() . "\n";
    exit(1);
}

// Final instructions
echo "\n===========================================\n";
echo "Installation completed successfully!\n\n";
echo "Next steps:\n";
echo "1. Configure your web server to point to the project directory\n";
echo "2. Update the remaining configuration in admin_dashboard/config.php:\n";
echo "   - Firebase settings\n";
echo "   - Payment gateway credentials\n";
echo "   - Application URL\n";
echo "3. Access the admin dashboard at: http://your-domain/admin_dashboard/\n";
echo "   Default admin credentials:\n";
echo "   Email: admin@example.com\n";
echo "   Password: admin123\n\n";
echo "4. For security, please change the admin password after first login\n";
echo "===========================================\n";
