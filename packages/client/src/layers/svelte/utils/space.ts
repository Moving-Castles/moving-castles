import type { Coord } from "@latticexyz/utils";

/**
 * @param a Coordinate A
 * @param b Coordinate B
 * @returns Manhattan distance from A to B (https://xlinux.nist.gov/dads/HTML/manhattanDistance.html)
 */
export function manhattan(a: Coord, b: Coord) {
  return Math.abs(a.x - b.x) + Math.abs(a.y - b.y);
}

/**
 * @param a Coordinate A
 * @param b Coordinate B
 * @returns Chebyshev distance from A to B (https://en.wikipedia.org/wiki/Chebyshev_distance)
 */
export function chebyshev(a: Coord, b: Coord) {
  return a && b ? Math.max(Math.abs(a.x - b.x), Math.abs(a.y - b.y)) : 9999;
}

/**
 * @param from Coordinate to start from (included in the path)
 * @param to Coordinate to go to (included in the path)
 * @returns Finds a path between the from and to coordinates, used in some cases when aStar fails
 */
export function directionalPathfind(from: Coord, to: Coord) {
  const path: Coord[] = [];
  const directionX = from.x < to.x ? 1 : -1;
  const directionY = from.y < to.y ? 1 : -1;

  for (let x = from.x + directionX; directionX * x <= directionX * to.x; x = x + directionX) {
    path.push({ x, y: from.y });
  }

  for (let y = from.y + directionY; directionY * y <= directionY * to.y; y = y + directionY) {
    path.push({ x: to.x, y });
  }

  return path;
}

export const isAdjacent = (from: Coord, to: Coord) => chebyshev(from, to) === 1;