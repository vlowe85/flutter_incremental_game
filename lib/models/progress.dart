class Progress {
  int clicks;
  int count;
  int autoClickers;
  int autoClickersMultiplier;
  int increaseTimerPurchases;
  int timerSpeed;

  Progress(
      {this.clicks,
        this.count,
        this.autoClickers,
        this.autoClickersMultiplier,
        this.increaseTimerPurchases,
        this.timerSpeed});

  Progress.fromJson(Map<String, dynamic> json) {
    clicks = json['clicks'];
    count = json['count'];
    autoClickers = json['auto_clickers'];
    autoClickersMultiplier = json['auto_clickers_multiplier'];
    increaseTimerPurchases = json['increase_timer_purchases'];
    timerSpeed = json['timer_speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clicks'] = this.clicks;
    data['count'] = this.count;
    data['auto_clickers'] = this.autoClickers;
    data['auto_clickers_multiplier'] = this.autoClickersMultiplier;
    data['increase_timer_purchases'] = this.increaseTimerPurchases;
    data['timer_speed'] = this.timerSpeed;
    return data;
  }
}