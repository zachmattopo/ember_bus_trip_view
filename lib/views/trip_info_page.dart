import 'dart:async';

import 'package:ember_bus_trip_view/cubits/trip_info_cubit/trip_info_cubit.dart';
import 'package:ember_bus_trip_view/cubits/trip_info_cubit/trip_info_state.dart';
import 'package:ember_bus_trip_view/models/trip_info.dart';
import 'package:ember_bus_trip_view/services/repository.dart';
import 'package:ember_bus_trip_view/utils/app_utils.dart';
import 'package:ember_bus_trip_view/views/stop_info_list_page.dart';
import 'package:ember_bus_trip_view/views/widgets/dots_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripInfoPage extends StatelessWidget {
  const TripInfoPage({required this.tripId, super.key});

  final String tripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TripInfoCubit>(
      create: (context) => TripInfoCubit(repository: Repository.get())..fetchTripInfo(tripId),
      child: const TripInfoView(),
    );
  }
}

class TripInfoView extends StatelessWidget {
  const TripInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripInfoCubit, TripInfoState>(
      builder: (context, state) {
        if (state is TripInfoLoading) {
          return const Center(child: DotsLoadingIndicator());
        }

        if (state is TripInfoFailure) {
          return Center(child: Text(state.errorMessage));
        }

        if (state is TripInfoSuccess) {
          return TripInfoViewSuccess(tripInfo: state.tripInfo, key: UniqueKey());
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class TripInfoViewSuccess extends StatefulWidget {
  const TripInfoViewSuccess({required this.tripInfo, super.key});

  final TripInfo tripInfo;

  @override
  State<TripInfoViewSuccess> createState() => _TripInfoViewSuccessState();
}

class _TripInfoViewSuccessState extends State<TripInfoViewSuccess> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  BitmapDescriptor? _busIcon;

  @override
  void initState() {
    super.initState();
    _loadBusIcon();
  }

  Future<void> _loadBusIcon() async {
    _busIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/location_arrow_icon.png',
    );
    setState(() {});
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId(widget.tripInfo.tripId),
        icon: _busIcon ?? BitmapDescriptor.defaultMarker,
        position: LatLng(widget.tripInfo.vehicleLatitude, widget.tripInfo.vehicleLongitude),
        rotation: widget.tripInfo.vehicleHeading,
      ),
      Marker(
        markerId: const MarkerId('nextStop'),
        position: LatLng(widget.tripInfo.nextStop.lat, widget.tripInfo.nextStop.lon),
      ),
    };
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions
        .map((p) => p.latitude)
        .reduce((value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions
        .map((p) => p.latitude)
        .reduce((value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLon),
      northeast: LatLng(northeastLat, northeastLon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.tripInfo.plateNumber),
            Text(
              'Last updated: ${AppUtils.getFormattedTime(widget.tripInfo.vehicleLastUpdated)}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            style: AppUtils.googleMapsStyle,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.tripInfo.vehicleLatitude, widget.tripInfo.vehicleLongitude),
              zoom: 12,
            ),
            zoomControlsEnabled: false,
            padding: const EdgeInsets.only(bottom: 224),
            onMapCreated: (controller) {
              _controller.complete(controller);

              setState(() {
                controller.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    _createBounds([
                      LatLng(widget.tripInfo.vehicleLatitude, widget.tripInfo.vehicleLongitude),
                      LatLng(widget.tripInfo.nextStop.lat, widget.tripInfo.nextStop.lon),
                    ]),
                    50,
                  ),
                );
              });
            },
            markers: _createMarkers(),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 8,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => StopInfoListPage(stops: widget.tripInfo.stopInfoList),
                      ),
                    ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tripInfo.stopTitleText,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.tripInfo.nextStop.detailedName,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.tripInfo.nextStop.regionName,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Scheduled: ${AppUtils.getFormattedTime(widget.tripInfo.nextStop.scheduledTime)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (widget.tripInfo.nextStop.actualTime != null ||
                              widget.tripInfo.nextStop.estimatedTime != null) ...[
                            const SizedBox(width: 8),
                            if (widget.tripInfo.nextStop.isOnTime)
                              Text(
                                'On time',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(color: Colors.green),
                              )
                            else if (widget.tripInfo.nextStop.estimatedTime != null)
                              Text(
                                'Expected: ${AppUtils.getFormattedTime(widget.tripInfo.nextStop.estimatedTime!)}',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                              ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => context.read<TripInfoCubit>().fetchTripInfo(widget.tripInfo.tripId),
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
