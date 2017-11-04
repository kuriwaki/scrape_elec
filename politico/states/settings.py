BOT_NAME = 'candidates'
SPIDER_MODULES = ['candidates.spiders']
NEWSPIDER_MODULE = 'candidates.spiders'
CONCURRENT_REQUESTS = 32
ITEM_PIPELINES = {
    "candidates.pipelines.CandidatePipeline": 300,
}
# Order for the fields in the CSV feed export.
FEED_EXPORT_FIELDS = ["name", "party", "constituency_code", "constituency",
                      "votes", "share", "swing"]
