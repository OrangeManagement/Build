<?php
/**
 * Jingga
 *
 * PHP Version 8.1
 *
 * @package   Helper
 * @copyright Dennis Eichhorn
 * @license   OMS License 2.0
 * @version   1.0.0
 * @link      https://jingga.app
 */
declare(strict_types=1);

// Create missing api functions

$modules = \scandir(__DIR__ . '/../../Modules');

$allowed = [];

function createFunction($module, $modelName)
{
    $varName = \lcfirst($modelName);
    $snakeCase = \strtolower(\preg_replace('/(?<!^)[A-Z]/', '_$0', $modelName));

    $create = <<<HEREDOC

        /**
         * Api method to create {$modelName}
         *
         * @param RequestAbstract  \$request  Request
         * @param ResponseAbstract \$response Response
         * @param mixed            \$data     Generic data
         *
         * @return void
         *
         * @api
         *
         * @since 1.0.0
         */
        public function api{$modelName}Create(RequestAbstract \$request, ResponseAbstract \$response, mixed \$data = null) : void
        {
            if (!empty(\$val = \$this->validate{$modelName}Create(\$request))) {
                \$response->data['{$snakeCase}_create'] = new FormValidation(\$val);
                \$response->header->status           = RequestStatusCode::R_400;

                return;
            }

            \${$varName} = \$this->create{$modelName}FromRequest(\$request);
            \$this->createModel(\$request->header->account, \${$varName}, {$modelName}Mapper::class, '{$snakeCase}', \$request->getOrigin());
            \$this->createStandardCreateResponse(\$request, \$response, \${$varName});
        }

        /**
         * Method to create {$modelName} from request.
         *
         * @param RequestAbstract \$request Request
         *
         * @return {$modelName}
         *
         * @todo: implement
         *
         * @since 1.0.0
         */
        private function create{$modelName}FromRequest(RequestAbstract \$request) : {$modelName}
        {
            \${$varName} = new {$modelName}();

            return \${$varName};
        }

        /**
         * Validate {$modelName} create request
         *
         * @param RequestAbstract \$request Request
         *
         * @return array<string, bool>
         *
         * @todo: implement
         *
         * @since 1.0.0
         */
        private function validate{$modelName}Create(RequestAbstract \$request) : array
        {
            \$val = [];
            if (false) {
                return \$val;
            }

            return [];
        }

    HEREDOC;

    return $create;
}

function updateFunction($module, $modelName, $helperName = '')
{
    $varName = \lcfirst($modelName);
    $snakeCase = \strtolower(\preg_replace('/(?<!^)[A-Z]/', '_$0', $modelName));

    $helperName = $helperName === '' ? $modelName : $helperName;

    $create = <<<HEREDOC

        /**
         * Api method to update {$modelName}
         *
         * @param RequestAbstract  \$request  Request
         * @param ResponseAbstract \$response Response
         * @param mixed            \$data     Generic data
         *
         * @return void
         *
         * @api
         *
         * @since 1.0.0
         */
        public function api{$modelName}Update(RequestAbstract \$request, ResponseAbstract \$response, mixed \$data = null) : void
        {
            if (!empty(\$val = \$this->validate{$modelName}Update(\$request))) {
                \$response->data[\$request->uri->__toString()] = new FormValidation(\$val);
                \$response->header->status                     = RequestStatusCode::R_400;

                return;
            }

            /** @var {$helperName} \$old */
            \$old = {$modelName}Mapper::get()->where('id', (int) \$request->getData('id'));
            \$new = \$this->update{$modelName}FromRequest(\$request, clone \$old);

            \$this->updateModel(\$request->header->account, \$old, \$new, {$modelName}Mapper::class, '{$snakeCase}', \$request->getOrigin());
            \$this->createStandardUpdateResponse(\$request, \$response, \$new);
        }

        /**
         * Method to update {$modelName} from request.
         *
         * @param RequestAbstract  \$request Request
         * @param {$helperName}     \$new     Model to modify
         *
         * @return {$helperName}
         *
         * @todo: implement
         *
         * @since 1.0.0
         */
        public function update{$modelName}FromRequest(RequestAbstract \$request, {$helperName} \$new) : {$helperName}
        {
            return \$new;
        }

        /**
         * Validate {$modelName} update request
         *
         * @param RequestAbstract \$request Request
         *
         * @return array<string, bool>
         *
         * @todo: implement
         *
         * @since 1.0.0
         */
        private function validate{$modelName}Update(RequestAbstract \$request) : array
        {
            \$val = [];
            if ((\$val['id'] = !\$request->hasData('id'))) {
                return \$val;
            }

            return [];
        }

    HEREDOC;

    return $create;
}

