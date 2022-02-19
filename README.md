# General

The Karaka build system is a collection of scripts to create builds. Builds that can get created are:

* Public release builds
* Public developer release builds

On top of the release builds the build system can also perform automated code inspections. This allows to run all tests and inspections without interaction and generates a report for developers at the end.

The last feature is the backend and documentation generation based on the DocBlock documentation.

# Setup

* Clone the repository somewhere save
* Check out the `install.sh` file and/or run it
* Modify the `config.sh` file to your needs
* Run `buildProject.sh`

## Dependencies

The build system will take care of most requirements, the following tools and commands have to be available on the system.

    software-properties-common npm git php8.0 php8.0-dev php8.0-cli php8.0-common php8.0-mysql php8.0-pgsql php8.0-xdebug php8.0-opcache php8.0-pdo php8.0-sqlite php8.0-mbstring php8.0-curl php8.0-imap php8.0-bcmath php8.0-zip php8.0-dom php8.0-xml php8.0-phar php8.0-gd php-pear apache2 mysql-server postgresql postgresql-contrib vsftpd tesseract-ocr wget curl grep xarg sed composer

## Inspections

The following inspections are performed:

* Linting
* Security
* Unit tests
* Metrics (loc, dependencies)
* Code quality (crap, code coverage, code style)

In order to perform these inspections the build system relies on third party tools as well as custom scripts.
