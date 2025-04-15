import csv
import json
from pathlib import Path
from typing import Dict, List, Optional
import os
import time

class DataLoader:
    def __init__(self, data_dir: str = "../DataNew"):
        self.data_dir = Path(data_dir)
        self.cache_dir = Path("cache")
        self.cache_dir.mkdir(exist_ok=True)
        
    def _load_csv(self, file_path: Path) -> List[Dict]:
        """Load a CSV file and return a list of dictionaries."""
        cards = []
        with open(file_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                card = {
                    "character": row["Character"],
                    "pinyin": row["Pinyin"],
                    "translation": row["English"],
                    "example": row.get("Example", None)
                }
                cards.append(card)
        return cards
    
    def _get_cache_path(self, file_name: Path) -> Path:
        """Get the cache file path for a given CSV file."""
        return self.cache_dir / f"{file_name.stem}.json"
    
    def _is_cache_valid(self, cache_path: Path, csv_path: Path) -> bool:
        """Check if cache is valid (exists and is newer than CSV)."""
        if not cache_path.exists():
            return False
        return cache_path.stat().st_mtime > csv_path.stat().st_mtime
    
    def load_vocabulary_set(self, set_type: str) -> Optional[List[Dict]]:
        """Load a vocabulary set by type, using cache if available."""
        file_map = {
            "HSK1": "HSK1.csv",
            "Academic": "Academic.csv",
            "Press": "Press.csv",
            "Fiction": "Fiction.csv"
        }
        
        if set_type not in file_map:
            return None
        
        csv_path = self.data_dir / file_map[set_type]
        cache_path = self._get_cache_path(csv_path)
        
        # Use cache if valid
        if self._is_cache_valid(cache_path, csv_path):
            with cache_path.open('r', encoding='utf-8') as f:
                return json.load(f)
        
        # Load and process CSV
        try:
            cards = self._load_csv(csv_path)
            
            # Cache the results
            with cache_path.open('w', encoding='utf-8') as f:
                json.dump(cards, f, ensure_ascii=False, indent=2)
            
            return cards
        except Exception as e:
            print(f"Error loading {set_type}: {e}")
            return None
    
    def load_all_sets(self) -> Dict[str, List[Dict]]:
        """Load all vocabulary sets."""
        sets = {}
        for set_type in ["HSK1", "Academic", "Press", "Fiction"]:
            cards = self.load_vocabulary_set(set_type)
            if cards:
                sets[set_type] = cards
        return sets
    
    def get_set_metadata(self) -> List[Dict]:
        """Get metadata for all available sets."""
        metadata = []
        for set_type in ["HSK1", "Academic", "Press", "Fiction"]:
            cards = self.load_vocabulary_set(set_type)
            if cards:
                metadata.append({
                    "type": set_type,
                    "name": f"{set_type} Vocabulary",
                    "cardCount": len(cards),
                    "difficulty": 1 if set_type == "HSK1" else 2
                })
        return metadata 