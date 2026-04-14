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
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';
import lazy { SCBSceneSessionManager, SCBScreenSessionManager, ScenePanelState } from '@ohos/windowscene';
import lazy { ABLE_DROPDOWN_PANEL_ROTATION } from '../template/common/SCBVisualEffectOption';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ScreenSensorAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class ScreenSensorAdapter {
  // 窗口显示时屏幕Sensor/旋转锁定状态
  private static showWindowSensorScreen?: number;
  private static showWindowIsLocked?: boolean;
  // 窗口收起时屏幕Sensor/旋转锁定状态
  private static hideWindowSensorScreen?: number;
  private static hideWindowIsLocked?: boolean;

  @threadCall()
  public static handleScreenSensorForDropDownWindow(enableRotate: boolean, reasonType: string): void | Promise<void> {
    // 隐藏下拉窗口
    if (enableRotate) {
      log.showInfo(`close dropDownPanel, scenePanelState: ${AppStorage.get<ScenePanelState>('scenePanelState')}`);
      if (!ABLE_DROPDOWN_PANEL_ROTATION) {
        const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
        screenSession?.setEnableRotate(true, reasonType);
        this.handleDropDownWindowHideScreenSensor();
      }
      return;
    } else {
      if (!ABLE_DROPDOWN_PANEL_ROTATION) {
        const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
        this.showWindowSensorScreen = screenSession?.sensorScreenProperty.rotation;
        screenSession?.setEnableRotate(false, reasonType);
        this.showWindowIsLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked();
      }
    }
  }

  /**
   * 处理DropDownPanel收起后触发屏幕旋转sensor
   */
  private static handleDropDownWindowHideScreenSensor(): void {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    this.hideWindowSensorScreen = screenSession?.sensorScreenProperty.rotation;
    this.hideWindowIsLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked();
    if (SCBScreenSessionManager.getInstance().resetRotationHandleDropDownWindowHideScreenSensor(screenSession)) {
      log.showInfo('handleDropDownWindowHideScreenSensor resetRotationHandleDropDownWindowHideScreenSensor true,' +
        ' not need rotationChangeEntry');
      return;
    }
    // 如果 设备角度发生变化|| (控制中心开关状态发生变化 && 当前应用受旋转开关影响) 触发sensor旋转
    if (this.hideWindowSensorScreen !== this.showWindowSensorScreen ||
      (this.hideWindowIsLocked !== this.showWindowIsLocked &&
        !SCBSceneSessionManager.getInstance().isRotateLockedUnrelatedSessionActive(
          screenSession.scbScreenProperty.screenId))) {
      screenSession?.rotationChangeEntry(screenSession?.sensorScreenProperty.rotation,
        'unlock dropdown panel rotation');
    }
  }
}