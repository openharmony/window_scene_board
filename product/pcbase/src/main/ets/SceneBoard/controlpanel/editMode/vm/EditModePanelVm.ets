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
import { window } from '@kit.ArkUI';
import { windowMgr } from '@ohos/windowscene';
import { LogDomain, Logger } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { StatusBarType } from '@ohos/systemuicommon';
import { viewMgrPolicy, ViewType, PluginWindowType, PluginSlot } from '@ohos/frameworkwrapper';
import { EditModePanelIface, EditModeVisitor } from '../interfaces/EditModeIface';

const TAG = 'EditModePanelVm';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);
const EDIT_MODE_PANEL = PluginSlot.SLOT_STATUS_EDIT_MODE_PANEL;
const CONTROL_PANEL = PluginSlot.SLOT_STATUS_CONTROL_CENTER;
const PC_EDIT_MODE_PANEL_HEIGHT = 598;

export class EditModePanelVm implements EditModePanelIface {
  private viewData?: BaseViewController;
  private visitor?: EditModeVisitor;

  constructor(viewData: BaseViewController) {
    this.viewData = viewData;
  }

  public initEditModePanel(): void {
    if (!this.viewData) {
      log.showError(TAG, 'initEditModePanel error, view data invalid');
      return;
    }
    viewMgrPolicy.registerViewController(ViewType.EDIT_MODE_PANEL, this.viewData);

    interface rectTS {
      left: number;
      top: number;
      width: number;
      height: number;
    }

    let rect: rectTS = {
      left: 0,
      top: 0,
      width: px2vp(PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE)),
      height: PC_EDIT_MODE_PANEL_HEIGHT,
    };
    this.viewData.updateArea(rect);
    this.viewData.updateRect(rect);
    log.showInfo(TAG, `initEditModePanel success, panel rect: ${JSON.stringify(rect)}`);
  }

  public acceptModeVisitor(visitor: EditModeVisitor): void {
    this.visitor = visitor;
  }

  public updatePanelRect(rect: window.Rect, useAnim: boolean = false): void {
    const controlPanel = windowMgr.getWindowPosition(CONTROL_PANEL);
    const editModePanel = windowMgr.getWindowPosition(EDIT_MODE_PANEL);
    editModePanel.width = rect.width > 0 ? rect.width : editModePanel.width;
    editModePanel.height = rect.height > 0 ? rect.height : editModePanel.height;
    this.syncPanelPostion(editModePanel, controlPanel);
    if (useAnim) {
      animateTo({
        duration: 250,
        curve: Curve.Friction
      }, () => {
        windowMgr.updateWindowPosition(EDIT_MODE_PANEL, editModePanel);
      });
    } else {
      windowMgr.updateWindowPosition(EDIT_MODE_PANEL, editModePanel);
    }
    log.showInfo(TAG, `updatePanelRect ${editModePanel.left} ${editModePanel.top}
      ${editModePanel.width} ${editModePanel.height}`);
  }

  public onStartShow(): void {
    log.showInfo(TAG, 'onStartShow');
    // 编辑页面显示在控制中心相同的位置
    const controlPanel = windowMgr.getWindowPosition(CONTROL_PANEL);
    const editModePanel = windowMgr.getWindowPosition(EDIT_MODE_PANEL);
    if (!controlPanel) {
      log.showError(TAG, 'onStartShow control panel not exist');
      return;
    }
    this.syncPanelPostion(editModePanel, controlPanel);
    windowMgr.updateWindowPosition(EDIT_MODE_PANEL, editModePanel);
  }

  private syncPanelPostion(editModePanel: window.Rect, controlPanel: window.Rect): void {
    const statusBarType = AppStorage.get<number>('statusBarType');
    if (StatusBarType.isWindowStyle(statusBarType)) {
      // 下边缘和left，和控制中心保持一致
      editModePanel.left = controlPanel.left;
      editModePanel.top = controlPanel.top + controlPanel.height - editModePanel.height;
    } else {
      // 上边缘和left，和控制中心保持一致
      editModePanel.left = controlPanel.left;
      editModePanel.top = controlPanel.top;
    }
  }

  public onShow(): void {
    log.showInfo(TAG, 'onShow');
    AppStorage.setOrCreate('needReleaseToggleIcon', false);
    windowMgr.showWindowWithAnim(EDIT_MODE_PANEL, true);
  }

  public onHide(): void {
    log.showInfo(TAG, 'onHide');
    // 面板隐藏，尝试回滚
    this.visitor?.onTryRollback();
    windowMgr.hideWindowWithAnim(EDIT_MODE_PANEL);
    AppStorage.setOrCreate('isPcEditMode', false);
    if (!viewMgrPolicy.isViewShowing(ViewType.CONTROL_CENTER)) {
      AppStorage.setOrCreate('needReleaseToggleIcon', true);
    }
  }

  public getId(): number {
    return this.viewData?.getId() ?? -1;
  }
}