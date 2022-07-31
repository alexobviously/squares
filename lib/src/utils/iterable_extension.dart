extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T e) test) {
    for (T e in this) {
      if (test(e)) return e;
    }
    return null;
  }

  Iterable<List<T>> partition(int size) sync* {
    Iterator<T> iterator = this.iterator;
    if (!iterator.moveNext()) return;
    T previous = iterator.current;
    List<T> chunk = [previous];
    int index = 0;
    while (iterator.moveNext()) {
      T element = iterator.current;
      if (++index % size == 0) {
        yield chunk;
        chunk = [];
      }
      chunk.add(element);
      previous = element;
    }
    yield chunk;
  }

  Iterable<T> countAndReplace(T target, T Function(int count) replacer) sync* {
    Iterator<T> iterator = this.iterator;
    int count = 0;
    while (iterator.moveNext()) {
      T element = iterator.current;
      if (element == target) {
        count++;
      } else {
        if (count > 0) {
          yield replacer(count);
          count = 0;
        }
        yield element;
      }
    }
    if (count > 0) {
      yield replacer(count);
    }
  }
}
