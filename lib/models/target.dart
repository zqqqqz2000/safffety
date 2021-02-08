import 'package:ping_discover_network/ping_discover_network.dart';

class Target {
  NetworkAddress address;
  List<int> ports;

  Target(this.address, this.ports);
}