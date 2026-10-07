# Renders a member's "What I'm made of" pie chart as inline SVG, with each slice
# labelled by an elbowed leader line instead of a percentage.
#
#   {% member_pie page.made_of %}
#
# made_of is a list of {label, value}; values are scaled to the whole pie.
require "cgi"

module SectionA
  class MemberPieTag < Liquid::Tag
    COLOURS = %w[#c9a54c #6e6d6a #e5e4e2 #7a6230 #f0dc9c].freeze
    SURFACE = "#0b0b0c".freeze
    LINE = "rgba(229, 228, 226, 0.45)".freeze
    WIDTH = 760
    HEIGHT = 420
    CX = WIDTH / 2.0
    CY = HEIGHT / 2.0
    R = 140.0
    ELBOW = 26.0
    LABEL_GAP = 40.0
    MARGIN = 24.0

    def initialize(tag_name, markup, tokens)
      super
      @variable = markup.strip
    end

    def render(context)
      slices = Array(context[@variable]).first(COLOURS.size).map do |s|
        { "label" => s["label"].to_s, "value" => s["value"].to_f }
      end.reject { |s| s["value"] <= 0 }
      total = slices.sum { |s| s["value"] }
      return "" if total <= 0

      paths = []
      callouts = []
      angle = -Math::PI / 2
      slices.each_with_index do |s, i|
        sweep = s["value"] / total * 2 * Math::PI
        paths << slice_path(angle, sweep, COLOURS[i])
        mid = angle + sweep / 2
        callouts << {
          label: s["label"],
          mid: mid,
          side: Math.cos(mid) >= 0 ? :right : :left,
          y: CY + (R + ELBOW) * Math.sin(mid)
        }
        angle += sweep
      end

      spread(callouts.select { |c| c[:side] == :right })
      spread(callouts.select { |c| c[:side] == :left })

      lines = callouts.map { |c| callout(c) }
      summary = slices.map { |s| s["label"] }.join(", ")

      <<~SVG
        <svg class="member-pie__svg" viewBox="0 0 #{WIDTH} #{HEIGHT}" role="img" aria-label="What I'm made of: #{h(summary)}">
          <g class="member-pie__slices">#{paths.join}</g>
          <g class="member-pie__callouts">#{lines.join}</g>
        </svg>
      SVG
    end

    private

    def slice_path(start, sweep, colour)
      if sweep >= 2 * Math::PI - 1e-6
        return %(<circle cx="#{f CX}" cy="#{f CY}" r="#{f R}" fill="#{colour}"/>)
      end
      x1 = CX + R * Math.cos(start)
      y1 = CY + R * Math.sin(start)
      x2 = CX + R * Math.cos(start + sweep)
      y2 = CY + R * Math.sin(start + sweep)
      large = sweep > Math::PI ? 1 : 0
      %(<path d="M#{f CX},#{f CY} L#{f x1},#{f y1} A#{f R},#{f R} 0 #{large} 1 #{f x2},#{f y2} Z" fill="#{colour}" stroke="#{SURFACE}" stroke-width="2" stroke-linejoin="round"/>)
    end

    # Keep labels on one side at least LABEL_GAP apart, inside the canvas.
    def spread(side)
      side.sort_by! { |c| c[:y] }
      side.each_cons(2) do |a, b|
        b[:y] = a[:y] + LABEL_GAP if b[:y] - a[:y] < LABEL_GAP
      end
      overflow = side.empty? ? 0 : side.last[:y] - (HEIGHT - MARGIN)
      side.each { |c| c[:y] -= overflow } if overflow.positive?
      side.each { |c| c[:y] = [c[:y], MARGIN].max }
    end

    def callout(c)
      ax = CX + (R - 18) * Math.cos(c[:mid])
      ay = CY + (R - 18) * Math.sin(c[:mid])
      ex = CX + (R + ELBOW) * Math.cos(c[:mid])
      ey = c[:y]
      right = c[:side] == :right
      end_x = right ? WIDTH - MARGIN : MARGIN
      anchor = right ? "end" : "start"
      <<~G.delete("\n")
        <g class="member-pie__callout">
        <polyline points="#{f ax},#{f ay} #{f ex},#{f ey} #{f end_x},#{f ey}" fill="none" stroke="#{LINE}" stroke-width="1"/>
        <circle cx="#{f ax}" cy="#{f ay}" r="3.5" fill="#{SURFACE}" stroke="#e5e4e2" stroke-width="1.5"/>
        <text x="#{f end_x}" y="#{f(ey - 9)}" text-anchor="#{anchor}">#{h c[:label]}</text>
        </g>
      G
    end

    def f(n)
      format("%.1f", n)
    end

    def h(s)
      CGI.escapeHTML(s)
    end
  end
end

Liquid::Template.register_tag("member_pie", SectionA::MemberPieTag)
