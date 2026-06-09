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
 * Dock区图标解锁屏、折叠展开等动效View Model
 */
export class DockItemAnimationVm {
  @Track public translateX: number = 0;
  @Track public translateY: number = 0;
  @Track public scaleSize: number = 1;
  @Track public centerX: string | number = 0;
  @Track public centerY: string | number = 0;
  @Track public blurRadius: number = 0;
  @Track public alpha: number = 1;
  @Track public visible: Visibility = Visibility.Visible;
}