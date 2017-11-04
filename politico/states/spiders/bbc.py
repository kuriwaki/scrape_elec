import urllib.parse

import scrapy

from candidates.items import Candidate
from candidates.loaders import CandidateLoader


class BBCConstituenciesSpider(scrapy.Spider):

    """
    Scrapes consituency results for the 2015 UK general election from the BBC's
    website.
    """

    name = "bbc"
    allowed_domains = ["bbc.co.uk", "bbc.com"]
    start_urls = ["http://www.bbc.co.uk/news/politics/constituencies"]

    def parse(self, response):
        """
        Parse the list of UK parliamentary constituencies from the BBC's
        website.

        @url http://www.bbc.co.uk/news/politics/constituencies
        @returns requests 650 650
        @returns items 0 0
        """
        for const in response.xpath("//table[@class='az-table']/tbody/tr"):
            url = response.urljoin(const.xpath("./th/a/@href").extract_first())
            yield scrapy.Request(url, callback=self.parse_constituency)

    def parse_constituency(self, response):
        """
        Parses information on individual candidates in a single consituency.

        @url http://www.bbc.co.uk/news/politics/constituencies/S14000014
        @returns requests 0 0
        @returns items 6 6
        @scrapes name party constituency_code constituency votes share swing
        """
        # Get the unique id of the constituency from the response URL.
        url_path = urllib.parse.urlparse(response.url).path
        code = url_path.strip("/").rsplit("/", 1)[-1]
        # The consituency name is in an h1 element.
        const_name = response.xpath(
            "//div[@class='constituency-title']/h1/text()").extract_first()
        for cand in response.xpath("//div[@class='party']"):
            l = CandidateLoader(Candidate(), cand)
            l.add_value("constituency_code", code)
            l.add_xpath("name",
                        ".//div[@class='party__name--candidate']/text()")
            l.add_xpath("party",
                        ".//div[@class='party__name--long']/text()")
            l.add_value("constituency", const_name)
            l.add_xpath("votes",
                        ".//li[@class='party__result--votes essential']/text()")
            l.add_xpath("share",
                        ".//li[@class='party__result--votesshare essential']/text()")
            l.add_xpath("swing",
                        ".//li[@class='party__result--votesnet essential']/span[1]/text()")
            yield l.load_item()
