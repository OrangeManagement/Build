# General

The Orange Management build system is a collection of scripts to create builds. Builds that can get created are:

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

    software-properties-common npm git php7.4 php7.4-dev php7.4-cli php7.4-common php7.4-mysql php7.4-pgsql php7.4-xdebug php7.4-json php7.4-opcache php7.4-pdo php7.4-sqlite php7.4-mbstring php7.4-curl php7.4-imap php7.4-bcmath php7.4-zip php7.4-dom php7.4-xml php7.4-phar php7.4-gd php-pear apache2 mysql-server postgresql postgresql-contrib vsftpd tesseract-ocr wget curl grep xarg sed composer

## Inspections

The following inspections are performed:

* Linting
* Security
* Unit tests
* Metrics (loc, dependencies)
* Code quality (crap, code coverage, code style)

In order to perform these inspections the build system relies on third party tools as well as custom scripts.
