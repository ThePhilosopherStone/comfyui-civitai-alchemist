"""
Example Node

A simple example node that demonstrates the basic structure.
Includes a minimal API call example for testing connectivity.
"""

import requests


class ExampleNode:
    """
    Example node showing basic ComfyUI node structure.

    This node makes a simple API call to httpbin.org to demonstrate
    that network connectivity works. Replace this with actual
    Civitai API calls when implementing the real functionality.
    """

    @classmethod
    def INPUT_TYPES(cls):
        """Define input parameters for the node"""
        return {
            "required": {
                "text_input": ("STRING", {
                    "default": "Hello ComfyUI!",
                    "multiline": False,
                }),
                "number_input": ("INT", {
                    "default": 42,
                    "min": 0,
                    "max": 100,
                    "step": 1,
                }),
            },
            "optional": {
                "test_api": ("BOOLEAN", {
                    "default": False,
                    "label_on": "Test API",
                    "label_off": "Skip API Test"
                }),
            }
        }

    RETURN_TYPES = ("STRING", "STRING")
    RETURN_NAMES = ("output_text", "api_status")
    FUNCTION = "process"
    CATEGORY = "Civitai/Examples"

    def process(self, text_input, number_input, test_api=False):
        """
        Process the inputs and optionally test API connectivity.

        Args:
            text_input: Text to process
            number_input: Number to include in output
            test_api: Whether to test API connectivity

        Returns:
            tuple: (processed text, API status message)
        """
        # Simple text processing
        output = f"Processed: {text_input} (number: {number_input})"

        # Optional API test
        api_status = "API test skipped"
        if test_api:
            try:
                # Simple API call to test connectivity
                # Replace this URL with Civitai API when implementing
                response = requests.get("https://httpbin.org/get", timeout=5)
                if response.status_code == 200:
                    api_status = "API connection successful!"
                else:
                    api_status = f"API returned status {response.status_code}"
            except requests.RequestException as e:
                api_status = f"API connection failed: {str(e)}"

        print(f"[Example Node] {output}")
        print(f"[Example Node] {api_status}")

        return (output, api_status)
