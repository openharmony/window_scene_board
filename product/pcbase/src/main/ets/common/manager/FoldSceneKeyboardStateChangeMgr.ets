/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { PcDockPopupMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockPopupMgr';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBKeyboardManager, SCBScreenProperty } from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';

const TAG = 'FoldSceneKeyboardStateChangeMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

export const WAIT_TIME: number = 350;

export class FoldSceneKeyboardStateChangeMgr {
  private static instance: FoldSceneKeyboardStateChangeMgr;
  private inKeyboardCallback: Array<Function> = [];
  private outKeyboardCallback: Array<Function> = [];
  private virtualKeyboardToPhysicKeyboardCallback: Function | null = null;
  private protectTimeId: number = 0;

  private constructor() {
  }

  public init() {}

  public destroy() {}

  public static getInstance(): FoldSceneKeyboardStateChangeMgr {
    if (!FoldSceneKeyboardStateChangeMgr.instance) {
      FoldSceneKeyboardStateChangeMgr.instance = new FoldSceneKeyboardStateChangeMgr();
    }
    return FoldSceneKeyboardStateChangeMgr.instance;
  }

  /**
   * 折叠PC不响应屏幕事件
   * 场景: 折叠态虚拟键盘/磁吸键盘, 连接扩展屏B面镜像投屏
   * 条件: (1)折叠PC（2）虚拟键盘/磁吸键盘态(3)屏幕的宽和dock当前宽一致
   * @returns
   */
  public isNoNeedUpdateDockArea(screenProperty: SCBScreenProperty, controller: BaseViewController,
    height: number, context: UIContext | undefined): boolean {
    log.showInfo(`isNoNeedUpdateDockArea screenProperty.width: ${context?.vp2px(controller.getArea().width)}`);
    return false;
  }

  private cancelTimer(): void {
    if (this.protectTimeId) {
      clearTimeout(this.protectTimeId);
      this.protectTimeId = 0;
    }
  }

  private onKeyboardStateChange = (parentId: number, persistentId: number,
    sessionState: sceneSessionManager.SessionState, mainScreenId: number) => {
    const isFloat = SCBKeyboardManager.getInstance().getSystemKeyboardSession()?.isFloatGravity();
    log.showInfo(`onStateChange, state: ${sessionState}, isFloat: ${isFloat}, protectTimeId: ${this.protectTimeId}`);
    if (sessionState === sceneSessionManager.SessionState.STATE_BACKGROUND && !isFloat && this.protectTimeId) {
      // 虚拟键盘退后台且不是悬浮小键盘态
      this.cancelTimer();
    }
  }
}