function deleteFunction($module, $modelName)
{
    $varName = \lcfirst($modelName);
    $snakeCase = \strtolower(\preg_replace('/(?<!^)[A-Z]/', '_$0', $modelName));

    $create = <<<HEREDOC

        /**
         * Api method to delete {$modelName}
         *
         * @param RequestAbstract  \$request  Request
         * @param ResponseAbstract \$response Response
         * @param mixed            \$data     Generic data
         *
         * @return void
         *
         * @api
         *
         * @since 1.0.0
         */
        public function api{$modelName}Delete(RequestAbstract \$request, ResponseAbstract \$response, mixed \$data = null) : void
        {
            if (!empty(\$val = \$this->validate{$modelName}Delete(\$request))) {
                \$response->data[\$request->uri->__toString()] = new FormValidation(\$val);
                \$response->header->status                     = RequestStatusCode::R_400;

                return;
            }

            /** @var \Modules\\{$module}\Models\\{$modelName} \${$varName} */
            \${$varName} = {$modelName}Mapper::get()->where('id', (int) \$request->getData('id'))->execute();
            \$this->deleteModel(\$request->header->account, \${$varName}, {$modelName}Mapper::class, '{$snakeCase}', \$request->getOrigin());
            \$this->createStandardDeleteResponse(\$request, \$response, \${$varName});
        }

        /**
         * Validate {$modelName} delete request
         *
         * @param RequestAbstract \$request Request
         *
         * @return array<string, bool>
         *
         * @todo: implement
         *
         * @since 1.0.0
         */
        private function validate{$modelName}Delete(RequestAbstract \$request) : array
        {
            \$val = [];
            if ((\$val['id'] = !\$request->hasData('id'))) {
                return \$val;
            }

            return [];
        }

    HEREDOC;

    return $create;
}

