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
import { ViewType } from '@ohos/frameworkwrapper';
import type { ViewController, ViewArea, ViewCallback } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { PluginInfo } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, sSCBOobeManager } from '@ohos/windowscene';
import { SCBKeyboardManager } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { GcController } from '../../memory/GcController';
import { TrimLevel } from '@ohos/frameworkwrapper';

const TAG = 'BaseViewController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class BaseViewController implements ViewController {
  created: boolean = false;
  visible: boolean = false;
  private area: ViewArea;
  protected viewType: ViewType | string;
  private viewData: PluginInfo;
  protected  persistentId: number = 0;
  private callbackArray: Array<ViewCallback> = new Array<ViewCallback>();
  private screenId: number | undefined;

  constructor(viewType: ViewType | string, screenId?: number) {
    this.viewType = viewType;
    this.screenId = screenId;
    log.showInfo(`screenId: ${this.screenId}, viewType: ${this.viewType}`);
  }

  dealTouchOutSide(): boolean {
    log.showInfo('dealTouchOutSide not implement');
    return false;
  }

  onTrimMemory(level: TrimLevel, reason: string): void {
    log.showInfo(`onTrimMemory -> viewType:${this.viewType} id:${this.persistentId}, level:${level}, reason:${reason}`);
    for (const callback of this.callbackArray) {
      callback?.onTrimMemory?.(level);
    }
  }

  registerCallback(viewCallback: ViewCallback): void {
    this.callbackArray.push(viewCallback);
  }

  unRegisterCallback(viewCallback: ViewCallback): void {
    let index = this.callbackArray.indexOf(viewCallback);
    if (index === -1) {
      return;
    } else {
      this.callbackArray.splice(index, 1);
    }
  }

  updateId(persistentId: number): void {
    this.persistentId = persistentId;
    log.showInfo(`updateId ${this.readableViewType(this.viewType)} persistentId: ${this.persistentId} param: ${persistentId}`);
  }

  getId(): number {
    return this.persistentId;
  }

  show(isFocusableOnShow = true): void {
    if (this.visible) {
      log.showDebug(`view: ${this.viewType.toString()} has been visible`);
      return;
    }
    if (this.viewType === ViewType.SMART_DOCK_EXT_SCREEN && sSCBOobeManager.isOobeActivated()) {
      log.showInfo('is in oobe, will return');
      return;
    }
    this.visible = true;
    this.created = true;
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.setFocusableOnShow(isFocusableOnShow);
      systemSceneSession.setVisibility(true);
      systemSceneSession.processStateChange(sceneSessionManager.SessionState.STATE_FOREGROUND);
      log.showInfo(`systemName: ${systemSceneSession.name} aboutToAppear currRect,left.getPxStr:%{public}s`, systemSceneSession.currRect.left.getPxStr());
    }
    this.callbackArray.forEach((item: ViewCallback) => {
      item?.onShow?.();
    });
    GcController.getInstance().clearInterval(this.readableViewType(this.viewType));
    log.showInfo(`show ${this.readableViewType(this.viewType)} persistentId: ${this.persistentId} isFocusableOnShow: ${isFocusableOnShow}, screenId: ${this.screenId}`);
  }

  hide(): void {
    if (!this.visible) {
      log.showDebug(`view: ${this.viewType.toString()} has been invisible`);
      return;
    }
    this.visible = false;
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.setVisibility(false);
      systemSceneSession.processStateChange(sceneSessionManager.SessionState.STATE_BACKGROUND);
    }
    this.callbackArray.forEach((item: ViewCallback) => {
      item?.onHide?.();
    });
    log.showInfo(`hide ${this.readableViewType(this.viewType)} persistentId: ${this.persistentId}`);
  }

  destroy(): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.setActive(false);
    }
    log.showInfo(`destroy ${this.readableViewType(this.viewType)} persistentId: ${this.persistentId}`);
  }

  isShowing(): boolean {
    return this.visible;
  }

  updateArea(area: ViewArea): void {
    if (this.area && this.area.left === area.left && this.area.top === area.top &&
      this.area.width === area.width && this.area.height === area.height) {
      return;
    }
    this.area = {
      left: area.left,
      top: area.top,
      width: area.width,
      height: area.height
    };
    log.showInfo(`updateArea: ${this.readableViewType(this.viewType)},left:%{public}d,top:%{public}d,width:%{public}d,height:%{public}d`, this.area.left, this.area.top, this.area.width, this.area.height);
  }

  updateRect(area: ViewArea): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      log.showInfo(`updateRect: ${this.readableViewType(this.viewType)},left:%{public}d,top:%{public}d,width:%{public}d,height:%{public}d`, area.left, area.top, area.width, area.height);
      systemSceneSession.updateRect(area.left, area.top, area.width, area.height);
    }
  }

  updateRectInPx(area: ViewArea): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(
      this.persistentId, this.screenId);
    if (systemSceneSession) {
      log.showInfo('updateRectInPx: ${this.readableViewType(this.viewType)},left:%{public}d,top:%{public}d' +
        ',width:%{public}d,height:%{public}d', area.left, area.top, area.width, area.height);
      systemSceneSession.updateRectInPx(area.left, area.top, area.width, area.height);
    }
  }

  getArea(): ViewArea {
    if (!this.area) {
      return {
        left: 0,
        top: 0,
        width: 0,
        height: 0
      };
    }
    return {
      left: this.area.left,
      top: this.area.top,
      width: this.area.width,
      height: this.area.height,
    };
  }

  setViewData(data: PluginInfo): void {
    this.viewData = data;
  }

  getViewData(): PluginInfo {
    return this.viewData;
  }

  readableViewType(viewType: ViewType | string): string {
    return ViewType[viewType] ?? viewType;
  }

  setTranslate(x: number, y: number, z: number): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.setTranslate(x, y, z);
    }
    log.showInfo(`setTranslate ${ViewType[this.viewType]} persistentId: ${this.persistentId}`);
  }

  setOpacity(opacity: number): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.setOpacity(opacity);
    }
    log.showInfo(`setOpacity ${ViewType[this.viewType]} persistentId: ${this.persistentId}`);
  }

  setTouchable(touchable: boolean): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.setTouchable(touchable);
    }
    log.showInfo(`setTouchable ${ViewType[this.viewType]} persistentId: ${this.persistentId}`);
  }

  registerInputMethodChange(callBack: Function): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.registerInputMethodChangeListener(callBack);
      log.showInfo('registerInputMethodChange success');
    } else {
      log.showError('registerInputMethodChange fail. systemSceneSession not exist');
    }
  }

  unregisterInputMethodChange(): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.unregisterInputMethodChangeListener();
      log.showInfo('unregisterInputMethodChange success');
    } else {
      log.showError('unregisterInputMethodChange fail. systemSceneSession not exist');
    }
  }

  registerInputMethodRectChange(callBack: Function): boolean {
    let systemSceneSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    if (systemSceneSession) {
      systemSceneSession.registerKeyboardHeightChangeCallback(callBack);
      log.showInfo('registerInputMethodRectChange success');
      return true;
    } else {
      log.showError('registerInputMethodRectChange fail. systemSceneSession not exist');
      return false;
    }
  }

  unregisterInputMethodRectChange(): void {
    let systemSceneSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    if (systemSceneSession) {
      systemSceneSession.unregisterKeyboardHeightChangeCallback();
      log.showInfo('unregisterInputMethodRectChange success');
    } else {
      log.showError('unregisterInputMethodChange fail. systemSceneSession not exist');
    }
  }

  setZIndex(zIndex: number, updateKeyguardOccludeState: boolean = true): void {
    log.showInfo(`setZIndex persistentId: ${this.persistentId}, screenId: ${this.screenId}`);
    let systemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.setZIndex(zIndex);
    } else {
      log.showError('setZIndex fail. systemSceneSession not exist');
    }
  }

  getZIndex(): number | undefined {
    let systemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    return systemSceneSession?.getZIndex();
  }

  updateOpacity(opacity: number): void {
    log.showInfo(`updateOpacity opacity: ${opacity}`);
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.setOpacity(opacity);
    } else {
      log.showWarn('updateOpacity fail. systemSceneSession not exist');
    }
  }

  /**
   * 设置触摸热区范围
   *
   * @param responseRegion 触摸热区
   */
  setResponseRegion(responseRegion: Array<Rectangle>): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenId);
    if (systemSceneSession) {
      systemSceneSession.setResponseRegion(responseRegion);
    }
  }

  getPersistentId(): number {
    return this.persistentId;
  }

  getScreenId(): number | undefined {
    return this.screenId;
  }
}