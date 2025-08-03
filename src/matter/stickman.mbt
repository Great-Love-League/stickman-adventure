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

// 火柴人游戏高级封装

///| Stickman game controller
pub struct StickmanGame {
  game_state: GameState
  canvas_id: String
  keys: Ref[KeyState]
}

///| Create new stickman game
pub fn StickmanGame::new(canvas_id: String, width: Int, height: Int) -> StickmanGame {
  let engine = create_engine(0.7) // 减小重力
  let world = get_world(engine)
  let render = create_render(engine, canvas_id, width, height)
  let runner = create_runner()
  
  // Create stickman
  let stickman_parts = create_stickman(world, width.to_double() / 2.0, height.to_double() / 2.0)
  
  // Create world objects
  create_world_objects(world, width, height)
  
  let game_state = {
    engine,
    world,
    render,
    runner,
    stickman_parts,
    width,
    height,
    ground_height: 50
  }
  
  let keys = { val: { left: false, right: false, up: false, down: false } }
  
  { game_state, canvas_id, keys }
}

///| Start the game
pub fn start(self: StickmanGame) -> Unit {
  start_render(self.game_state.render)
  start_runner(self.game_state.runner, self.game_state.engine)
  setup_input()
  
  // Add mouse control
  let mouse = create_mouse(self.canvas_id)
  let _mouse_constraint = create_mouse_constraint(self.game_state.engine, mouse)
  
  // Start game loop
  schedule_game_loop(self)
}

///| Create stickman with all body parts and constraints
fn create_stickman(world: World, x: Double, y: Double) -> StickmanParts {
  // Body dimensions
  let head_radius = 15.0
  let torso_width = 20.0
  let torso_height = 40.0
  let arm_width = 8.0
  let arm_length = 25.0
  let leg_width = 10.0
  let leg_length = 30.0
  
  // Create body parts with adjusted densities
  let head = create_circle(
    x, y - 40.0, head_radius, false,
    "#FFD700", "#FFA500", 2.0, 0.0004 // 减小头部密度
  )
  
  let torso = create_rectangle(
    x, y, torso_width, torso_height, false,
    "#FF6B6B", "#FF4757", 2.0, 0.0010 // 增加躯干密度
  )
  
  let left_upper_arm = create_rectangle(
    x - 20.0, y - 10.0, arm_width, arm_length, false,
    "#FF6B6B", "#FF4757", 2.0, 0.0003
  )
  
  let left_lower_arm = create_rectangle(
    x - 25.0, y + 10.0, arm_width, arm_length, false,
    "#FF6B6B", "#FF4757", 2.0, 0.0003
  )
  
  let right_upper_arm = create_rectangle(
    x + 20.0, y - 10.0, arm_width, arm_length, false,
    "#FF6B6B", "#FF4757", 2.0, 0.0003
  )
  
  let right_lower_arm = create_rectangle(
    x + 25.0, y + 10.0, arm_width, arm_length, false,
    "#FF6B6B", "#FF4757", 2.0, 0.0003
  )
  
  let left_thigh = create_rectangle(
    x - 8.0, y + 35.0, leg_width, leg_length, false,
    "#4834D4", "#686DE0", 2.0, 0.0008 // 增加大腿密度
  )
  
  let left_calf = create_rectangle(
    x - 8.0, y + 60.0, leg_width, leg_length, false,
    "#4834D4", "#686DE0", 2.0, 0.0008 // 增加小腿密度
  )
  
  let right_thigh = create_rectangle(
    x + 8.0, y + 35.0, leg_width, leg_length, false,
    "#4834D4", "#686DE0", 2.0, 0.0008 // 增加大腿密度
  )
  
  let right_calf = create_rectangle(
    x + 8.0, y + 60.0, leg_width, leg_length, false,
    "#4834D4", "#686DE0", 2.0, 0.0008 // 增加小腿密度
  )
  
  // Add bodies to world
  add_to_world(world, head)
  add_to_world(world, torso)
  add_to_world(world, left_upper_arm)
  add_to_world(world, left_lower_arm)
  add_to_world(world, right_upper_arm)
  add_to_world(world, right_lower_arm)
  add_to_world(world, left_thigh)
  add_to_world(world, left_calf)
  add_to_world(world, right_thigh)
  add_to_world(world, right_calf)
  
  // Create constraints (joints)
  create_stickman_constraints(world, {
    head, torso, left_upper_arm, left_lower_arm,
    right_upper_arm, right_lower_arm, left_thigh,
    left_calf, right_thigh, right_calf
  })
  
  {
    head, torso, left_upper_arm, left_lower_arm,
    right_upper_arm, right_lower_arm, left_thigh,
    left_calf, right_thigh, right_calf
  }
}

