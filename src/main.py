from src import app
from src.app import PodcastGenerator
from src.news_api_client import *
from config import *
from scraper import *
from src.audio import *

# CLASS FOR DEMONSTRATION, WON'T BE USED
q = "ekonomi (site:bbc.com OR site:cnn.com)"
client = BingNewsClient(BING_NEWS_API_KEY)
articles = client.fetch_news_query(q,"tr-TR","tr")

audio  = Audio(articles,"Ekonomi","Türkiye","tr","tr_summary.mp3")
audio.create_audio()
transcript = audio.get_transcript()

with open("transcript.txt", "w") as file:
    file.write(transcript)

with open("description_text", "w") as file:
    file.write(audio.description_text)
