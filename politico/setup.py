from setuptools import setup, find_packages


setup(
    name         = "candidates",
    version      = "1.0.0",
    packages     = find_packages(),
    entry_points = {"scrapy": ["settings = candidates.settings"]},
)

