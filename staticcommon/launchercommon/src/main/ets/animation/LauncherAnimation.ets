/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
 * 桌面元素名称出现的动效
 *
 * @param nameAppearCallback 桌面元素名称出现的callback
 */
export function nameAppearAnimate(nameAppearCallback: () => void) {
  // 当前落位动效采用弹簧曲线，不同距离时测试发现动效时长均为650ms左右，若后续曲线和时长改变，此处delay也需要相应适配
  animateTo({
    delay: 200,
    duration: 200,
    curve: Curve.Friction
  }, nameAppearCallback);
}