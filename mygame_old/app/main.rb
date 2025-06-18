$gtk.disable_controller_config = true  # Disable the controller config prompt

def tick(args)
  setup(args) if args.tick_count == 0

  read_vjoy_inputs(args)
  update_square_position(args)
  render_game(args)
end

# Initial setup
def setup(args)
  args.state.square = { x: 640, y: 360, size: 50, color: [255, 0, 0] } # Red square
  args.state.move_speed = 5
  args.outputs.labels << [640, 700, "Testing vJoy Input", 5, 1]
end

# Read vJoy inputs
def read_vjoy_inputs(args)
  inputs = args.inputs.controller_one
  if inputs
    args.state.vjoy_x = inputs.left_analog_x_raw || 0
    args.state.vjoy_y = inputs.left_analog_y_raw || 0
  else
    args.state.vjoy_x = 0
    args.state.vjoy_y = 0
  end
end

# Update the square's position based on vJoy inputs
def update_square_position(args)
  move_speed = args.state.move_speed

  # Adjust position based on vJoy inputs
  args.state.square[:x] += (args.state.vjoy_x * move_speed).to_i
  args.state.square[:y] += (args.state.vjoy_y * move_speed).to_i

  # Keep the square within bounds
  args.state.square[:x] = args.state.square[:x].clamp(0, 1280 - args.state.square[:size])
  args.state.square[:y] = args.state.square[:y].clamp(0, 720 - args.state.square[:size])
end

# Render the game
def render_game(args)
  square = args.state.square
  args.outputs.solids << [
    square[:x], square[:y], square[:size], square[:size], *square[:color]
  ]

  args.outputs.labels << [
    10, 700, "vJoy X: #{args.state.vjoy_x.round(2)} | vJoy Y: #{args.state.vjoy_y.round(2)}", 3, 0
  ]
end
