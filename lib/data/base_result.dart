import 'package:dart_mappable/dart_mappable.dart';

part 'base_result.mapper.dart';

sealed class BaseResult<T> {
  TResult when<TResult extends Object?>({
    required TResult Function(T data) result,
    required TResult Function(String message) error,
  }) =>
      switch (this) {
        DataResult<T>(:final T data) => result(data),
        ErrorResult<T>(:final String message) => error(message)
      };

  T get onDataResult => (this as DataResult<T>).data;

  String get onErrorResult => (this as ErrorResult<T>).message;

  ErrorResult<T> get errorResult => (this as ErrorResult<T>);

  bool get isSuccess => this is DataResult<T>;
}

@MappableClass()
class DataResult<T> extends BaseResult<T> with DataResultMappable<T> {
  final T data;
  DataResult(this.data);
}

@MappableClass()
class ErrorResult<T> extends BaseResult<T> with ErrorResultMappable<T> {
  final String message;
  final int? statusCode;
  ErrorResult(this.message, {this.statusCode});
}