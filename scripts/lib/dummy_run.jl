#####
##### Dummy runs are used to ensure the absence of runtime errors in the code
##### before launching a training session
#####

# Returned modified parameters where all num_games fields are set to 1.
# The number of iterations is set to 2.
function dummy_run_params(params, benchmark)
  self_play = SelfPlayParams(params.self_play, num_games=1)
  arena = ArenaParams(params.arena, num_games=1)
  learning = LearningParams(params.learning,
    max_batches_per_checkpoint=2,
    num_checkpoints=min(params.learning.num_checkpoints, 2))
  params = Params(params, num_iters=2,
    self_play=self_play, arena=arena, learning=learning)
  benchmark = [
    Benchmark.Duel(d.player, d.baseline,
      num_games=1, color_policy=d.color_policy)
    for d in benchmark ]
  return params, benchmark
end

function dummy_run(GameModule)
  Game = GameModule.Game
  Training = GameModule.Training
  Net = Training.Network
  netparams = Training.netparams
  params, benchmark = dummy_run_params(Training.params, Training.benchmark)
  session = Session(Game, Net{Game}, params, netparams,
    benchmark=benchmark, nostdout=true)
  resume!(session)
  return true
end
