class Word {
  final String en;
  final String bn;
  final List<String> pron;
  final List<String> bnSyns;
  final List<String> enSyns;
  final List<String> sents;

  Word({
    required this.en,
    required this.bn,
    required this.pron,
    required this.bnSyns,
    required this.enSyns,
    required this.sents,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      en: json['en'] ?? '',
      bn: json['bn'] ?? '',
      pron: (json['pron'] != null && json['pron'] is List)
          ? List<String>.from(json['pron'].map((item) => item.toString()))
          : [],
      bnSyns: (json['bn_syns'] != null && json['bn_syns'] is List)
          ? List<String>.from(json['bn_syns']!)
          : [],
      enSyns: (json['en_syns'] != null && json['en_syns'] is List)
          ? List<String>.from(json['en_syns']!)
          : [],
      sents: (json['sents'] != null && json['sents'] is List)
          ? List<String>.from(json['sents']!)
          : [],
    );
  }
}
