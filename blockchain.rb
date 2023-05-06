require 'digest'
require 'pp'
require_relative 'block'
require_relative 'transaction'

LEDGER = []

USERS = {
  "FanXu" => Digest::SHA256.hexdigest("Fan123"),
  "Raquel" => Digest::SHA256.hexdigest("Raquel123"),
  "Celia" => Digest::SHA256.hexdigest("Celia123")
}

TRANSACTIONS_FILE = "transactions.csv"

def authenticate_user
  puts "Enter username: "
  username = gets.chomp
  puts "Enter password"
  password = gets.chomp
  if USERS[username] == Digest::SHA256.hexdigest(password)
    puts "Authentication successful"
    return true
  else
    puts "Authentication error: incorrect username or password"
    return false
  end
end

def create_transactions_file
  CSV.open(TRANSACTIONS_FILE, "w") {}
end

def create_first_block
  i = 0
  instance_variable_set(
    "@b#{i}",
    Block.first(
      { from: "Dutchgrown", to: "Vincent", what: "Tulip Bloemendaal Sunset", qty: 10 },
      { from: "Keukenhof", to: "Anne", what: "Tulip Semper Augustus", qty: 7 }
    )
  )
  LEDGER << instance_variable_get("@b#{i}")
  pp instance_variable_get("@b#{i}")
  p "============================"
  add_block
end

def add_block
  i = 1
  loop do
    if authenticate_user
      instance_variable_set(
        "@b#{i}",
        Block.next(instance_variable_get("@b#{i - 1}"), get_transactions_data)
      )
      LEDGER << instance_variable_get("@b#{i}")
      p "============================"
      pp instance_variable_get("@b#{i}")
      p "============================"
      i += 1
    end
    break unless continue_operation?
  end
end

def write_transactions_to_csv(transactions)
  CSV.open(TRANSACTIONS_FILE, "a") do |csv|
    transactions.each do |transaction|
      csv << [transaction[:from], transaction[:to], transaction[:what], transaction[:qty]]
    end
  end
end

def continue_operation?
  puts ""
  puts "Do you want to continue with another user? (Y/N)"
  choice = gets.chomp.downcase
  choice == 'y'
end

def launcher
  puts "==========================="
  puts ""
  puts "Welcome to Simple Blockchain In Ruby !"
  puts ""
  sleep 1.5
  puts "This program was created by Anthony Amar for educational purposes"
  puts ""
  sleep 1.5
  puts "Wait for the genesis (the first block of the blockchain)"
  puts ""
  10.times do
    print "."
    sleep 0.5
  end
  puts ""
  puts ""
  puts "==========================="

  while true
    puts ""
    puts "Choose an option: "
    puts "1. Enter the blockchain with a username and password"
    puts "2. Exit the program"
    opcion = gets.chomp.to_i

    case opcion
    when 1
      create_transactions_file
      create_first_block
	  break
    when 2
      puts "Bye!"
      break
    else
      puts "Invalid option"
    end
  end
end

launcher
