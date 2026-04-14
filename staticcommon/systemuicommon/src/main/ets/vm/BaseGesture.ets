/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 手势基类
 */
@ObservedV2
export class BaseGesture implements GestureModifier {
  @Trace private gestureMap: Map<GestureHandler<Object>, [GesturePriority?, GestureMask?]> = new Map();
  @Trace private parallelGesture: Map<GestureHandler<Object>, [GestureMask?]> = new Map();

  /**
   * 应用手势，该方法不能直接调用，是暴露给gestureModifier用的
   * @param event
   */
  applyGesture(event: UIGestureEvent): void {
    for (const handler of this.gestureMap.keys()) {
      const value = this.gestureMap.get(handler)!;
      event.addGesture(handler, value[0], value[1]);
    }

    for (const handler of this.parallelGesture.keys()) {
      const value = this.parallelGesture.get(handler)!;
      event.addParallelGesture(handler, value[0]);
    }
  }

  /**
   * 添加手势
   * @param handler 手势处理器
   * @param priority 手势优先级
   * @param mask 事件响应设置
   */
  public addGesture(handler: GestureHandler<Object>, priority?: GesturePriority, mask?: GestureMask): BaseGesture {
    this.gestureMap.set(handler, [priority, mask]);
    return this;
  }

  /**
   * 移除手势
   * @param handler 手势处理器
   */
  public removeGesture(handler: GestureHandler<Object>): BaseGesture {
    this.gestureMap.delete(handler);
    return this;
  }

  /**
   * 添加可与子组件手势同时触发的手势
   * @param handler 手势处理器
   * @param mask 事件响应设置
   */
  public addParallelGesture(handler: GestureHandler<Object>, mask?: GestureMask): BaseGesture {
    this.parallelGesture.set(handler, [mask]);
    return this;
  }

  /**
   * 移除可与子组件手势同时触发的手势
   * @param handler 手势处理器
   */
  public removeParallelGesture(handler: GestureHandler<Object>): BaseGesture {
    this.parallelGesture.delete(handler);
    return this;
  }

  /**
   * 销毁手势
   */
  public destroy(): void {
    this.gestureMap.clear();
    this.parallelGesture.clear();
  }
}