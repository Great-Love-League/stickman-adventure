// Matter.js FFI implementation for MoonBit
// 导入 Matter.js
const { Engine, Bodies, Body, Constraint, Composite, Render, Runner, Mouse, MouseConstraint } = Matter;

// 全局状态管理
let bodyIdCounter = 0;
const bodyMap = new Map();
const keyStates = {};

// 键盘事件监听
function initializeKeyboardListeners() {
  // 防止重复添加监听器
  if (window.keyboardListenersInitialized) {
    return;
  }
  window.keyboardListenersInitialized = true;
  console.log("Initializing keyboard listeners...");

  document.addEventListener('keydown', (event) => {
    console.log(`Key down: ${event.code}`);
    keyStates[event.code] = true;
  });
  
  document.addEventListener('keyup', (event) => {
    console.log(`Key up: ${event.code}`);
    keyStates[event.code] = false;
  });
}

const matter_ffi = {
  // 引擎管理
  createEngine(gravityY) {
    const engine = Engine.create();
    if (typeof gravityY === 'number') {
      engine.world.gravity.y = gravityY;
    }
    return engine;
  },

  getWorld(engine) {
    return engine.world;
  },

  updateEngine(engine, delta) {
    Engine.update(engine, delta);
  },

  // 刚体创建
  createRectangle(x, y, width, height, isStatic, fillStyle, strokeStyle, lineWidth, density) {
    const body = Bodies.rectangle(x, y, width, height, {
      isStatic: isStatic,
      render: {
        fillStyle: fillStyle,
        strokeStyle: strokeStyle,
        lineWidth: lineWidth
      },
      density: density,
      collisionFilter: isStatic ? {} : { group: -1 }
    });
    
    const id = ++bodyIdCounter;
    bodyMap.set(id, body);
    body._moonbit_id = id;
    return body;
  },

  createCircle(x, y, radius, isStatic, fillStyle, strokeStyle, lineWidth, density) {
    const body = Bodies.circle(x, y, radius, {
      isStatic: isStatic,
      render: {
        fillStyle: fillStyle,
        strokeStyle: strokeStyle,
        lineWidth: lineWidth
      },
      density: density,
      collisionFilter: isStatic ? {} : { group: -1 }
    });
    
    const id = ++bodyIdCounter;
    bodyMap.set(id, body);
    body._moonbit_id = id;
    return body;
  },

  // 刚体操作
  setBodyPosition(body, x, y) {
    Body.setPosition(body, { x, y });
  },

  setBodyVelocity(body, vx, vy) {
    Body.setVelocity(body, { x: vx, y: vy });
  },

  setBodyAngle(body, angle) {
    Body.setAngle(body, angle);
  },

  setAngularVelocity(body, velocity) {
    Body.setAngularVelocity(body, velocity);
  },

  setTorque(body, torque) {
    body.torque = torque;
  },

  applyForce(body, fx, fy) {
    Body.applyForce(body, body.position, { x: fx, y: fy });
  },

  getBodyInfo(body) {
    return {
      id: body._moonbit_id || 0,
      position: { x: body.position.x, y: body.position.y },
      velocity: { x: body.velocity.x, y: body.velocity.y },
      angle: body.angle,
      angular_velocity: body.angularVelocity
    };
  },

  // 约束创建
  createConstraint(bodyA, bodyB, pointAx, pointAy, pointBx, pointBy, stiffness, length) {
    return Constraint.create({
      bodyA: bodyA,
      bodyB: bodyB,
      pointA: { x: pointAx, y: pointAy },
      pointB: { x: pointBx, y: pointBy },
      stiffness: stiffness,
      length: length
    });
  },

  // 世界操作
  addToWorld(world, body) {
    Composite.add(world, body);
  },

  addConstraintToWorld(world, constraint) {
    Composite.add(world, constraint);
  },

  // 渲染器
  createRender(engine, canvasId, width, height) {
    const canvas = document.getElementById(canvasId);
    return Render.create({
      canvas: canvas,
      engine: engine,
      options: {
        width: width,
        height: height,
        wireframes: false,
        background: '#87CEEB',
        showAngleIndicator: false,
        showVelocity: false
      }
    });
  },

  startRender(render) {
    Render.run(render);
  },

  // 运行器
  createRunner() {
    return Runner.create();
  },

  startRunner(runner, engine) {
    Runner.run(runner, engine);
  },

  // 鼠标控制
  createMouse(canvasId) {
    const canvas = document.getElementById(canvasId);
    return Mouse.create(canvas);
  },

  createMouseConstraint(engine, mouse) {
    const mouseConstraint = MouseConstraint.create(engine, {
      mouse: mouse,
      constraint: {
        stiffness: 0.2,
        render: {
          visible: false
        }
      }
    });
    
    // Add mouse constraint to world automatically
    Composite.add(engine.world, mouseConstraint);
    return mouseConstraint;
  },

  // 数学工具函数
  mathAbs(x) {
    return Math.abs(x);
  },

  mathSign(x) {
    return Math.sign(x);
  },

  // 键盘输入
  isKeyPressed(key) {
    return !!keyStates[key];
  },

  setupInput() {
    initializeKeyboardListeners();
  },

  // 重置火柴人位置
  resetStickmanPosition(parts, x, y) {
    // Reset head
    Body.setPosition(parts.head, { x: x, y: y - 40 });
    Body.setVelocity(parts.head, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.head, 0);
    
    // Reset torso
    Body.setPosition(parts.torso, { x: x, y: y });
    Body.setVelocity(parts.torso, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.torso, 0);
    
    // Reset arms
    Body.setPosition(parts.left_upper_arm, { x: x - 20, y: y - 10 });
    Body.setVelocity(parts.left_upper_arm, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.left_upper_arm, 0);
    
    Body.setPosition(parts.left_lower_arm, { x: x - 25, y: y + 10 });
    Body.setVelocity(parts.left_lower_arm, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.left_lower_arm, 0);
    
    Body.setPosition(parts.right_upper_arm, { x: x + 20, y: y - 10 });
    Body.setVelocity(parts.right_upper_arm, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.right_upper_arm, 0);
    
    Body.setPosition(parts.right_lower_arm, { x: x + 25, y: y + 10 });
    Body.setVelocity(parts.right_lower_arm, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.right_lower_arm, 0);
    
    // Reset legs
    Body.setPosition(parts.left_thigh, { x: x - 8, y: y + 35 });
    Body.setVelocity(parts.left_thigh, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.left_thigh, 0);
    
    Body.setPosition(parts.left_calf, { x: x - 8, y: y + 60 });
    Body.setVelocity(parts.left_calf, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.left_calf, 0);
    
    Body.setPosition(parts.right_thigh, { x: x + 8, y: y + 35 });
    Body.setVelocity(parts.right_thigh, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.right_thigh, 0);
    
    Body.setPosition(parts.right_calf, { x: x + 8, y: y + 60 });
    Body.setVelocity(parts.right_calf, { x: 0, y: 0 });
    Body.setAngularVelocity(parts.right_calf, 0);
  }
};

// 导出到全局作用域
window.matter_ffi = matter_ffi;
