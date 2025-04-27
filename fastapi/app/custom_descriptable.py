from ai.descripable import Descriptable

class UserDescriptable(Descriptable):
    intro: str
    departments: list[str]
    yob: int
    student_id: int
    gender: str
    user_id: str

    def __init__(self, intro, departments, yob, student_id, gender, user_id):
        super().__init__(intro, user_id)
        self.intro = intro
        self.departments = departments
        self.yob = yob
        self.student_id = student_id
        self.gender = gender
        self.user_id = user_id

class RoomDescriptable(Descriptable):
    room_id: str

    def __init__(self, description, room_id):
        super().__init__(description, room_id)
        self.room_id = room_id

class CrawlingDescriptable(Descriptable):
    crawling_id: str

    def __init__(self, description, crawling_id):
        super().__init__(description, crawling_id)
        self.crawling_id = crawling_id
