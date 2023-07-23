abstract interface class Repository<T, D> {
  Future<List<T>> getAll();
  Future<T> get(int id);
  Future<T> add(D data);
  Future<T> update(int id, D data);
  Future<void> delete(int id);
  Future<void> move(int id, int position);
}
