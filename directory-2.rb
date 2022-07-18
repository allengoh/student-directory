@students = [] # an empty array accessible to all methods

def input_students
  puts "Please enter the name of the students"
  puts "To finish, just hit return twice"
  #create an empty array
  #students = []
  #get the first name
  name = gets.chomp
  #while the name is not empty, repeat this code
  while !name.empty? do
    #add the student hash to the array
    @students << {name: name, cohort: :november}
    plural = @students.length > 1 ? "s" : ""
    puts "Now we have #{@students.count} student#{plural}"
    #get another name from the user
    name = STDIN.gets.chomp
  end
  #return the array of students
  #students
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "5. Enter initial to search for specific student(s)"
  puts "9. Exit"
end

def show_students
  print_header
  print_students_list
  print_footer
end

def save_students
  #open the file for writing
  file = File.open("students.csv", "w")
  #iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
  name, cohort = line.chomp.split(",")
    @students << {name: name, cohort: cohort.to_sym}
  end
  file.close
end


def try_load_students
  filename = ARGV.first #first argument from the command line
  return if filename.nil? #get out of the method if it isn't given
  if File.exist?(filename) #if it exists
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else #if it doesn't exist
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end


def process(selection)
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    save_students
  when "4"
    load_students
  when "5"
    search_with_initial
  when "9"
    exit
  else
    puts "I don't know what you mean, try again"
  end
end

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def search_with_initial
  puts "Enter the first letter of the name?"
  @specific_letter = gets.chomp
  while @specific_letter.length > 1
    puts "You have entered more than one character, please try again."
    @specific_letter = gets.chomp
  end
  
  @students.each do |student|
    if student[:name][0] == @specific_letter
      puts "#{student[:name]} (#{student[:cohort]} cohort)"
    end
  end
end


def print_students_list
  @students.each_with_index do |student, index|
    puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students"
end

try_load_students
interactive_menu
