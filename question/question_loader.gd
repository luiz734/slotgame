extends Resource

var save_path: String =  "res://question/questions/"
var line_count = 0

func get_line_from_file(file):
    var line = file.get_line()
    #assert(line)
    line_count += 1
    return line

    

func load_text_file(file_path: String) -> Array:
    var file = FileAccess.open(file_path, FileAccess.READ)
    var questions: Array
    
    var total_lines = 0
    var question_index = 1
    while not file.eof_reached():
        var new_question = QuestionData.new()
        var category_and_diff = get_line_from_file(file)
        new_question.question = get_line_from_file(file)
        new_question.options = [
            get_line_from_file(file), 
            get_line_from_file(file), 
            get_line_from_file(file), 
            get_line_from_file(file)
        ]
        
        for index in range(len(new_question.options)):
            if new_question.options[index][0] == "*":
                # Removes the "*"
                new_question.options[index] = new_question.options[index].substr(1)
                print(new_question.options[index])
                new_question.correct = index
                break
        var _empty_line = get_line_from_file(file)
        ResourceSaver.save(new_question, save_path + "q" + str(question_index) + ".tres")
        questions.push_back(new_question)
        question_index += 1
    
    file.close()
    assert(line_count % 7 == 0, "Invalid syntax. Empty line on end?")
    return questions
