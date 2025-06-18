# Calls methods needed for game to run properly
def tick args
  game_reset args
  defaults args
  render args
  calc args
end

# w: 200, h: 100
# new_button id, x, y, w, h, r, g, b

# sets default values and creates empty collections
# initialization only happens in the first frame
def defaults args
  consts args
  invisBox args
  args.state.tick_count         = args.state.tick_count
  args.state.start_button     ||= new_button :start, 452, 328, 175, 100, 169, 169, 169
  args.state.tutorial_button  ||= new_button :tutorial, 675, 328, 175, 100, 169, 169, 169
  args.state.reset_button     ||= new_button :reset, 552, 240, 200, 100, 169, 169, 169
  args.state.back_button      ||= new_button :back, 552, 240, 200, 100, 169, 169, 169
  args.state.points           ||= 0
  args.state.game_over_at     ||= 0
  args.state.spawn.fishs      ||= []
  args.state.spawn.fish_queue ||= []
  args.state.spawn.x  ||= 1279  # initializes spawning properties
  args.state.spawn.y  ||= 250
  args.state.spawn.w  ||= 128
  args.state.spawn.h  ||= 128
  args.state.spawn.dy ||= 0
  args.state.spawn.dx ||= 0
  args.state.player.x ||= 235   # initialize player
  args.state.player.y ||= args.state.ocean_top - 10
  args.state.player.w   = 30
  args.state.player.h   = 30
  args.state.player.path    = '/sprites/isometric/red.png'
  args.state.player.angle   = 90
  args.state.player.dx ||= []
  args.state.player.dy ||= []
  args.state.fish_collision     ||= false   # collisions
  args.state.botBoat_collide    ||= false
  args.state.lSideBoat_collide  ||= false
  args.state.rSideBoat_collide  ||= false
  args.state.checkStart         ||= -10       # start conditions
  args.state.checkTutorial      ||= -10       # tutorial check
  args.state.tutorialTick       ||= 1
  args.state.renderStrtTick     ||= 0
  args.state.startTick          ||= 0
  args.state.start_event_occurred = false
  args.state.countdown          ||= args.state.game_stop
  args.state.countstart         ||= args.state.game_start

end

# sets constant state values
def consts args
  args.state.spawn_jump_power           = 10       # sets spawn values
  args.state.spawn_jump_interval        = 60
  args.state.fish_throw_interval        = 175      # sets fish values      # will set to 50 for fish flurry
  args.state.fish_launch_power_default  = 2
  args.state.fish_upward_launch_power   = 3
  args.state.max_fishs_per_swim         = 2   # will set to 5 for fish flurry when implementing that feature
  args.state.gap_between_fishs          = 50
  args.state.fish_size                  = 50
  args.state.ocean_top                  = 500     # set background values
  args.state.boat         = [10, args.state.ocean_top - 15, 200, 65, 161, 122, 116]   # set boat values
  args.state.white_box[:primitives] = {x: 400, y: 200, w: 500, h: 500, r: 255, g: 255, b: 255}.solid!
  args.state.game_stop    = 60 * 60
  args.state.game_start   = 60 * 3



end

# set invisible collision boxes
def invisBox args
  args.state.botBoat      = [10, args.state.ocean_top - 15, 200, 10]   # boat collision
  args.state.lSideBoat    = [10, args.state.ocean_top - 15, 10, 65]
  args.state.rSideBoat    = [190, args.state.ocean_top - 15, 10, 65]

end



# outputs objects onto the screen
def render args
  renderInvis args
  renderBackground args
  if args.state.checkTutorial < 0 && args.state.checkStart < 0
    renderStart args
  elsif args.state.checkTutorial > 0 && args.state.checkStart < 0
    renderTutorial args
  else args.state.checkStart > 0
  renderGameplay args
  if args.state.tick_count > (args.state.startTick + args.state.game_start + args.state.game_stop)
      renderRestart args
    end
  end

end


# output invisible collisions
def renderInvis args
  args.outputs.solids << [args.state.botBoat, 0, 0, 0, 0]
  args.outputs.solids << [args.state.lSideBoat, 0, 0, 0, 0]
  args.outputs.solids << [args.state.rSideBoat, 0, 0, 0, 0]

end

def renderBackground args
  args.outputs.solids << [0, 0, 1282, args.state.ocean_top + 5, 0, 213, 255]
  args.outputs.solids << [0,args.state.ocean_top, 1282, 730, 204, 238, 255]
  args.outputs.solids << [1190, 620, 70, 70, 250, 250, 174]
  args.outputs.solids << args.state.boat
end


