# coding: UTF-8


class CandidatePipeline(object):

    """Pipeline to make corrections to party names."""

    # Corrections to make to the party names when the BBC doesn't quite have
    # it right.
    PARTY_NAMES = {
        "Sinn Fein": u"Sinn Féin",
        "Liberal Democrat": "Liberal Democrats",
    }

    def process_item(self, item, spider):
        # Correct the party name if it's required.
        item["party"] = self.PARTY_NAMES.get(item["party"], item["party"])
        return item
