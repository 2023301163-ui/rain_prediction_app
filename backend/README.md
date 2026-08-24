Local mock backend for the Flutter app

Quick start

1. Open a terminal and change to the `backend` folder:

```bash
cd backend
```

2. Install dependencies and start the server:

```bash
npm install
npm start
```

The mock API will run on port 3000 by default and expose:

- `GET /api/rain/latest` — sample payload for the dashboard
- `GET /api/analytics` — sample payload for the analytics page

Test with curl (from the same machine):

```bash
curl http://localhost:3000/api/rain/latest
curl http://localhost:3000/api/analytics
```

Notes for Flutter testing

- Android emulator: the app should use `http://10.0.2.2:3000/api` (already configured in services). This maps emulator -> host machine localhost.

- iOS simulator: use `http://localhost:3000/api`.

- Physical device: replace the base URL in `lib/services/rain_service.dart` and `lib/services/analytics_service.dart` with your host machine IP, e.g. `http://192.168.1.5:3000/api`.

If you want, I can add a small npm script or a Dockerfile to run this mock API in a container.
