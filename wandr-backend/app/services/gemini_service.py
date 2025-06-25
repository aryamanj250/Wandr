import google.generativeai as genai
# Removed 'from flask import current_app' as it will no longer be directly used in get_model

class GeminiService:
    # _model will now be initialized per thread/process if not passed directly
    # For simplicity, we'll re-configure per call in the background thread.

    @classmethod
    def get_model(cls, api_key: str):
        if not api_key:
            raise ValueError("GEMINI_API_KEY not provided to GeminiService.")
        genai.configure(api_key=api_key)
        # Note: In a multi-threaded/multi-process environment,
        # genai.configure might need more careful handling if it's not thread-safe.
        # For this specific fix, re-configuring per call in the background thread is acceptable.
        return genai.GenerativeModel('gemini-2.0-flash-exp')

    @classmethod
    def process_text_command(cls, text: str, api_key: str):
        # Pass the API key to get_model
        model = cls.get_model(api_key)
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
            # Add a timeout to the generate_content call
            response = model.generate_content(prompt, request_options={"timeout": 60}) # 60 seconds timeout
            # Assuming Gemini returns text that can be parsed as JSON
            # Add robust validation and cleaning here later
            return response.text
        except Exception as e:
            # Log the error using a standard logger or print, as current_app might not be available
            print(f"Gemini API error in background thread: {e}", file=sys.stderr)
            raise
