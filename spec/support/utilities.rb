# encoding: utf-8
def full_title(page_title)
  base_title = "Your Bunch"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end

  def sign_in(user)
    visit zaloguj_path
    fill_in "Twój adres e-mail",    with: user.email
    fill_in "Hasło", with: user.password
    click_button "Zaloguj się"
    # Zaloguj się, jeśli nie korzystasz z Kapibara.
    cookies[:remember_token] = user.remember_token
  end

end