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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CurrentMemScene, PerformanceReporter } from '@ohos/frameworkcommon';

const TAG = 'OutIconCenterViewManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class OutIconCenterViewController {
  showView: (viewHeight?: number) => void = () => {};
  hideView: (height?: number) => void = () => {};
  closeView: () => void = () => {};
  backGestureHandler: () => void = () => {};
}

/**
 * 界面管理类：用于跳转界面.
 */
export class OuterIconCenterViewManager {
  private static mInstance: OuterIconCenterViewManager;
  private outerIconCenterShow: boolean = false;
  private outerAppIsEnable: boolean = true;

  private outerIconCenterViewController?: OutIconCenterViewController;

  private constructor() {
  }

  /**
   * 获取单实例
   *
   * @returns 实例
   */
  public static getInstance(): OuterIconCenterViewManager {
    if (OuterIconCenterViewManager.mInstance === undefined) {
      OuterIconCenterViewManager.mInstance = new OuterIconCenterViewManager();
    }
    return OuterIconCenterViewManager.mInstance;
  }

  /**
   * 注册外屏应用中心监听器
   *
   * @param viewController
   */
  public registerOuterIconCenterViewController(viewController: OutIconCenterViewController): void {
    this.outerIconCenterViewController = viewController;
  }

  /**
   * 注销外屏应用中心监听器
   *
   * @param viewController
   */
  public unRegisterOuterIconCenterViewController(): void {
    this.outerIconCenterViewController = undefined;
  }

  /**
   * 扩展新形态小折叠产品外屏应用中心返回手势处理
   */
  public outerIconCenterBackGestureHandler(): void {
    if (!this.outerIconCenterShow) {
      log.showInfo('outerIconCenterBackGestureHandler outerIconCenter is closed');
      return;
    }
    this.outerIconCenterViewController?.backGestureHandler();
  }

  /**
   * 打开外屏应用中心
   * @param viewHeight 应用中心高度
   */
  public openOuterIconCenterView(viewHeight?: number): void {
    if (this.outerIconCenterShow) {
      log.showInfo('outer icon center is open');
      return;
    }
    log.showInfo('openOuterIconCenterView');
    this.outerIconCenterShow = true;
    PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.SCENE_FORM_CENTER);
    this.outerIconCenterViewController?.showView(viewHeight);
  }

  /**
   * 隐藏外屏应用中心
   * @param height 应用中心高度
   */
  public hideOuterIconCenterView(height?: number): void {
    this.outerIconCenterViewController?.hideView(height);
  }

  /**
   * 关闭外屏应用中心
   */
  public closeOuterIconCenterView(): void {
    PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_FORM_CENTER);
    log.showInfo('closeOuterIconCenterView');
    this.outerIconCenterViewController?.closeView();
    this.setOuterIconCenterViewState(false);
  }

  /**
   * 是否为扩展新形态小折叠产品外屏应用中心界面
   *
   * @returns boolean
   */
  public isOuterIconCenterViewShowing(): boolean {
    log.showWarn(`isOuterIconCenterViewShowing: ${this.outerIconCenterShow}`);
    return this.outerIconCenterShow;
  }

  /**
   * 设置扩展新形态小折叠产品外屏应用中心界面显示状态
   *
   * @param showState 显示状态
   */
  public setOuterIconCenterViewState(showState: boolean): void {
    log.showWarn(`setOuterIconCenterViewState: ${showState}`);
    this.outerIconCenterShow = showState;
  }

  /**
   * 更新搜索结果
   *
   * @param matchedText 搜索文字
   * @param appName 应用名称
   * @returns 搜索结果
   */
  public updateSearchResult(matchedText: string, appName: string): string[] {
    let searchResult: string[] = [];
    let index: number = appName.toLocaleLowerCase().indexOf(matchedText);
    if (CheckEmptyUtils.checkStrIsEmpty(matchedText) ||　index === -1) {
      return searchResult;
    }
    searchResult = [appName.slice(0, index), appName.slice(index, index + matchedText.length),
      appName.slice(index + matchedText.length)];
    log.showDebug(`matchedText: ${matchedText}, searchResult: ${searchResult}`);
    return searchResult;
  }

  /**
   * 设置外屏应用中心的应用是否可点击
   *
   * @param value 是否可点击
   */
  public setOuterAppIsEnable(value: boolean): void {
    this.outerAppIsEnable = value;
  }

  /**
   * 获取外屏应用中心的应用是否可点击
   *
   * @returns 是否可点击
   */
  public getOuterAppIsEnable(): boolean {
    return this.outerAppIsEnable;
  }
}