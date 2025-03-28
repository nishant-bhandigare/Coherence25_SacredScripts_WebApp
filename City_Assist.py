import os
from langchain import hub
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_groq import ChatGroq
from langchain_community.embeddings import HuggingFaceBgeEmbeddings
from dotenv import load_dotenv, find_dotenv
import gradio as gr
import requests
import base64
import json

load_dotenv(find_dotenv())

#### INDEXING ####
GROQ_API_KEY = ""
LANGCHAIN_API_KEY = ""
TAVILY_API_KEY = ""

os.environ["GROQ_API_KEY"] = GROQ_API_KEY
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_ENDPOINT"] = "https://api.smith.langchain.com"
os.environ["LANGCHAIN_API_KEY"] = LANGCHAIN_API_KEY
os.environ["LANGCHAIN_PROJECT"] = "s"
os.environ["TAVILY_API_KEY"] = TAVILY_API_KEY

# Hardcoded data for AC repair shops and other categories
data = [
    {
        "category": "AC Repair Shops",
        "entries": [
            {"name": "Cool Air Solutions", "address": "Vasai West, Near Station", "contact": "9876543210"},
            {"name": "Chill Zone Repairs", "address": "Vasai East, Opposite Mall", "contact": "9123456789"},
            # Add more entries as needed
        ],
    },
    {
        "category": "Aadhar Card Centers",
        "entries": [
            {"name": "Aadhar Enrollment Center", "address": "Vasai West, Main Road", "contact": "9988776655"},
            {"name": "UIDAI Office", "address": "Vasai East, Near Market", "contact": "8877665544"},
            # Add more entries as needed
        ],
    },
    {
        "category": "Advertising Agencies",
        "entries": [
            {"name": "Creative Ads", "address": "Vasai West, Business Park", "contact": "7766554433"},
            {"name": "Brand Builders", "address": "Vasai East, Commercial Complex", "contact": "6655443322"},
            # Add more entries as needed
        ],
    },
]

# Convert hardcoded data into documents
class Document:
    def __init__(self, page_content, metadata=None):
        self.page_content = page_content
        self.metadata = metadata or {}

docs = []
for category in data:
    for entry in category["entries"]:
        content = f"{category['category']}:\n" + "\n".join(f"{key}: {value}" for key, value in entry.items())
        docs.append(Document(page_content=content, metadata={"category": category["category"]}))

# Debugging: Log the number of documents loaded
print(f"Number of documents loaded: {len(docs)}")
if docs:
    print(f"Sample document content: {docs[0].page_content}")  # Print a snippet of the first document

# Validate if documents are loaded
if not docs:
    raise ValueError("No documents were loaded. Please check the hardcoded data.")

# Split - Chunking
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs)

# Validate if splits are created
if not splits:
    raise ValueError("No document splits were created. Please check the document content or splitter configuration.")

# Embed
model_name = "BAAI/bge-small-en"
model_kwargs = {"device": "cpu"}
encode_kwargs = {"normalize_embeddings": True}
hf_embeddings = HuggingFaceBgeEmbeddings(
    model_name=model_name, model_kwargs=model_kwargs, encode_kwargs=encode_kwargs
)

# Validate embeddings and create vectorstore
try:
    vectorstore = FAISS.from_documents(documents=splits, embedding=hf_embeddings)
except Exception as e:
    raise RuntimeError(f"Failed to create FAISS vectorstore: {e}")

retriever = vectorstore.as_retriever()  # Dense Retrieval - Embeddings/Context based

#### RETRIEVAL and GENERATION ####

# Prompt
prompt = hub.pull("rlm/rag-prompt")

# LLM
llm = ChatGroq(model="llama3-8b-8192", temperature=0)

# Post-processing
def format_docs(docs):
    return "\n\n".join(doc.page_content for doc in docs)

# Chain
rag_chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)

# Function to handle user input and generate response
def query_and_generate_audio(question):
    # Query the RAG chain
    try:
        text_response = rag_chain.invoke(question)
    except Exception as e:
        return f"Error: {e}", None

    # Generate audio using Sarvam AI
    payload = {
        "inputs": [text_response],
        "target_language_code": "hi-IN",
        "speaker": "meera",
        "pitch": 0,
        "pace": 1.2,  # Adjusted for a more natural speaking pace
        "loudness": 2.0,  # Increased for a more human-like loudness
        "speech_sample_rate": 8000,
        "enable_preprocessing": True,
        "model": "bulbul:v1"
    }

    headers = {
        'API-Subscription-Key': os.getenv('API_KEY')
    }

    try:
        response = requests.post("https://api.sarvam.ai/text-to-speech", json=payload, headers=headers)
        response.raise_for_status()
        json_data = response.json()
        base64_string = json_data["audios"][0]
        wav_data = base64.b64decode(base64_string)

        # Save the audio to a file
        audio_file = "output.wav"
        with open(audio_file, "wb") as wav_file:
            wav_file.write(wav_data)

        return text_response, audio_file
    except Exception as e:
        return f"Error generating audio: {e}", None

# Gradio interface
def gradio_interface(question):
    text_response, audio_file = query_and_generate_audio(question)
    return text_response, audio_file

# Create Gradio app
interface = gr.Interface(
    fn=gradio_interface,
    inputs=gr.Textbox(label="Enter your question"),
    outputs=[
        gr.Textbox(label="Text Response"),
        gr.Audio(label="Audio Response")
    ],
    title="Smart City Assistant",
    description="Ask questions about services in Vasai and get responses in text and audio."
)

# Launch the Gradio app
if __name__ == "__main__":
    interface.launch()

# Question
print(rag_chain.invoke("AC repair shops in Vasai with phone number?"))