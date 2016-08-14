class Accounts

  def get_value(key)
    file = File.open('../../resources/accounts.txt', 'r')
    file.each_line do |line|
      if line.include? key + ' = '
        value = line
        value.slice! key + ' = '
        return value.chomp
      end
    end
  end

end