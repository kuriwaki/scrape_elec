from scrapy.loader import ItemLoader
from scrapy.loader.processors import TakeFirst, MapCompose


def make_integer(value):
    """Returns a number in a string format like "10,000" as an integer."""
    return int(value.replace(",", ""))


def make_float(value):
    """Returns a number in a string format as a float."""
    return float(value)


class CandidateLoader(ItemLoader):

    """Input and output processors for the candidates.items.Candidate class."""

    default_output_processor = TakeFirst()
    votes_in = MapCompose(make_integer)
    share_in = MapCompose(make_float)
    swing_in = MapCompose(make_float)
