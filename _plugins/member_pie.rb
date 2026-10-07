# Renders a member's "What I'm made of" pie chart as inline SVG, with each slice
# labelled by an elbowed leader line instead of a percentage.
#
#   {% member_pie page.made_of %}
#
# made_of is a list of {label, value}; values are scaled to the whole pie.
# Two SVGs are drawn: a wide one, and a compact one for phones (CSS shows one).
require "cgi"

module SectionA
  class MemberPieTag < Liquid::Tag
    COLOURS = %w[#e0b84a #6e6d6a #e5e4e2 #7a6230 #f0dc9c].freeze
    SURFACE = "#0b0b0c".freeze
    LINE = "rgba(229, 228, 226, 0.45)".freeze
    LAYOUTS = {
      "wide" => { width: 760, height: 420, r: 120.0, elbow: 22.0, inset: 18.0, line_height: 28.0, label_pad: 14.0, wrap: 13, margin: 20.0, baseline: 10.0 },
      "phone" => { width: 360, height: 240, r: 62.0, elbow: 12.0, inset: 12.0, line_height: 17.0, label_pad: 8.0, wrap: 12, margin: 4.0, baseline: 6.0 }
    }.freeze

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

      summary = slices.map { |s| s["label"] }.join(", ")
      LAYOUTS.map { |name, layout| svg(name, layout, slices, total, summary) }.join
    end

    private

    def svg(name, l, slices, total, summary)
      @l = l
      @cx = l[:width] / 2.0
      @cy = l[:height] / 2.0
      paths = []
      callouts = []
      angle = -Math::PI / 2
      slices.each_with_index do |s, i|
        sweep = s["value"] / total * 2 * Math::PI
        paths << slice_path(angle, sweep, COLOURS[i])
        mid = angle + sweep / 2
        callouts << {
          label: s["label"],
          lines: wrap(s["label"]),
          mid: mid,
          side: Math.cos(mid) >= 0 ? :right : :left,
          y: @cy + (l[:r] + l[:elbow]) * Math.sin(mid)
        }
        angle += sweep
      end

      spread(callouts.select { |c| c[:side] == :right })
      spread(callouts.select { |c| c[:side] == :left })

      lines = callouts.map { |c| callout(c) }

      <<~SVG
        <svg class="member-pie__svg  member-pie__svg--#{name}" viewBox="0 0 #{l[:width]} #{l[:height]}" role="img" aria-label="What I'm made of: #{h(summary)}">
          <g class="member-pie__slices">#{paths.join}</g>
          <g class="member-pie__callouts">#{lines.join}</g>
        </svg>
      SVG
    end

    def slice_path(start, sweep, colour)
      if sweep >= 2 * Math::PI - 1e-6
        return %(<circle cx="#{f @cx}" cy="#{f @cy}" r="#{f @l[:r]}" fill="#{colour}"/>)
      end
      x1 = @cx + @l[:r] * Math.cos(start)
      y1 = @cy + @l[:r] * Math.sin(start)
      x2 = @cx + @l[:r] * Math.cos(start + sweep)
      y2 = @cy + @l[:r] * Math.sin(start + sweep)
      large = sweep > Math::PI ? 1 : 0
      %(<path d="M#{f @cx},#{f @cy} L#{f x1},#{f y1} A#{f @l[:r]},#{f @l[:r]} 0 #{large} 1 #{f x2},#{f y2} Z" fill="#{colour}" stroke="#{SURFACE}" stroke-width="2" stroke-linejoin="round"/>)
    end

    # Space for a label's text, which sits above its leader line.
    def label_height(c)
      c[:lines].size * @l[:line_height] + @l[:label_pad]
    end

    # Keep labels on one side from overlapping, inside the canvas.
    def spread(side)
      side.sort_by! { |c| c[:y] }
      side.each_cons(2) do |a, b|
        min = a[:y] + label_height(b)
        b[:y] = min if b[:y] < min
      end
      overflow = side.empty? ? 0 : side.last[:y] - (@l[:height] - @l[:margin])
      side.each { |c| c[:y] -= overflow } if overflow.positive?
      floor = @l[:margin]
      side.each do |c|
        c[:y] = [c[:y], floor + label_height(c)].max
        floor = c[:y]
      end
    end

    # Break a label into short lines so it fits beside the pie.
    def wrap(label)
      label.split.each_with_object([]) do |word, lines|
        if lines.empty? || (lines.last + " " + word).length > @l[:wrap]
          lines << word
        else
          lines[-1] = lines.last + " " + word
        end
      end
    end

    def callout(c)
      ax = @cx + (@l[:r] - @l[:inset]) * Math.cos(c[:mid])
      ay = @cy + (@l[:r] - @l[:inset]) * Math.sin(c[:mid])
      ex = @cx + (@l[:r] + @l[:elbow]) * Math.cos(c[:mid])
      ey = c[:y]
      right = c[:side] == :right
      end_x = right ? @l[:width] - @l[:margin] : @l[:margin]
      anchor = right ? "end" : "start"
      <<~G.delete("\n")
        <g class="member-pie__callout">
        <polyline points="#{f ax},#{f ay} #{f ex},#{f ey} #{f end_x},#{f ey}" fill="none" stroke="#{LINE}" stroke-width="1"/>
        <circle cx="#{f ax}" cy="#{f ay}" r="3.5" fill="#{SURFACE}" stroke="#e5e4e2" stroke-width="1.5"/>
        <text x="#{f end_x}" y="#{f(ey - @l[:baseline] - (c[:lines].size - 1) * @l[:line_height])}" text-anchor="#{anchor}">#{tspans(c[:lines], end_x)}</text>
        </g>
      G
    end

    def tspans(lines, x)
      lines.each_with_index.map do |line, i|
        %(<tspan x="#{f x}"#{i.zero? ? "" : %( dy="#{f @l[:line_height]}")}>#{h line}</tspan>)
      end.join
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
