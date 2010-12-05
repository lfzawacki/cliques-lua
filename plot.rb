require 'rubygems'
require 'glapp'
require 'pp'

data = IO.read(ARGV[0]).split("\n")
$groups = {}
current = nil

$x = 0
$y = 0

data.each do |l|

  l = l.split(';')

  if l[0] == '__g'
    current = l[1]
    $groups[current] = []
  elsif current
    $groups[current] << [l[0],l[1].to_f]
    if l[1].to_f > $y
      $y = l[1].to_f
    end

    $x += 1
  end
end

$colors = (0..30).each.map { |i| [(i%2)*0.5 + rand(0)*0.5,rand(0)*0.8 + 0.2,rand(0)*0.8 + 0.2] }


class CliquesPlot
  include GLApp
  def draw
    glClearColor(0.0, 0, 0, 1.0)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity

    glPointSize(10)
    glTranslatef(-1,-1,0)
    glScalef(1.0/$x,1.0/$y,0)

    colori = 0
    i = 0
    $groups.each do |k,values|

      glColor3fv($colors[colori])
      colori += 1

      glBegin GL_POINTS
        values.each do |v|
          i += 1
          glVertex2d(i*1.8,v[1]*1.8)
        end

      glEnd
    end

  end
end

CliquesPlot.new.show 800, 600, "Cliques Plot"

