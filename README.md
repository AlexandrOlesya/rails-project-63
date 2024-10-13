[![Build Status](https://app.travis-ci.com/AlexandrOlesya/rails-project-63.svg?token=wM9UsPnqWgaioHQh7DDD)](https://app.travis-ci.com/AlexandrOlesya/rails-project-63)

# HexletCode Form Generator

## Description
This project provides a simple and flexible mechanism for generating HTML forms using Ruby. It is designed to streamline the process of working with forms in web applications, allowing developers to declaratively and conveniently describe forms based on entities.

## How to Run

1. Clone the repository:
 ```
     git clone https://github.com/your-repository/hexlet_code.git
     cd hexlet_code
```
3. Install dependencies:
```
    bundle install
```
5. Use it in your project by requiring the module:
 ```
   require 'hexlet_code'

    user = Struct.new(:name, :job).new('Alex', 'Developer')

    form = HexletCode.form_for(user) do |f|
      f.input :name
      f.input :job, as: :text
      f.submit
    end

    puts form
```
# Usage Examples
## Example Code
```
user = Struct.new(:name, :job).new('Alex', 'Developer')

form = HexletCode.form_for(user, url: '/submit') do |f|
  f.input :name
  f.input :job, as: :text
  f.submit 'Send'
end

puts form
```
## Output
```
<form action='/submit' method='post'>
  <label for='name'>Name</label>
  <input name='name' type='text' value='Alex'>
  <label for='job'>Job</label>
  <textarea name='job' rows='40' cols='20'>Developer</textarea>
  <input type='submit' value='Send'>
</form>
```
## License
The project is available under the MIT license.
