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

///|
fn main {
  // 创建火柴人游戏
  let game = @matter.StickmanGame::new("gameCanvas", 1000, 600)
  
  // 启动游戏
  @matter.StickmanGame::start(game)
  
  // 显示状态信息
  @external.schedule_with_fixed_interval(1000.0 / 10.0, () => {
    let position = @matter.get_stickman_position(game)
    let velocity = @matter.get_stickman_velocity(game)
    
    // 更新位置显示
    let pos_element = @dom.document()
      .get_element_by_id("position")
    if pos_element.is_null() == false {
      let element = pos_element.unwrap()
      let pos_text = "位置: (" + position.x.to_string() + ", " + position.y.to_string() + ")"
      element.set_inner_html(pos_text)
    }
    
    // 更新速度显示
    let vel_element = @dom.document()
      .get_element_by_id("velocity") 
    if vel_element.is_null() == false {
      let element = vel_element.unwrap()
      let vel_text = "速度: (" + velocity.x.to_string() + ", " + velocity.y.to_string() + ")"
      element.set_inner_html(vel_text)
    }
  })
  |> ignore
}
