# General

The Jingga build system is a collection of scripts to create builds. Builds that can get created are:

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

    software-properties-common npm git php8.3 php8.3-dev php8.3-cli php8.3-common php8.3-mysql php8.3-pgsql php8.3-xdebug php8.3-opcache php8.3-pdo php8.3-sqlite php8.3-mbstring php8.3-curl php8.3-imap php8.3-bcmath php8.3-zip php8.3-dom php8.3-xml php8.3-phar php8.3-gd php-pear apache2 mysql-server postgresql postgresql-contrib vsftpd tesseract-ocr wget curl grep xarg sed composer

## Inspections

The following inspections are performed:

* Linting
* Security
* Unit tests
* Metrics (loc, dependencies)
* Code quality (crap, code coverage, code style)

In order to perform these inspections the build system relies on third party tools as well as custom scripts.
