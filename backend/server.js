const express = require('express');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3000;
app.use(cors());
app.use(express.json());

const sampleRain = {
  data: {
    area: 'Barangay San Isidro',
    rainfall_mm_hr: 20.4,
    flood_risk: 'moderate',
    water_level_m: 0.75,
    temperature_c: 29,
    humidity_percent: 86,
    alert_title: 'Moderate Rainfall Detected',
    alert_message: 'Residents are advised to stay alert for possible flooding.',
    sensors: [
      { name: 'Rain Gauge', online: true },
      { name: 'Water Level Sensor', online: true },
      { name: 'ESP32 Controller', online: true },
      { name: 'Internet Connection', online: true }
    ]
  }
};

const sampleAnalytics = {
  data: {
    today_rainfall_mm_hr: 18.4,
    highest_water_level_m: 0.92,
    flood_alerts_count: 5,
    sms_sent_count: 18,
    recent_events: [
      {
        title: 'Flood Warning',
        subtitle: 'Water level reached 0.92 m.',
        time: 'Today • 2:45 PM',
        icon_name: 'warning',
        color_hex: '#f44336'
      },
      {
        title: 'Heavy Rainfall',
        subtitle: 'Rainfall reached 18.4 mm/hr.',
        time: 'Today • 2:15 PM',
        icon_name: 'cloud',
        color_hex: '#2196f3'
      }
    ]
  }
};

app.get('/api/rain/latest', (req, res) => {
  res.json(sampleRain);
});

app.get('/api/analytics', (req, res) => {
  res.json(sampleAnalytics);
});

app.listen(port, () => {
  console.log(`Mock API listening on http://localhost:${port}`);
});
