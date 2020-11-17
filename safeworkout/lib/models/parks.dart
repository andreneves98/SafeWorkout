class Park{
  String name;
  String latitude;
  String longitude;
  String openinghours;

  Park(
    this.name,
    this.longitude,
    this.latitude,
   // this.openinghours,
  );
  @override
  String toString() {
    // TODO: implement toString
    return "Name=${this.name} \t Lat=${this.latitude},Long=${this.latitude} \t ";
  }
}