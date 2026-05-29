from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def home():
    version = os.environ.get('APP_VERSION', '1.0.0')
    return f"<h1>OmniTrust Enterprise Secure Delivery: Version {version}</h1><p>Zero-Trust Architecture deployed via ArgoCD.</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)