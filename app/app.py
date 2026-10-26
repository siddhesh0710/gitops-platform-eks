import os
from flask import Flask, Response, jsonify, request
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest

app = Flask(__name__)
APP_VERSION = os.getenv("APP_VERSION", "dev")
HTTP_REQUESTS = Counter(
    "http_requests_total",
    "Total HTTP requests served by the demo app",
    ["method", "endpoint", "status_code", "version"],
)


@app.after_request
def record_request(response):
    # Avoid counting the metrics scrape itself in the application request ratio.
    if request.path != "/metrics":
        endpoint = request.endpoint or "unknown"
        HTTP_REQUESTS.labels(
            method=request.method,
            endpoint=endpoint,
            status_code=str(response.status_code),
            version=APP_VERSION,
        ).inc()
    return response


@app.get("/")
def index():
    return jsonify(message="GitOps demo application", version=APP_VERSION, status="ok")


@app.get("/healthz")
def healthz():
    return jsonify(status="healthy"), 200


@app.get("/readyz")
def readyz():
    return jsonify(status="ready"), 200


@app.get("/fail")
def fail():
    return jsonify(error="Intentional test failure", version=APP_VERSION), 500


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))
