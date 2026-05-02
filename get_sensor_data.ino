#include <DHT.h>

#define DHTPIN 2        // DHT data pin
#define DHTTYPE DHT11   // ya DHT22 use karo agar wo hai

#define MQ135_PIN A0    // Gas sensor analog pin

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin();
}

void loop() {
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();

  int mq135_value = analogRead(MQ135_PIN);

  // Simple conversion (approx ppm)
  float ammonia = map(mq135_value, 0, 1023, 0, 100);

  // Agar sensor fail ho jaye
  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("error: sensor fail");
    delay(2000);
    return;
  }

  // 🔥 IMPORTANT FORMAT (Python ke liye)
  Serial.print("data:");
  Serial.print(temperature);
  Serial.print(",");
  Serial.print(humidity);
  Serial.print(",");
  Serial.println(ammonia);

  delay(2000); // 2 sec interval
}