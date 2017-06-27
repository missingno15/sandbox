require "capybara"
require "selenium-webdriver"
require "pry"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: ["no-sandbox", "headless", "disable-gpu"]}
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.default_driver = :headless_chrome

browser = Capybara.current_session
url = "http://qiita.com/"

binding.pry
