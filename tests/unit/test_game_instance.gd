extends "res://addons/gut/test.gd"


func test_everything_is_working():
    assert_true(true, "This should pass")


func test_easy_question_db_exist_and_is_loaded():
    var number_of_questions_on_easy_db = 67
    assert_eq(number_of_questions_on_easy_db, GameInstance.easy.size()) 