foreach ($modules as $module) {
	if ($module === '..' || $module === '.'
		|| !\is_dir(__DIR__ . '/../../Modules/' . $module)
		|| !\is_dir(__DIR__ . '/../../Modules/' . $module . '/Controller')
		|| !\is_file(__DIR__ . '/../../Modules/' . $module . '/info.json')
        || (!empty($allowed) && !\in_array($module, $allowed))
    ) {
		continue;
	}

    $controllers = \scandir(__DIR__ . '/../../Modules/' . $module . '/Controller');

	foreach ($controllers as $controller) {
        if (\stripos($controller, 'Api') === false) {
            continue;
        }

        $content = \file_get_contents(__DIR__ . '/../../Modules/' . $module . '/Controller/' . $controller);

        $matches = [];
        \preg_match_all('/(public function )(.*?)(\()/', $content, $matches);

        $create = [];
        $update = [];
        $delete = [];

        foreach ($matches[2] as $match) {
            if (\strpos($match, 'event') !== false || \strpos($match, 'api') !== 0) {
                continue;
            }

            if (\strpos($match, 'Create') !== false || \strpos($match, 'Add') !== false) {
                $create[] = $match;
            } elseif (\strpos($match, 'Update') !== false || \strpos($match, 'Change') !== false || \strpos($match, 'Set') !== false) {
                $update[] = $match;
            } elseif (\strpos($match, 'Delete') !== false || \strpos($match, 'Remove') !== false) {
                $delete[] = $match;
            }
        }

        $newContent = '';

        $missing = [];
        foreach ($create as $c) {
            $nUpdate1 = \str_replace(['Create', 'Add'], 'Update', $c);
            $nUpdate2 = \str_replace(['Create', 'Add'], 'Change', $c);
            if (!\in_array($nUpdate1, $update) && !\in_array($nUpdate2, $update)) {
                $missing[] = $nUpdate1;

                $modelName = \str_replace(['api', 'Update', 'Change', 'Set', 'Remove', 'Delete', 'Create', 'Add'], '', $c);

                $fnPos = \stripos($content, 'private function create' . $modelName . 'FromRequest');
                if ($fnPos === false) {
                    $modelRet = '';
                } else {
                    $retTypePos1 = \stripos($content, ':', $fnPos);
                    $retTypePos2 = \stripos($content, "\n", $fnPos);

                    $modelRet = \substr($content, $retTypePos1 + 1, $retTypePos2 - ($retTypePos1 + 1));
                }

                $newContent .= updateFunction($module, $modelName, \trim($modelRet, " :\n"));
                $update[] = $nUpdate1;
            }

            $nDelete1 = \str_replace(['Create', 'Add'], 'Delete', $c);
            $nDelete2 = \str_replace(['Create', 'Add'], 'Remove', $c);
            if (!\in_array($nDelete1, $delete) && !\in_array($nDelete2, $delete)) {
                $missing[] = $nDelete1;

                $modelName = \str_replace(['api', 'Update', 'Change', 'Set', 'Remove', 'Delete', 'Create', 'Add'], '', $c);
                $newContent .= deleteFunction($module, $modelName);
                $delete[] = $nDelete1;
            }
        }

        foreach ($update as $u) {
            $nCreate1 = \str_replace(['Update', 'Change', 'Set'], 'Create', $u);
            $nCreate2 = \str_replace(['Update', 'Change', 'Set'], 'Add', $u);
            if (!\in_array($nCreate1, $create) && !\in_array($nCreate2, $create)) {
                $missing[] = $nCreate1;

                $modelName = \str_replace(['api', 'Update', 'Change', 'Set', 'Remove', 'Delete', 'Create', 'Add'], '', $u);
                $newContent .= createFunction($module, $modelName);
                $create[] = $nCreate1;
            }

            $nDelete1 = \str_replace(['Update', 'Change', 'Set'], 'Delete', $u);
            $nDelete2 = \str_replace(['Update', 'Change', 'Set'], 'Remove', $u);
            if (!\in_array($nDelete1, $delete) && !\in_array($nDelete2, $delete)) {
                $missing[] = $nDelete1;

                $modelName = \str_replace(['api', 'Update', 'Change', 'Set', 'Remove', 'Delete', 'Create', 'Add'], '', $u);
                $newContent .= deleteFunction($module, $modelName);
                $delete[] = $nDelete1;
            }
        }

        foreach ($delete as $d) {
            $nCreate1 = \str_replace(['Delete', 'Remove'], 'Create', $d);
            $nCreate2 = \str_replace(['Delete', 'Remove'], 'Add', $d);
            if (!\in_array($nCreate1, $create) && !\in_array($nCreate2, $create)) {
                $missing[] = $nCreate1;

                $modelName = \str_replace(['api', 'Update', 'Change', 'Set', 'Remove', 'Delete', 'Create', 'Add'], '', $d);
                $newContent .= createFunction($module, $modelName);
                $create[] = $nCreate1;
            }

            $nUpdate1 = \str_replace(['Delete', 'Remove'], 'Update', $d);
            $nUpdate2 = \str_replace(['Delete', 'Remove'], 'Change', $d);
            if (!\in_array($nUpdate1, $update) && !\in_array($nUpdate2, $update)) {
                $missing[] = $nUpdate1;

                $modelName = \str_replace(['api', 'Update', 'Change', 'Set', 'Remove', 'Delete', 'Create', 'Add'], '', $d);
                $newContent .= updateFunction($module, $modelName);
                $create[] = $nUpdate1;
            }
        }

        if (!empty($missing)) {
            echo "\nMissing functions \"" . $module . "\": \n";

            $newContent = \rtrim($content, " }\n") . "\n    }\n" . $newContent . "}\n";
            \file_put_contents(__DIR__ . '/../../Modules/' . $module . '/Controller/' . $controller, $newContent);
        }

        foreach ($missing as $m) {
            echo $m . "\n";
        }
    }
}
