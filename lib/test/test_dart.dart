void main() {
  List<List<String>> list = [
    ["a", "b", "c"],
    ["d", "e", "f"],
    ["g", "h", "i"]
  ];

  print(list);
  print(list.expand((element) => element).toList());
}