def renderStart args
  args.state.renderStrtTick = args.state.tick_count
  args.outputs.lines  << [180, args.state.ocean_top + 50, 250, 650]
  args.outputs.lines << [250, 650, 235 + 15, args.state.ocean_top - 10 + 15]
  args.outputs.sprites << [235, args.state.ocean_top - 10, 30, 30, '/sprites/isometric/red.png', 90]
  args.outputs.primitives << args.state.white_box[:primitives]
  args.outputs.labels << [800, 600, "FISH GAME", 48, 2, 0, 0, 0, 255, "/fonts/Latruiteapapa-1RBg.ttf"]

  if args.state.renderStrtTick >= args.state.tutorialTick + 50
    args.outputs.primitives << args.state.start_button[:primitives]
    args.outputs.labels << [490, 405, 'START', 28, 0, 0, 0, 0, 255, "/fonts/Latruiteapapa-1RBg.ttf"]
    args.outputs.primitives << args.state.tutorial_button[:primitives]
    args.outputs.labels << [687, 405, 'TUTORIAL', 28, 0, 0, 0, 0, 255, "/fonts/Latruiteapapa-1RBg.ttf"]

  end

  if  button_clicked? args, args.state.start_button
    args.state.checkStart = 1
    args.state.startTick = args.state.tick_count
    args.state.start_event_occurred = true
  end

  if  button_clicked? args, args.state.tutorial_button
    args.state.checkTutorial = 1
  end

end

def renderTutorial args
  args.outputs.lines  << [180, args.state.ocean_top + 50, 250, 650]
  args.outputs.lines << [250, 650, 235 + 15, args.state.ocean_top - 10 + 15]
  args.outputs.sprites << [235, args.state.ocean_top - 10, 30, 30, '/sprites/isometric/red.png', 90]
  args.outputs.primitives << args.state.white_box[:primitives]
  args.outputs.labels << [735, 650, "TUTORIAL", 36, 2, 0, 0, 0, 255, "/fonts/Latruiteapapa-1RBg.ttf"]
  args.outputs.labels << [427, 520, "Use WASD or the Arrow Keys to move the bobber"]
  args.outputs.labels << [413, 465, "Use the bobber to pet the fish, turning them red"]
  args.outputs.labels << [413, 409, "Points are awarded for how long you pet the fish"]

  args.outputs.primitives << args.state.back_button[:primitives]
  args.outputs.labels << [610, 320, "BACK", 32, 0, 0, 0, 0, 255, "/fonts/Latruiteapapa-1RBg.ttf"]

  if  button_clicked? args, args.state.back_button
    args.state.checkTutorial = -10
    args.state.checkStart = -10
    args.state.tutorialTick = args.state.tick_count
  end

end

# output gameplay values
def renderGameplay args
# background
  args.outputs.solids << [0, 0, 1282, args.state.ocean_top + 5, 0, 213, 255]
  args.outputs.solids << [0,args.state.ocean_top, 1282, 730, 204, 238, 255]
  args.outputs.solids << args.state.boat
  args.outputs.solids << [1190, 620, 70, 70, 250, 250, 174]
  # fishing rod
  args.outputs.lines  << [180, args.state.ocean_top + 50, 250, 650]
  # fishing line
  args.outputs.lines << [250, 650, args.state.player.x + 15,args.state.player.y + 15]
  # player
  args.outputs.sprites << args.state.player
  # spawn solid
  args.outputs.solids << [args.state.spawn.x, args.state.spawn.y, args.state.spawn.w, args.state.spawn.h, 0, 0, 0,0] # outputs spawn onto screen (invis box)
  # fish
  args.outputs.sprites << args.state.spawn.fishs # outputs spawn's fishs onto screen
  # game start timer
  if args.state.tick_count < (args.state.startTick + args.state.game_start)
    args.state.countstart -= 1
    args.outputs.labels << [580, 650, "#{(args.state.countstart.idiv 60) + 1}", 20]
  end
  if args.state.tick_count < (args.state.startTick + args.state.game_start + args.state.game_stop) && args.state.tick_count > (args.state.startTick + args.state.game_start)
    args.state.countdown -= 1
    args.outputs.labels << [580, 650, "Points: #{(args.state.points)}"]
    args.outputs.labels << [580, 600, "Time Left: #{(args.state.countdown.idiv 60 + 1)}"]
  end

  if (args.state.countdown.idiv 60 + 1) == 6
    args.audio[:FiveTimer] = {
      input: '/sounds/Cool Countdown 5,4,3,2,1 mit Sound.ogg',
      looping: false
    }
  end


end


def renderRestart args
  # game end & restart
  args.state.countdown = 0
  args.outputs.primitives << args.state.white_box[:primitives]
  args.outputs.labels << [565, 600, "TIME UP!", 32, 0, 0, 0, 0, 255, "/fonts/Latruiteapapa-1RBg.ttf"]
  args.outputs.labels << [635, 450, ["Final Score: ", args.state.points].join(""), 2, 1]
  args.outputs.primitives << args.state.reset_button[:primitives]
  args.outputs.labels << [600, 315, 'RESET?', 24, 0, 0, 0, 0, 255, "/fonts/Latruiteapapa-1RBg.ttf"]
  game_reset args


end



# Performs calculations to move objects on the screen
def calc args
  args.state.player.rect = [args.state.player.x, args.state.player.y, args.state.player.size, args.state.player.size]
  fish_movement args
  player_movement args
  

end