///| Create all constraints for stickman joints
fn create_stickman_constraints(world: World, parts: StickmanParts) -> Unit {
  let stiffness = 0.95
  
  // Neck constraint
  let neck = create_constraint(
    parts.head, parts.torso, 0.0, 12.0, 0.0, -18.0, 0.98, 3.0
  )
  add_constraint_to_world(world, neck)
  
  // Left shoulder
  let left_shoulder = create_constraint(
    parts.torso, parts.left_upper_arm, -8.0, -12.0, 0.0, -10.0, 0.9, 6.0
  )
  add_constraint_to_world(world, left_shoulder)
  
  // Left elbow
  let left_elbow = create_constraint(
    parts.left_upper_arm, parts.left_lower_arm, 0.0, 12.0, 0.0, -12.0, stiffness, 4.0
  )
  add_constraint_to_world(world, left_elbow)
  
  // Right shoulder
  let right_shoulder = create_constraint(
    parts.torso, parts.right_upper_arm, 8.0, -12.0, 0.0, -10.0, 0.9, 6.0
  )
  add_constraint_to_world(world, right_shoulder)
  
  // Right elbow
  let right_elbow = create_constraint(
    parts.right_upper_arm, parts.right_lower_arm, 0.0, 12.0, 0.0, -12.0, stiffness, 4.0
  )
  add_constraint_to_world(world, right_elbow)
  
  // Left hip - 增强髋部约束
  let left_hip = create_constraint(
    parts.torso, parts.left_thigh, -6.0, 18.0, 0.0, -13.0, 0.98, 8.0
  )
  add_constraint_to_world(world, left_hip)
  
  // Left knee - 增强膝部约束
  let left_knee = create_constraint(
    parts.left_thigh, parts.left_calf, 0.0, 15.0, 0.0, -15.0, 0.98, 8.0
  )
  add_constraint_to_world(world, left_knee)
  
  // Right hip - 增强髋部约束
  let right_hip = create_constraint(
    parts.torso, parts.right_thigh, 6.0, 18.0, 0.0, -13.0, 0.98, 8.0
  )
  add_constraint_to_world(world, right_hip)
  
  // Right knee - 增强膝部约束
  let right_knee = create_constraint(
    parts.right_thigh, parts.right_calf, 0.0, 15.0, 0.0, -15.0, 0.98, 8.0
  )
  add_constraint_to_world(world, right_knee)
}

