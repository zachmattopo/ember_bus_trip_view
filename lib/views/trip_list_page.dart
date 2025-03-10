import 'package:ember_bus_trip_view/services/repository.dart';
import 'package:ember_bus_trip_view/views/widgets/dots_loading_indicator.dart';
import 'package:ember_bus_trip_view/views/widgets/trip_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/trip_list_cubit/trip_list_cubit.dart';
import '../cubits/trip_list_cubit/trip_list_state.dart';

class TripListPage extends StatelessWidget {
  const TripListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trips Today')),
      body: BlocProvider<TripListCubit>(
        create: (context) => TripListCubit(repository: Repository.get())..fetchTripList(),
        child: const TripListView(),
      ),
    );
  }
}

class TripListView extends StatelessWidget {
  const TripListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripListCubit, TripListState>(
      builder: (context, state) {
        if (state is TripListLoading) {
          return const Center(child: DotsLoadingIndicator());
        }

        if (state is TripListFailure) {
          return Center(child: Text(state.errorMessage));
        }

        if (state is TripListSuccess) {
          return RefreshIndicator(
            onRefresh: () => context.read<TripListCubit>().fetchTripList(),
            child: ListView.builder(
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                final trip = state.trips[index];
                return TripListTile(trip: trip);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
