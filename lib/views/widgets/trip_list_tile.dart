import 'package:ember_bus_trip_view/utils/app_utils.dart';
import 'package:ember_bus_trip_view/views/trip_info_page.dart';
import 'package:ember_bus_trip_view/views/widgets/open_container_wrapper.dart';
import 'package:flutter/material.dart';

import '../../models/trip.dart';

class TripListTile extends StatelessWidget {
  const TripListTile({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: OpenContainerWrapper(
        closedChild: ListTile(
          title: Text(
            AppUtils.getFormattedTime(trip.scheduledDeparture),
            style: TextStyle(color: _getStatusColor(trip.tripStatus), fontSize: 20),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.directions_bus, size: 16),
              const SizedBox(width: 8),
              Text(trip.numberPlate),
            ],
          ),
          trailing: _buildStatusChip(trip.tripStatus),
        ),
        openedChild: TripInfoPage(tripId: trip.tripUid),
      ),
    );
  }

  Widget _buildStatusChip(TripStatus status) {
    return Chip(
      label: Text(status.name.toUpperCase()),
      backgroundColor: _getStatusColor(status).withValues(alpha: 0.2),
      labelStyle: TextStyle(color: _getStatusColor(status)),
    );
  }

  Color _getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.past:
        return Colors.grey;
      case TripStatus.active:
        return Colors.green;
      case TripStatus.upcoming:
        return Colors.blue;
    }
  }
}
