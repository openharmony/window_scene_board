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
import { DropDownEvent, TargetChangeState, TargetPanel } from '@ohos/frameworkwrapper';

const PANEL_SHOW_STATES: Set<TargetChangeState> = new Set([TargetChangeState.HORIZONTAL,
  TargetChangeState.HORIZONTAL_UP_BACK, TargetChangeState.VERTICAL_FLING]);

class NtfDropdownController {
  private visible: boolean = false;

  public updateVisibleByDropdownEvent(event: DropDownEvent): void {
    const isCurrentShowPanelContent = PANEL_SHOW_STATES.has(event.targetChanged);
    this.visible = isCurrentShowPanelContent || event.target === TargetPanel.NOTIFICATION_PANEL;
  }

  public isVisible(): boolean {
    return this.visible;
  }
}

let controller: NtfDropdownController = new NtfDropdownController();
export default controller as NtfDropdownController;