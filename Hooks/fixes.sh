#!/bin/bash

phpcsfix() {
    php ${rootpath}/vendor/bin/php-cs-fixer fix "$1" --rules='{"array_syntax": {"syntax": "short"}, "blank_line_after_namespace": true, "global_namespace_import": {"import_classes": false, "import_constants": false, "import_functions": false}, "binary_operator_spaces": {"operators": {"=": "align", ".=": "align", "+=": "align", "-=": "align", "*=": "align", "/=": "align", "|=": "align", "&=": "align", "=>": "align", "??=": "align", ">>=": "align", "<<=": "align"}}, "cast_spaces": {"space": "single"}, "class_attributes_separation": { "elements": {"const": "one", "method": "one", "property": "one"} }, "combine_consecutive_issets": true, "compact_nullable_typehint": true, "declare_strict_types": true, "declare_equal_normalize": {"space": "none"}, "elseif": true, "encoding": true, "explicit_indirect_variable": true, "explicit_string_variable": true, "function_to_constant": true, "implode_call": true, "increment_style": {"style": "pre"}, "is_null": true, "yoda_style": {"equal": false, "identical": false, "less_and_greater": false}, "line_ending": true, "logical_operators": true, "lowercase_cast": true, "constant_case": {"case": "lower"}, "lowercase_keywords": true, "modernize_types_casting": true, "native_constant_invocation": true, "native_function_casing": true, "native_function_invocation": {"include": ["@all"]}, "new_with_braces": true, "no_extra_blank_lines": {"tokens": ["break", "case", "continue", "curly_brace_block", "extra", "return", "switch", "throw", "use"]}, "no_spaces_after_function_name": true, "no_alias_functions": true, "no_closing_tag": true, "no_empty_comment": true, "no_empty_phpdoc": true, "no_empty_statement": true, "no_homoglyph_names": true, "no_mixed_echo_print": {"use": "echo"}, "no_php4_constructor": true, "no_singleline_whitespace_before_semicolons": true, "no_spaces_inside_parenthesis": true, "no_trailing_whitespace": true, "no_unneeded_final_method": true, "no_unused_imports": true, "no_useless_return": true, "no_whitespace_before_comma_in_array": true, "no_whitespace_in_blank_line": true, "non_printable_character": true, "normalize_index_brace": true, "ordered_imports": {"sort_algorithm": "alpha"}, "ordered_interfaces": {"order": "alpha"}, "php_unit_construct": true, "php_unit_internal_class": true, "php_unit_set_up_tear_down_visibility": true, "phpdoc_indent": true, "phpdoc_align": {"align": "vertical"}, "phpdoc_annotation_without_dot": true, "phpdoc_scalar": true, "phpdoc_return_self_reference": {"replacements": {"this": "self"}}, "phpdoc_trim": true, "phpdoc_trim_consecutive_blank_line_separation": true, "random_api_migration": true, "self_accessor": true, "return_type_declaration": {"space_before": "one"}, "semicolon_after_instruction": true, "set_type_to_cast": true, "short_scalar_cast": true, "single_blank_line_at_eof": true, "single_line_after_imports": true, "standardize_increment": true, "trailing_comma_in_multiline": true, "trim_array_spaces": true, "visibility_required": true, "void_return": true}' --allow-risky=yes

    echo 1
    return 1
}

phpcbf() {
    php ${rootpath}/vendor/bin/phpcbf --standard=${rootpath}/Build/Config/phpcs.xml "$1"

    echo 1
    return 1
}

phprector() {
    php ${rootpath}/vendor/bin/rector process --config ${rootpath}/Build/Config/rector.php "$1"

    echo 1
    return 1
}