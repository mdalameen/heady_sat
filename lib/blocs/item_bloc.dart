import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:heady_sat/common/app_preferences.dart';
import 'package:heady_sat/common/category_processor.dart';
import 'package:heady_sat/common/data_provder.dart';
import 'package:heady_sat/models/carts.dart';
import 'package:heady_sat/models/items.dart';
import 'package:provider/provider.dart';

import 'data_event.dart';
import 'data_state.dart';

class ItemBloc extends Bloc<DataEvent, DataState<ItemOut>> {
  BuildContext context;
  ItemBloc(this.context) : super(DataNotFetched());

  @override
  Stream<DataState<ItemOut>> mapEventToState(DataEvent event) async* {
    if (event is LoadDataEvent) {
      yield DataLoadingState();
      ItemOut cOut = await AppPreferences.getCachedItem();

      if (cOut != null) {
        CategoryProcessor().setData(cOut);
        yield DataCachedState(cOut);
      }
      var itemOut = await DataProvider.getAllItems(context);
      if (itemOut.isSuccess) {
        CategoryProcessor().setData(itemOut.data);
        print('gonna trigger updateData');
        await Provider.of<Cart>(context, listen: false)
            .updateData(CategoryProcessor().getProductMap());
        AppPreferences.setCachedItem(itemOut.data);
        yield DataLiveState(itemOut.data);
      } else {
        yield DataErrorState(itemOut.errorMessage);
      }
    }
  }
}
