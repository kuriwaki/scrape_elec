import urllib.parse

import scrapy

from candidates.items import Candidate
from candidates.loaders import CandidateLoader


class PoliticoPresidentSpider(scrapy.Spider):

    """
    Scrapes county results from the Politico 2016 Presidential Primary website
    """

    name = "politico"
    allowed_domains = ["politico.com"]
    start_urls = ["https://www.politico.com/mapdata-2016/2016-election/primary/results/map/president/"]

    def parse(self, response):
        """
        Parse the list of states

        @url https://www.politico.com/mapdata-2016/2016-election/primary/results/map/president/
        @returns requests 650 650
        @returns items 0 0
        """
        for state in response.xpath("//table[@class='timeline-group']/tbody/tr"):
            url = response.urljoin(const.xpath("./th/a/@href").extract_first())
            yield scrapy.Request(url, callback=self.parse_constituency)

    def parse_state(self, response):
        """
        for a given state, parse the counties
        """

    def parse_county(self, response):
        """
        Parses information on county in single state.

        @url https://www.politico.com/2016-election/primary/results/map/president/arkansas/
        @returns requests 0 0
        @returns items 6 6
        @scrapes name vote
        """
        # Get the unique id of the constituency from the response URL.
        url_path = urllib.parse.urlparse(response.url).path
        code = url_path.strip("/").rsplit("/", 1)[-1]

        # The county name is in an h4 element.
        county_name = response.xpath('//*[@id="countyArkansas"]/header/div/h4/text()').extract_first()

        for cand in response.xpath("//div[@class='results-table']"):
            l = CandidateLoader(Candidate(), cand)
            l.add_value("county", county_name)
            l.add_xpath("name",
                        ".//div/div/div[1]/table/tbody/tr/th")
            l.add_xpath("votes",
                        ".//div/div/div[1]/table/tbody/tr/td[2]")
            yield l.load_item()


//*[@id="countyArkansas"]/header/div/h4
