import serial
import time
from flask import Flask
from flask_cors import CORS
import threading

# ✅ Correct COM port
ARDUINO_PORT = "COM6"
BAUD_RATE = 9600

# ✅ Data storage
latest_data = {
    "temperature": 0,
    "humidity": 0,
    "ammonia": 0
}

running = True
ser = None

# 🔌 Serial connect
def init_serial():
    global ser
    try:
        ser = serial.Serial(ARDUINO_PORT, BAUD_RATE, timeout=1)
        time.sleep(2)
        print("Connected to Arduino on", ARDUINO_PORT)
        return True
    except Exception as e:
        print("Failed to connect:", e)
        return False

# 📡 Read Arduino data
def read_serial():
    global latest_data, running

    while running:
        if ser and ser.in_waiting:
            try:
                line = ser.readline().decode('utf-8').strip()

                if line.startswith("data:"):
                    parts = line.split(":")[1].split(",")

                    if len(parts) == 3:
                        latest_data = {
                            "temperature": float(parts[0]),
                            "humidity": float(parts[1]),
                            "ammonia": float(parts[2])
                        }

                        # 🔥 ONLY REQUIRED OUTPUT
                        print(f"data:{latest_data['temperature']:.2f},{latest_data['humidity']:.2f},{latest_data['ammonia']:.0f}")

            except Exception as e:
                print("Error:", e)

        time.sleep(0.2)

# 🌐 Flask setup
app = Flask(__name__)
CORS(app)

# 🔥 FINAL OUTPUT ROUTE (STRING FORMAT)
@app.route('/sensor')
def get_sensor():
    return f"data:{latest_data['temperature']:.2f},{latest_data['humidity']:.2f},{latest_data['ammonia']:.2f}"

# ▶️ Main
if __name__ == '__main__':
    if not init_serial():
        exit(1)

    threading.Thread(target=read_serial, daemon=True).start()

    print("Server running:")
    print("http://127.0.0.1:5000/sensor")
    print("http://10.247.198.30:5000/sensor")

    app.run(host='0.0.0.0', port=5000)