///| Create world objects (ground, walls, platforms)
fn create_world_objects(world: World, width: Int, height: Int) -> Unit {
  let ground_height = 50
  
  // Ground
  let ground = create_rectangle(
    width.to_double() / 2.0, height.to_double() - ground_height.to_double() / 2.0,
    width.to_double(), ground_height.to_double(), true,
    "#8B4513", "#654321", 2.0, 1.0
  )
  add_to_world(world, ground)
  
  // Left wall
  let left_wall = create_rectangle(
    15.0, height.to_double() / 2.0, 30.0, height.to_double(), true,
    "#696969", "#555555", 2.0, 1.0
  )
  add_to_world(world, left_wall)
  
  // Right wall
  let right_wall = create_rectangle(
    width.to_double() - 15.0, height.to_double() / 2.0, 30.0, height.to_double(), true,
    "#696969", "#555555", 2.0, 1.0
  )
  add_to_world(world, right_wall)
  
  // Platform 1
  let platform1 = create_rectangle(
    200.0, height.to_double() - 150.0, 200.0, 20.0, true,
    "#228B22", "#32CD32", 2.0, 1.0
  )
  add_to_world(world, platform1)
  
  // Platform 2
  let platform2 = create_rectangle(
    600.0, height.to_double() - 200.0, 150.0, 20.0, true,
    "#228B22", "#32CD32", 2.0, 1.0
  )
  add_to_world(world, platform2)
  
  // Platform 3
  let platform3 = create_rectangle(
    800.0, height.to_double() - 100.0, 100.0, 20.0, true,
    "#228B22", "#32CD32", 2.0, 1.0
  )
  add_to_world(world, platform3)
}

///| Game loop function
fn schedule_game_loop(game: StickmanGame) -> Unit {
  @external.schedule_with_fixed_interval(1000 / 60, () => {
    update_controls(game)
    update_engine(game.game_state.engine, 16.0)
  }) |> ignore
}

///| Update controls based on input
fn update_controls(game: StickmanGame) -> Unit {
  let force_strength = 0.006  // 调整控制力度
  let jump_force = -0.018     // 调整跳跃力度
  let upright_force = -0.001  // 减小持续升力
  
  // Get current key states
  let left_pressed = is_key_pressed("ArrowLeft") || is_key_pressed("KeyA")
  let right_pressed = is_key_pressed("ArrowRight") || is_key_pressed("KeyD")
  let up_pressed = is_key_pressed("ArrowUp") || is_key_pressed("KeyW") || is_key_pressed("Space")
  let down_pressed = is_key_pressed("ArrowDown") || is_key_pressed("KeyS")
  let reset_pressed = is_key_pressed("KeyR")
  
  // Update key state
  game.keys.val = { left: left_pressed, right: right_pressed, up: up_pressed, down: down_pressed }
  
  // 持续给上半身一点升力来保持直立
  apply_force(game.game_state.stickman_parts.torso, 0.0, upright_force)
  apply_force(game.game_state.stickman_parts.head, 0.0, upright_force * 0.3)
  
  // Apply forces based on input
  if left_pressed {
    apply_force(game.game_state.stickman_parts.torso, -force_strength, 0.0)
  }
  
  if right_pressed {
    apply_force(game.game_state.stickman_parts.torso, force_strength, 0.0)
  }
  
  if up_pressed {
    apply_force(game.game_state.stickman_parts.torso, 0.0, jump_force)
    // 给腿部额外的跳跃力
    apply_force(game.game_state.stickman_parts.left_thigh, 0.0, jump_force * 0.2)
    apply_force(game.game_state.stickman_parts.right_thigh, 0.0, jump_force * 0.2)
  }
  
  if down_pressed {
    apply_force(game.game_state.stickman_parts.torso, 0.0, force_strength)
  }
  
  if reset_pressed {
    reset_stickman_position(
      game.game_state.stickman_parts,
      game.game_state.width.to_double() / 2.0,
      game.game_state.height.to_double() / 2.0
    )
  }
}

///| Get current key state
pub fn get_key_state(game: StickmanGame) -> KeyState {
  game.keys.val
}

///| Get stickman torso position
pub fn get_stickman_position(game: StickmanGame) -> Position {
  let info = get_body_info(game.game_state.stickman_parts.torso)
  info.position
}

///| Get stickman torso velocity  
pub fn get_stickman_velocity(game: StickmanGame) -> Velocity {
  let info = get_body_info(game.game_state.stickman_parts.torso)
  info.velocity
}
