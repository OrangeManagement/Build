alias push="git push --recurse-submodules=on-demand"
alias test="php -dpcov.enabled=1 vendor/bin/phpunit --configuration tests/phpunit_default.xml"
alias fulltest="./Build/Helper/testreport.sh"