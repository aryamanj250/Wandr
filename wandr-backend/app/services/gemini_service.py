import google.generativeai as genai
from flask import current_app

class GeminiService:
    _model = None

    @classmethod
    def get_model(cls):
        if cls._model is None:
            api_key = current_app.config.get('GEMINI_API_KEY')
            if not api_key:
                raise ValueError("GEMINI_API_KEY not configured in Flask app.")
            genai.configure(api_key=api_key)
            cls._model = genai.GenerativeModel('gemini-2.0-flash-exp')
        return cls._model

    @classmethod
    def process_text_command(cls, text: str):
        model = cls.get_model()
        # TODO: Design sophisticated prompts for Gemini
        # This is a placeholder prompt.
        prompt = f"""
        You are an AI assistant for a travel planning app called Wandr.
        Your task is to extract structured travel information from user commands.
        The user command will be a transcribed speech text, which might contain
        speech artifacts like "uhm", "like", or conversational fillers.
        
        Extract the following information and return it as a JSON object.
        If a piece of information is not explicitly mentioned, use `null`.
        
        Expected JSON format:
        {{
            "location": "string | null",
            "budget": "number | null",
            "duration_hours": "number | null",
            "preferences": "array of strings | null",
            "group_size": "number | null",
            "special_requirements": "string | null"
        }}
        
        Examples of data extraction:
        - "We're in Goa with five thousand rupees each, want some beach vibes and party stuff for eight hours"
          -> {{ "location": "Goa", "budget": 5000, "duration_hours": 8, "preferences": ["beach vibes", "party"], "group_size": null, "special_requirements": null }}
        - "I need a trip for two people to Paris for three days, budget around 2000 euros, looking for cultural sites"
          -> {{ "location": "Paris", "budget": 2000, "duration_hours": 72, "preferences": ["cultural sites"], "group_size": 2, "special_requirements": null }}
        - "Just a quick weekend getaway, something relaxing"
          -> {{ "location": null, "budget": null, "duration_hours": 48, "preferences": ["relaxing"], "group_size": null, "special_requirements": null }}
        
        User command: "{text}"
        
        Please provide only the JSON output.
        """
        
        try:
            response = model.generate_content(prompt)
            # Assuming Gemini returns text that can be parsed as JSON
            # Add robust validation and cleaning here later
            return response.text
        except Exception as e:
            current_app.logger.error(f"Gemini API error: {e}")
            raise