def player_movement args
  # playscreen res : 1280x720
  screen_width  = 1280
  screen_height = 720

  if args.inputs.left           # x-movement
    args.state.player.dx = -4
  elsif args.inputs.right
    args.state.player.dx = 4
  else
    args.state.player.dx = 0
  end
  if args.inputs.down           # y-movement
    args.state.player.dy = -4
  elsif args.inputs.up
    args.state.player.dy = 4
  else
    args.state.player.dy = 0
  end

  # Keep player sprite within game window
  # x-movement
  if args.state.player.x + args.state.player.dx > screen_width - args.state.player.w
    args.state.player.dx = 0
  elsif args.state.player.x + args.state.player.dx < 0
    args.state.player.dx =  0
  end
  # y-movement
  if args.state.player.y + args.state.player.dy > 720# args.state.ocean_top
    args.state.player.dy = 0
  elsif args.state.player.y + args.state.player.dy < 0
    args.state.player.dy =  0
  end
  # boat collision
  if args.state.boat.intersect_rect? args.state.player.rect
    reset_player args
  end

  args.state.player.x += args.state.player.dx;
  args.state.player.y += args.state.player.dy;
  
end


def fish_movement args
  #sets definition of spawn
  args.state.spawn.rect = [args.state.spawn.x, args.state.spawn.y, args.state.spawn.h, args.state.spawn.w]


  if args.state.tick_count.mod_zero?(args.state.fish_throw_interval)
    r = rand(2) + 1

    swim_dx = (rand(args.state.fish_launch_power_default) + r)

    if rand(2) == 1
      swim_dx   = -swim_dx # horizontal movement (follow order of operations)
      start_x = 1280
    else
      start_x = 0
    end

    start_y = rand(args.state.ocean_top - args.state.fish_size - 10) + 1

    (rand(args.state.max_fishs_per_swim) + 1).map_with_index do |i|
      args.state.spawn.fish_queue << { # stores fish values in a hash
        x: start_x,
        y: start_y,
        w: args.state.fish_size,
        h: args.state.fish_size,
        dx: swim_dx, # change in horizontal position
        # multiplication operator takes precedence over addition operator
        throw_at: args.state.tick_count + i * args.state.gap_between_fishs
      }
    end
  end

  # add elements from fish_queue collection to the fishs collection by
  # finding all fishs that were thrown before the current frame (have already been thrown)
  args.state.spawn.fishs += args.state.spawn.fish_queue.find_all do |h|
    h[:throw_at] < args.state.tick_count
  end

  args.state.spawn.fishs.each do |h| # sets values for all fishs in collection
    h[:rect] = [h[:x], h[:y], h[:w], h[:h]] # sets definition of fish's rect
    h[:dy] ||= args.state.fish_upward_launch_power
    if h[:y] + h[:dy] > args.state.ocean_top - args.state.fish_size
      h[:dy] = h[:dy] * -1
    elsif h[:y] + h[:dy] < -1.5 * h[:w]
      h[:dy] = h[:dy] * -1
    elsif args.state.botBoat.intersect_rect? h[:rect]
      h[:dy] = h[:dy] * -1
    end
    h[:x]   += h[:dx] # incremented by change in position
    h[:y]   += h[:dy]
    if args.state.player.intersect_rect? h[:rect]
      h[:path] = '/sprites/misc/lowrez-ship-red.png'
      if args.state.tick_count < (args.state.startTick + args.state.game_start + args.state.game_stop) && args.state.tick_count > (args.state.startTick + args.state.game_start)
        args.state.points += 1 
      
      end

    else
      h[:path] = '/sprites/misc/lowrez-ship-blue.png'
    end

    
    if h[:dx] > 0
      h[:angle] = 270
    else
      h[:angle] = 90
    end
  end

  # reject fishs that have been thrown before current frame (have already been thrown)
  args.state.spawn.fish_queue = args.state.spawn.fish_queue.reject do |h|
    h[:throw_at] < args.state.tick_count
  end

  args.state.spawn.fish_queue = args.state.spawn.fish_queue.reject { |fish| fish.x > 1290 }


end



def reset_player args   
  args.state.player.x = 235
  args.state.player.y = args.state.ocean_top - 10
  args.state.player.dy = 0
  args.state.player.dx = 0

end


def new_button id, x, y, w, h, r, g, b
  # create a hash ("entity") that has some metadata
  # about what it represents
  entity = {
    id: id,
    rect: { x: x, y: y, w: w, h: h }
  }

  # for that entity, define the primitives 
  # that form it
  entity[:primitives] = [
    { x: x, y: y, w: w, h: h ,r: r, g: g, b: b}.solid!,
  ]
    
  entity
end

# helper method for determining if a button was clicked
def button_clicked? args, button
  return false unless args.inputs.mouse.click
  return args.inputs.mouse.point.inside_rect? button[:rect]
end


def game_reset args
  if  button_clicked? args, args.state.reset_button 
    # || args.inputs.keyboard.key_down.r    <<<< THis is not working for some reason
    $gtk.reset
  end
end

