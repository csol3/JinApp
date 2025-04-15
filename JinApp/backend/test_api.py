import unittest
from fastapi.testclient import TestClient
from api import app

class TestAPI(unittest.TestCase):
    def setUp(self):
        self.client = TestClient(app)
    
    def test_root_endpoint(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"status": "healthy", "message": "JinApp API is running"})
    
    def test_get_vocabulary_sets(self):
        response = self.client.get("/vocabulary/sets")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIsInstance(data, list)
    
    def test_get_vocabulary_set(self):
        # Test with a valid set type
        response = self.client.get("/vocabulary/set/basic")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIsInstance(data, list)
        
        # Test with an invalid set type
        response = self.client.get("/vocabulary/set/nonexistent")
        self.assertEqual(response.status_code, 404)
    
    def test_get_all_sets(self):
        response = self.client.get("/vocabulary/sets/all")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIsInstance(data, dict)

if __name__ == "__main__":
    unittest.main() 