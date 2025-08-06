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

// JavaScript FFI 绑定

// 引擎管理
pub extern "js" fn create_engine(gravity_y: Double) -> Engine = "matter_ffi.createEngine"
pub extern "js" fn get_world(engine: Engine) -> World = "matter_ffi.getWorld" 
pub extern "js" fn update_engine(engine: Engine, delta: Double) -> Unit = "matter_ffi.updateEngine"

// 刚体创建
pub extern "js" fn create_rectangle(
  x: Double, y: Double, 
  width: Double, height: Double, 
  is_static: Bool,
  fill_style: String,
  stroke_style: String,
  line_width: Double,
  density: Double
) -> Body = "matter_ffi.createRectangle"

pub extern "js" fn create_circle(
  x: Double, y: Double, 
  radius: Double, 
  is_static: Bool,
  fill_style: String,
  stroke_style: String,
  line_width: Double,
  density: Double
) -> Body = "matter_ffi.createCircle"

// 刚体操作 - 核心物理控制
pub extern "js" fn set_body_position(body: Body, x: Double, y: Double) -> Unit = "matter_ffi.setBodyPosition"
pub extern "js" fn set_body_velocity(body: Body, vx: Double, vy: Double) -> Unit = "matter_ffi.setBodyVelocity"
pub extern "js" fn set_body_angle(body: Body, angle: Double) -> Unit = "matter_ffi.setBodyAngle"
pub extern "js" fn set_angular_velocity(body: Body, velocity: Double) -> Unit = "matter_ffi.setAngularVelocity"
pub extern "js" fn set_torque(body: Body, torque: Double) -> Unit = "matter_ffi.setTorque"
pub extern "js" fn apply_force(body: Body, fx: Double, fy: Double) -> Unit = "matter_ffi.applyForce"
pub extern "js" fn get_body_info(body: Body) -> BodyInfo = "matter_ffi.getBodyInfo"

// 约束创建
pub extern "js" fn create_constraint(
  body_a: Body, body_b: Body,
  point_a_x: Double, point_a_y: Double,
  point_b_x: Double, point_b_y: Double,
  stiffness: Double, length: Double
) -> Constraint = "matter_ffi.createConstraint"

// 世界操作
pub extern "js" fn add_to_world(world: World, body: Body) -> Unit = "matter_ffi.addToWorld"
pub extern "js" fn add_constraint_to_world(world: World, constraint: Constraint) -> Unit = "matter_ffi.addConstraintToWorld"

// 渲染器
pub extern "js" fn create_render(engine: Engine, canvas_id: String, width: Int, height: Int) -> Render = "matter_ffi.createRender"
pub extern "js" fn start_render(render: Render) -> Unit = "matter_ffi.startRender"

// 运行器
pub extern "js" fn create_runner() -> Runner = "matter_ffi.createRunner"
pub extern "js" fn start_runner(runner: Runner, engine: Engine) -> Unit = "matter_ffi.startRunner"

// 鼠标控制
pub extern "js" fn create_mouse(canvas_id: String) -> Mouse = "matter_ffi.createMouse"
pub extern "js" fn create_mouse_constraint(engine: Engine, mouse: Mouse) -> MouseConstraint = "matter_ffi.createMouseConstraint"

// 数学工具函数
pub extern "js" fn math_abs(x: Double) -> Double = "matter_ffi.mathAbs"
pub extern "js" fn math_sign(x: Double) -> Double = "matter_ffi.mathSign"

// 键盘输入
pub extern "js" fn is_key_pressed(key: String) -> Bool = "matter_ffi.isKeyPressed"
pub extern "js" fn setup_input() -> Unit = "matter_ffi.setupInput"

// 重置位置
pub extern "js" fn reset_stickman_position(parts: StickmanParts, x: Double, y: Double) -> Unit = "matter_ffi.resetStickmanPosition"
