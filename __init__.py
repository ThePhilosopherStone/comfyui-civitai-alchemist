"""
ComfyUI Civitai Alchemist

A custom node extension for ComfyUI to browse Civitai images,
extract metadata, download models, and apply prompts.

This is a development environment template. Actual Civitai API
integration is left as a TODO for future implementation.
"""

from .nodes.example_node import ExampleNode

NODE_CLASS_MAPPINGS = {
    "CivitaiAlchemistExample": ExampleNode,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "CivitaiAlchemistExample": "Example Node ✨",
}

__all__ = ['NODE_CLASS_MAPPINGS', 'NODE_DISPLAY_NAME_MAPPINGS']
