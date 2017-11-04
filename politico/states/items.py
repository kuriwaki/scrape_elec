import scrapy


class Candidate(scrapy.Item):

    """A candidate in a constituency election."""

    name = scrapy.Field()
    party = scrapy.Field()
    constituency_code = scrapy.Field()
    constituency = scrapy.Field()
    votes = scrapy.Field()
    share = scrapy.Field()
    swing = scrapy.Field()
