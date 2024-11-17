enum STUNServerEnum {
  AKS,
  GKE,
  ISS,
}

class STUNServerType {
  static STUNServerEnum fromString(String value) {
    switch (value) {
      case 'AKS':
        return STUNServerEnum.AKS;
      case 'GKE':
        return STUNServerEnum.GKE;
      case 'ISS':
        return STUNServerEnum.ISS;
      default:
        throw Exception('Unknown type: $value');
    }
  }
}
