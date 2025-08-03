// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Matter.js 核心类型的外部声明

///| Matter.js Engine type
pub type Engine

///| Matter.js Body type  
pub type Body

///| Matter.js Constraint type
pub type Constraint

///| Matter.js World type
pub type World

///| Matter.js Render type
pub type Render

///| Matter.js Runner type
pub type Runner

///| Matter.js Mouse type
pub type Mouse

///| Matter.js MouseConstraint type
pub type MouseConstraint

///| Position data structure
pub struct Position {
  x: Double
  y: Double
} derive(Show, Eq)

///| Velocity data structure
pub struct Velocity {
  x: Double
  y: Double
} derive(Show, Eq)

///| Body information
pub struct BodyInfo {
  id: Int
  position: Position
  velocity: Velocity
  angle: Double
  angular_velocity: Double
} derive(Show)

///| Render options
pub struct RenderOptions {
  fill_style: String
  stroke_style: String
  line_width: Double
} derive(Show)

///| Body type enumeration
pub enum BodyType {
  Static
  Dynamic
} derive(Show, Eq)

///| Stickman body parts
pub struct StickmanParts {
  head: Body
  torso: Body
  left_upper_arm: Body
  left_lower_arm: Body
  right_upper_arm: Body
  right_lower_arm: Body
  left_thigh: Body
  left_calf: Body
  right_thigh: Body
  right_calf: Body
}

///| Game state
pub struct GameState {
  engine: Engine
  world: World
  render: Render
  runner: Runner
  stickman_parts: StickmanParts
  width: Int
  height: Int
  ground_height: Int
}

///| Control state
pub struct KeyState {
  left: Bool
  right: Bool
  up: Bool
  down: Bool
} derive(Show, Eq)
