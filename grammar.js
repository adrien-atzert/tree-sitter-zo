export default grammar({
  name: 'zo',

  extras: $ => [
    /\s/,
  ],

  rules: {
    source_file: $ => repeat(choice(
      $.enum_definition,
      $.seq_definition
    )),

    enum_definition: $ => seq(
      field('name', $.identifier),
      ':',
      'enum',
      '(',
      field('type', $.identifier),
      ')',
      '{',
      field('body', optional($.enum_body)),
      '}',
      ';'
    ),

    enum_body: $ => repeat1(
      seq(
        field('name', $.identifier),
        '=',
        field('value', $.literal_integer),
        ';'
      )
    ),

    seq_definition: $ => seq(
      field('name', $.identifier),
      ':',
      'seq',
      '{',
      field('body', optional($.seq_body)),
      '}',
      ';'
    ),

    seq_body: $ => repeat1(
      seq(
        field('name', $.identifier),
        ':',
        field('type', choice(
          $.identifier,
          $.array_type
        )),
        ';'
      )
    ),

    array_type: $ => seq(
      '[',
      field('size', choice($.literal_positive_integer, $.identifier)),
      ']',
      field('element_type', $.identifier)
    ),

    identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*/,

    literal_positive_integer: $ => /[0-9]+/,
    literal_integer: $ => /-?[0-9]+/,
  }
});
