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
import { ViewArea, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import lazy { windowMgr } from '@ohos/windowscene';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';
import { ArkUIAdapter } from '../utils/ArkUIAdapter';

const TAG = 'WindowAdapter'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
export class WindowAdapter {
  @threadCall()
  public static isShowing(windowName: string): boolean | Promise<boolean> {
    log.showInfo(`isShowing windowName ${windowName}`);

    return windowMgr.isShowing(windowName);
  }

  @threadCall(ThreadCallType.Sync)
  public static isShowingSync(windowName: string): boolean {
    log.showInfo(`isShowingSync windowName ${windowName}`);

    return windowMgr.isShowing(windowName);
  }

  @threadCall()
  public static setWindowBgBlurRadius(windowName: string, radius: number): void {
    log.showInfo(`setWindowBgBlurRadius windowName ${windowName} radius ${radius}`)

    windowMgr.setWindowBgBlurRadius(windowName, radius);
  }

  @threadCall()
  public static hideView(viewType: ViewType | string): void | Promise<void> {
    viewMgrPolicy.hideView(viewType);
  }

  @threadCall()
  public static showView(viewType: ViewType | string): void | Promise<void> {
    viewMgrPolicy.showView(viewType);
  }

  @threadCall()
  public static isViewShowing(viewType: ViewType | string): boolean | Promise<boolean> {
    return viewMgrPolicy.isViewShowing(viewType);
  }

  @threadCall()
  public static getArea(viewType: ViewType | string): ViewArea | Promise<ViewArea> {
    log.showInfo(`viewType ${viewType}, ${JSON.stringify(viewMgrPolicy.getArea(viewType))}`);
    return viewMgrPolicy.getArea(viewType);
  }

  @threadCall(ThreadCallType.Sync)
  public static getWindowAnimPivot(windowName: string): Array<number> {
    return windowMgr.getWindowAnimPivot(windowName);
  }

  @threadCall()
  public static showWindowWithAnim(windowName: string): void {
    windowMgr.showWindowWithAnim(windowName);
  }

  @threadCall()
  public static startBindWinAnimOnFrame(windowName: string): void {
    windowMgr.startBindWinAnimOnFrame(windowName);
  }

  @threadCall()
  public static updateWindowPosition(windowName: string, width: number, height: number ): void {
    let winRect = windowMgr.getWindowPosition(windowName);
    winRect.height = width;
    winRect.width = height;
    windowMgr.updateWindowPosition(windowName, winRect);
  }

  @threadCall()
  public static setZIndex(viewType: ViewType | string, zIndex: number): void {
    viewMgrPolicy.setZIndex(viewType, zIndex)
  }

  @threadCall()
  public static getZIndex(viewType: ViewType | string): number | undefined {
    return viewMgrPolicy.getZIndex(viewType)
  }

  @threadCall()
  public static updateOpacity(viewType: ViewType | string, opacity: number) {
    viewMgrPolicy.updateOpacity(viewType, opacity);
  }

  @threadCall()
  public static updateAreaAndRectHeight(viewType: ViewType | string, height: number): void | Promise<void> {
    ArkUIAdapter.runWithScope(() => {
      let controller = viewMgrPolicy.getViewController(viewType);
      if (!controller) return;
      let viewArea: ViewArea | undefined = controller.getArea();
      viewArea.height = height;
      controller.updateArea(viewArea);
      controller.updateRect(viewArea);
    });
  }

}