
class CrawlingDescriptable:
    def __init__(self, description, crawling_id):
        self.description = description
        self.crawling_id = crawling_id

    def __repr__(self):
        return f"CrawlingDescriptable(description={self.description}, crawling_id={self.crawling_id})"
