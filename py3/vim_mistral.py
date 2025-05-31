import json
import os
import urllib.request

def chat(system_prompt, prompt, model, temperature, model_online, model_local):
    url = get_url(model)
    headers = get_headers(model)
    data = get_data(system_prompt, prompt, model, temperature, model_online, model_local)

    try:
        req = urllib.request.Request(url=url,
                                     method="POST",
                                     headers=headers,
                                     data=data.encode("utf-8"))

        with urllib.request.urlopen(req) as resp:
            response = json.loads(resp.read().decode("utf-8"))
    except Exception as e:
        raise e

    return sanitize(model, response)

def get_data(system_prompt, prompt, model, temperature, model_online, model_local):
    if model == "online":
        return json.dumps({"model": model_online,
                           "temperature": float(temperature),
                           "messages": [{"role": "system",
                                         "content": system_prompt},
                                        {"role": "user",
                                        "content": prompt}]})
    if model == "local":
        return json.dumps({"model": model_local,
                           "options": {"temperature": float(temperature)},
                           "stream": False,
                           "system": system_prompt,
                           "prompt": prompt})
    return json.dumps({})

def get_headers(model):
    if model == "online":
        token = os.getenv("MISTRAL_API_KEY")
        if not token:
            raise Exception("MISTRAL_API_KEY environment variable is not defined!")
        return {"Authorization": f"Bearer {token}",
                "Content-Type": "application/json"}
    if model == "local":
        return {"Content-Type": "application/json"}
    return None

def get_url(model):
    if model == "online":
        return "https://api.mistral.ai/v1/chat/completions"
    if model == "local":
        return "http://localhost:11434/api/generate"
    return None

def sanitize(model, response):
    if model == "online":
        return response["choices"][0]["message"]["content"].replace('\\', '\\\\').replace('"', '\\"')
    if model == "local":
        return response["response"].strip()
    return None

