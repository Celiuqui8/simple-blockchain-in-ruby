require 'csv'

TRANSACTIONS_FILE = "transactions.csv"
def get_transactions_data

	transactions_block ||= []
	blank_transaction = Hash[from: "", to: "",
												 what: "", qty: ""]
  read_transactions_from_csv(transactions_block)
    while true
	  puts ""
      puts "Choose one option:"
      puts "1. Add new transaction"
      puts "2. Show transactions"
      puts "3. Delete transaction"
	  puts "4. Show transactions by 'what' value"
      puts "5. Logout"
      print "Choose one option: "
      opcion = gets.chomp.to_i
  
      case opcion
      when 1
            puts "" 
            puts "Enter your name for the new transaction"
            from = gets.chomp
            puts "" 
            puts "What do you want to send ?"
            what = gets.chomp
            puts "" 
            puts "How much quantity ?"
            qty  = gets.chomp
            puts "" 
            puts "Who do you want to send it to ?"
            to 	 = gets.chomp
    
            transaction = Hash[from: "#{from}", to: "#{to}", 
                                                 what: "#{what}", qty: "#{qty}"]
            transactions_block << transaction    
            append_transaction_to_csv(transaction)
    
      when 2
        show_transactions(transactions_block)

    when 3
      puts ""
      puts "Do you want to remove a transaction? (y/n)"
      answer = gets.chomp.downcase
      if answer == "y"
        if transactions_block.length > 0
          puts "Which transaction do you want to remove?"
          show_transactions(transactions_block)

          transaction_to_remove = gets.chomp.to_i
          delete_transaction_from_csv(transaction_to_remove)

          transactions_block.delete_at(transaction_to_remove - 1) # Restar 1 al índice
          puts "Transaction removed successfully"

          show_transactions(transactions_block)
        else
          puts "There are no transactions to remove"
        end
      end
	  when 4
		puts "Enter the 'what' value to filter transactions:"
		what_filter = gets.chomp
		filtered_transactions = transactions_block.select { |t| t[:what] == what_filter }
		if filtered_transactions.empty?
			puts "No transactions found with 'what' value of '#{what_filter}'"
		else
			puts "Transactions with 'what' value of '#{what_filter}':"
			filtered_transactions.each_with_index do |transaction, index|
			puts "#{index} - #{transaction}"
			end
		end

      when 5
        puts "See you soon!"
		return transactions_block
        break # Sale del bucle while cuando se selecciona la opción 4 (Salir)
      else
        puts "Opción no válida"
      end
    end
end
def append_transaction_to_csv(transaction)
  CSV.open(TRANSACTIONS_FILE, "a") do |csv|
    csv << [transaction[:from], transaction[:to], transaction[:what], transaction[:qty]]
  end
end
def read_transactions_from_csv(transactions_block)
  if File.exist?(TRANSACTIONS_FILE)
    CSV.foreach(TRANSACTIONS_FILE) do |row|
      from = row[0]
      to = row[1]
      what = row[2]
      qty = row[3]
      transaction = Hash[from: from, to: to, what: what, qty: qty]
      transactions_block << transaction
    end
  else
    puts "No transactions file found."
  end
end
def delete_transaction_from_csv(transaction_index)
  transaction_index -= 1 # Restar 1 al índice para obtener el índice correcto en el array
  transactions = CSV.read(TRANSACTIONS_FILE)
  if transaction_index >= 0 && transaction_index < transactions.length
    transaction = transactions[transaction_index]
    transactions.delete_at(transaction_index)
    File.open(TRANSACTIONS_FILE, "w") do |csv|
      transactions.each { |row| csv.puts(row.join(",")) }
    end
    puts "Transaction removed successfully"
  else
    puts "Invalid transaction index"
  end
end

def show_transactions(transactions)
  if transactions.empty?
    puts "No transactions found"
  else
    transactions.each_with_index do |transaction, index|
      puts "#{index + 1}. From: #{transaction[:from]}, To: #{transaction[:to]}, What: #{transaction[:what]}, Qty: #{transaction[:qty]}"
    end
  end
end
