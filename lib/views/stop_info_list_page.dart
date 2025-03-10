import 'package:ember_bus_trip_view/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../models/stop_info.dart';

class StopInfoListPage extends StatelessWidget {
  const StopInfoListPage({required this.stops, super.key});

  final List<StopInfo> stops;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Stops')),
      body: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          connectorTheme: ConnectorThemeData(
            thickness: 3,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemCount: stops.length,
          contentsBuilder: (_, index) {
            final stop = stops[index];
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.detailedName,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: _getStatusColor(stop.stopStatus)),
                  ),
                  const SizedBox(height: 4),
                  Text(stop.regionName, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: _getStatusColor(stop.stopStatus)),
                      const SizedBox(width: 4),
                      Text(
                        AppUtils.getFormattedTime(stop.scheduledTime),
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: _getStatusColor(stop.stopStatus)),
                      ),
                      if (stop.actualTime != null) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.check_circle, size: 16, color: _getStatusColor(stop.stopStatus)),
                        const SizedBox(width: 4),
                        Text(
                          AppUtils.getFormattedTime(stop.actualTime!),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: _getStatusColor(stop.stopStatus)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
          indicatorBuilder: (_, index) {
            final stop = stops[index];
            return DotIndicator(
              color: _getStatusColor(stop.stopStatus),
              child:
                  stop.stopStatus == StopStatus.upcoming
                      ? Icon(
                        Icons.directions_bus,
                        size: 16,
                        color: Theme.of(context).colorScheme.surface,
                      )
                      : null,
            );
          },
          connectorBuilder: (_, index, __) {
            final stop = stops[index];
            return SolidLineConnector(color: _getStatusColor(stop.stopStatus));
          },
        ),
      ),
    );
  }

  Color _getStatusColor(StopStatus status) {
    return status == StopStatus.upcoming ? Colors.blue : Colors.grey;
  }
}
