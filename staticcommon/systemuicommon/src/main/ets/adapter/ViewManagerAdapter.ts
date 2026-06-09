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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import lazy { ViewArea, ViewCallback, ViewController, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SCBEventId } from '@ohos/windowscene';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';

const TAG = 'ViewManagerAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface ViewMgrPolicyGestureCallback {
  eventId: SCBEventId;
  persistentId: number;
  callback: () => void;
}

export interface ViewMgrPolicyViewCallback extends ViewCallback {
  viewType: ViewType | string;
}

export class ViewManagerAdapter {
  @threadCall()
  public static registerViewController(viewType: ViewType | string, controller: ViewController): void {
    try {
      return ViewManagerPolicy.registerViewController(viewType, controller);
    } catch (e) {
      log.error('registerViewController error:', e);
    }
  }

  @threadCall()
  public static unregisterViewController(viewType: ViewType | string): void {
    try {
      return ViewManagerPolicy.unregisterViewController(viewType);
    } catch (e) {
      log.error('unregisterViewController error:', e);
    }
  }

  @threadCall()
  public static isViewShowing(viewType: ViewType | string): boolean | Promise<boolean> {
    log.showInfo(`isViewShowing viewType ${viewType}`);
    return ViewManagerPolicy.isViewShowing(viewType);
  }

  @threadCall()
  public static showView(viewType: ViewType | string): void {
    log.showInfo(`showView viewType ${viewType}`);
    return ViewManagerPolicy.showView(viewType);
  }

  @threadCall()
  public static hideView(viewType: ViewType | string): void {
    log.showInfo(`hideView viewType ${viewType}`);
    return ViewManagerPolicy.hideView(viewType);
  }

  @threadCall(ThreadCallType.Register)
  public static onGestureCallback(callback: ViewMgrPolicyGestureCallback, tag: string): void {
    log.showInfo(`onGestureCallback eventId: ${callback.eventId}, persistentId: ${callback.persistentId}, callback: ${typeof callback.callback}`);
    return ViewManagerPolicy.onGestureCallback(callback.eventId, callback.persistentId, callback.callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static offGestureCallback(callback: ViewMgrPolicyGestureCallback, tag: string): void {
    log.showInfo(`offGestureCallback eventId: ${callback.eventId}, persistentId: ${callback.persistentId}`);
    return ViewManagerPolicy.offGestureCallback(callback.eventId, callback.persistentId);
  }

  /**
   * getId
   */
  @threadCall()
  public static getDropDownId(): number | Promise<number> {
    let viewController = ViewManagerPolicy.getViewController(ViewType.DROPDOWN);
    return viewController?.getId() ?? -1;
  }

  /**
   * setDropDownZIndex
   */
  @threadCall()
  public static setDropDownZIndex(zIndex: number) {
    let viewController = ViewManagerPolicy.getViewController(ViewType.DROPDOWN);
    viewController?.setZIndex(zIndex);
  }

  @threadCall(ThreadCallType.Register)
  public static registerViewCallback(callback: ViewMgrPolicyViewCallback, tag: string): void {
    log.showInfo(`registerViewCallback, viewType: ${callback.viewType}`);
    return ViewManagerPolicy.registerViewCallback(callback.viewType, callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterViewCallback(callback: ViewMgrPolicyViewCallback, tag: string): void {
    log.showInfo(`registerViewCallback, viewType: ${callback.viewType}`);
    return ViewManagerPolicy.unRegisterViewCallback(callback.viewType, callback);
  }
}