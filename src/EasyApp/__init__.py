import importlib.metadata

# Set package version
try:
    __version__ = importlib.metadata.version("EasyApp")
except ImportError:
    __version__ = "development"