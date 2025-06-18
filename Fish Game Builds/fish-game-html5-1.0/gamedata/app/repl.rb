# def: define a function
# tick: length of time, 60 ticks = 60 frames
# args: allows for movement of values across functions
def tick args
  # args has a bunch of different things it can do
  # .outputs: allows for certain outputs
  # .outputs.labels: exports a label
    # [xpos, ypos, "Message", fontsize, position[L,C,R], C, M, Y, K]
    # origin of screen is the bottom L corner
    # this is either cmyk or rgbk

  args.outputs.labels << [80, 60, "Hello World",5 ,3 , 200, 010, 100, 225]

end