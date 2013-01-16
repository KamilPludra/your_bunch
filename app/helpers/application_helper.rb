module ApplicationHelper

  # Zwraca pełny tytuł na zasadzie per-strony.
  def full_title(page_title)
    base_title = "Your Bunch"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end



  def format_text(text)
    RedCloth.new(text).to_html(:textile, :glyphs_smilies)
  end


end