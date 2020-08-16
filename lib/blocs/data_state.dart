import 'package:equatable/equatable.dart';

class DataState<T> extends Equatable {
  @override
  List<Object> get props => [];
}

class DataNotFetched<T> extends DataState<T> {}

class DataLoadingState<T> extends DataState<T> {}

class DataCachedState<T> extends DataState<T> {
  final T data;
  DataCachedState(this.data);
}

class DataLiveState<T> extends DataCachedState<T> {
  DataLiveState(T data) : super(data);
}

class DataErrorState<T> extends DataState<T> {
  final String errorMessage;
  DataErrorState(this.errorMessage);
}
