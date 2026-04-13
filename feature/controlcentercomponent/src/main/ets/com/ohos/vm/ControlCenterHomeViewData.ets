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
// instrument ignore next
@Observed
export class ControlCenterHomeViewData {
  public blankLayoutWeight: number = 1;
  // 加载
  public loadEditPage: boolean = false;
  // 显示
  public showEditPage: boolean = false;
  public showAddMoreButton: boolean = false;
  public showEditModeHeader: boolean = false;
  public showEditText: boolean = false;
  public mediaCardOpacity: number = 1;
  public largeMediaCardOpacity: number = 1;
  public largeMediaCardScale: number = 1;
  public superTerminalOpacity: number = 1;
  public focusOpacity: number = 1;
  public shouldClipHeadArea: boolean = false;
  public replaceBrightnessBar: boolean = false;

  public resetParam() {
    this.mediaCardOpacity = 1;
    this.superTerminalOpacity = 1;
    this.focusOpacity = 1;
    this.shouldClipHeadArea = false;
  }
}