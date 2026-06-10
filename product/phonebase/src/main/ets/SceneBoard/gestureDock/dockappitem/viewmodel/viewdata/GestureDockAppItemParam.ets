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
 * DockAppItemParam
 */
@Observed
export class DockAppItemParam {
  public translateX: number = 0;
  public translateY: number = 0;
  public scaleSize: number = 1;
  // 图标显隐控制
  public alpha: number = 1;
  // 实际透明度(多窗+编辑态)
  public iconOpacity: number = 1;
  public visible: Visibility = Visibility.Visible;
  // 角标透明度
  public badgeOpacity: number = 1;
}