export default grammar({
  name: 'zero_one',

  extras: $ => [
    /\s/,
    // Add comments here if needed, e.g., /\/\/.*/
  ],

  rules: {
    source_file: $ => repeat(choice(
      $.enum_definition,
      $.seq_definition
    )),

    // Example: My_Enum : enum(u8) { NAME_1 = 0; };
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
        field('value', $.number),
        ';'
      )
    ),

    // Example: My_Seq : seq { my_enum: My_Enum; x: u8; };
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
        field('type', $.identifier),
        ';'
      )
    ),

    identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*/,

    number: $ => /-?[0-9]+/,
  }
});
