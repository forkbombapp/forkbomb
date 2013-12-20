module ForksHelper
  
  def badge_markdown(fork)
    %{[![#{t(:fork_status)}](#{fork_badge_url(fork, format: 'png')})](#{fork_url(fork)})}
  end
  
  def badge_textile(fork)
    %{!#{fork_badge_url(fork, format: 'png')}(#{t(:fork_status)})!:#{fork_url(fork)}}
  end

  def badge_rdoc(fork)
    %{{<img src="#{fork_badge_url(fork, format: 'png')}" alt="#{t(:fork_status)}" />}[#{fork_url(fork)}]}
  end

  def badge_html(fork)
    %{<a href='#{fork_url(fork)}'><img src="#{fork_badge_url(fork, format: 'png')}" alt="#{t(:fork_status)}" /></a>}
  end

end
