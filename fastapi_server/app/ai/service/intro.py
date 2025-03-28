import openai

client = openai.OpenAI(api_key="")

def query(user_input, model, temperature):
    response = client.chat.completions.create(
        model=model,
        temperature=temperature,
        messages=[
            {"role": "system", "content": "be creative but rational"},
            {"role": "user", "content": user_input}
        ]
    )

    return response.choices[0].message.content

# not completed