import os
import unittest

os.environ["APP_VERSION"] = "test-version"
from app import app


class DemoAppTests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_index_returns_version(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.get_json()["version"], "test-version")

    def test_healthz(self):
        response = self.client.get("/healthz")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.get_json()["status"], "healthy")

    def test_fail_route_returns_500(self):
        response = self.client.get("/fail")
        self.assertEqual(response.status_code, 500)

    def test_metrics_endpoint(self):
        response = self.client.get("/metrics")
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"http_requests_total", response.data)


if __name__ == "__main__":
    unittest.main()
