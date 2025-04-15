from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from data_loader import DataLoader
from typing import Dict, List
import json

app = FastAPI(title="JinApp API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize data loader
data_loader = DataLoader()

@app.get("/")
def root():
    """Root endpoint for API health check."""
    return {"status": "healthy", "message": "JinApp API is running"}

@app.get("/vocabulary/sets")
def get_vocabulary_sets():
    """Get metadata for all available vocabulary sets."""
    try:
        return data_loader.get_set_metadata()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/vocabulary/set/{set_type}")
def get_vocabulary_set(set_type: str):
    """Get all cards for a specific vocabulary set."""
    cards = data_loader.load_vocabulary_set(set_type)
    if not cards:
        raise HTTPException(status_code=404, detail=f"Vocabulary set '{set_type}' not found")
    return cards

@app.get("/vocabulary/sets/all")
def get_all_sets():
    """Get all vocabulary sets with their cards."""
    try:
        return data_loader.load_all_sets()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("api:app", host="0.0.0.0", port=8000, reload=True) 