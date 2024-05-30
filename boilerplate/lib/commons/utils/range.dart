class Range {
  final int from, to;
  final List<int> _datas;

  Range(this.from, this.to)
      : _datas = List.generate(to - from + 1, (index) => from + index);

  bool contain(int value) => _datas.contains(value);


  List<T> repeat<T>(Function function) => _datas.map((e) => function.call()).toList().cast<T>();
}
