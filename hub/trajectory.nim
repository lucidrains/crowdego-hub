import std/math
import nimpy

proc pathLength(points: seq[seq[float]]): float {.exportpy: "path_length".} =
  for i in 1 ..< points.len:
    var sumSq = 0.0
    for j in 0 ..< points[i].len:
      let delta = points[i][j] - points[i - 1][j]
      sumSq += delta * delta
    result += sqrt(sumSq)
