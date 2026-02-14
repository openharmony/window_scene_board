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

import { ApsUtils, DeviceHelper, FoldPhoneTypeValue } from '@ohos/frameworkwrapper';
import { SingletonHelper } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { SCBScenePanelManager, SCBScreenSessionManager, ScenePanelState } from '@ohos/windowscene';
import display from '@ohos.display';
import { RoPropConstants } from '@ohos/commonconstants';
import { launcherStatusUtil } from '@ohos/windowscene';

const TAG = 'DesktopUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


/**
 * deskTop setting sendevent
 *
 * @since 2024-6-17
 */
export class DesktopUtil {
  /**
   * page count, default
   */
  static readonly DEFAULT_PAGE_COUNT: string = 'page_count';


  /**
   * outer_page count
   */
  static readonly OUTER_PAGE_COUNT: string = 'outer_page_count';

  /**
   * page index, default
   */
  static readonly DEFAULT_PAGE_INDEX: string = 'pageIndex';


  /**
   * outer_page index
   */
  static readonly OUTER_PAGE_INDEX: string = 'outerPageIndex';

  /**
   * app list info, default
   */
  static readonly DEFAULT_APP_LIST_INFO: string = 'appListInfo';


  /**
   * outer app list info, default
   */
  static readonly OUTER_APP_LIST_INFO: string = 'outerAppListInfo';

  private PAGE_INDEX: string = DesktopUtil.DEFAULT_PAGE_INDEX;
  private APP_LIST_INFO: string = DesktopUtil.DEFAULT_APP_LIST_INFO;
  private PAGE_COUNT: string = DesktopUtil.DEFAULT_PAGE_COUNT;
  private SMALL_FOLD_APP_MENU_WIDTH_COLUMNS: number = 160;
  private SMALL_FOLD_FORM_MENU_WIDTH_COLUMNS: number = 152;
  private isFoldDevice: boolean = undefined;
  private isNeedIgnoreFoldDevice: boolean = undefined;
  private touchItemPage: number = -1;

  private updatePageIndex(isFolded: boolean): void {
      this.PAGE_INDEX = DesktopUtil.DEFAULT_PAGE_INDEX;
  }

  private updateAppListInfo(isFolded: boolean): void {
      this.APP_LIST_INFO = DesktopUtil.DEFAULT_APP_LIST_INFO;
  }

  private updatePageCount(isFolded: boolean): void {
      this.PAGE_COUNT = DesktopUtil.DEFAULT_PAGE_COUNT;
  }

  public getSmallFoldFormMenuWidthColumns(): number {
    return this.SMALL_FOLD_FORM_MENU_WIDTH_COLUMNS;
  }

  public getSmallFoldAppMenuWidthColumns(): number {
    return this.SMALL_FOLD_APP_MENU_WIDTH_COLUMNS;
  }

  public updateFoldStatusParamByStatus(isFolded: boolean): void {
    this.updatePageIndex(isFolded);
    this.updateAppListInfo(isFolded);
    this.updatePageCount(isFolded);
    launcherStatusUtil.updateShowOutLauncherStatus(isFolded);
    log.showInfo('updateFoldStatusParamByStatus ' + isFolded + ' PAGE_INDEX = ' + this.getPageIndex() +
      ' APP_LIST_INFO = ' + this.getAppListInfo() + ' PAGE_COUNT = ' + this.getPageCount() +
      ' Lanucher status = ' + launcherStatusUtil.getShowOutLauncherStatus());
  }

  public initFoldStatusParam(isFolded: boolean): void {
    this.updateFoldStatusParamByStatus(isFolded);
  }

  /**
   * get page count
   *
   * @return string page_count
   */
  public getPageCount(isOuter?: boolean): string {
    if (isOuter === undefined) {
      return this.PAGE_COUNT;
    }
    return isOuter ? DesktopUtil.OUTER_PAGE_COUNT : DesktopUtil.DEFAULT_PAGE_COUNT;
  }

  /**
   * get page index
   *
   * @return string page_index
   */
  public getPageIndex(): string {
    return this.PAGE_INDEX;
  }

  /**
   * get page index value
   *
   * @return string page_index
   */
  public getPageIndexValue(isOuter?: boolean): number {
    return AppStorage.get<number>(this.getPageIndex()) as number;
  }

  /**
   * 设置swiperpage响应touch事件的pageindex
   *
   * @param page swiperpage响应touch事件的pageindex
   */
  public setTouchItemPage(page: number): void {
    this.touchItemPage = page;
  }

  /**
   * 获取swiperpage最新响应touch事件的pageindex
   *
   * @returns swiperpage最新响应touch事件的pageindex
   */
  public getTouchItemPage(): number {
    return this.touchItemPage;
  }

  /**
   * get app list info
   *
   * @return string phone
   */
  public getAppListInfo(isOuter?: boolean): string {
    if (isOuter === undefined) {
      return this.APP_LIST_INFO;
    }
    return isOuter ? DesktopUtil.OUTER_APP_LIST_INFO : DesktopUtil.DEFAULT_APP_LIST_INFO;
  }

  /**
   * 桌面是否需要忽略的折叠屏形态：如小折叠（上下折叠）形态设备，桌面仍需按直板机逻辑处理
   */
  public needIgnoreFoldDeviceForLauncher(): boolean {
    if (this.isNeedIgnoreFoldDevice !== undefined) {
      return this.isNeedIgnoreFoldDevice;
    }
    if (CheckEmptyUtils.isEmpty(RoPropConstants.DEVICE_SCREEN_FLAG)) {
      this.isNeedIgnoreFoldDevice = false;
      return this.isNeedIgnoreFoldDevice;
    }
    try {
      let deviceType = Number.parseInt(RoPropConstants.DEVICE_SCREEN_FLAG.substring(0, 1));
      // 针对小折叠以及扩展新形态小折叠产品，桌面需以直板机逻辑处理
      this.isNeedIgnoreFoldDevice =
        ((deviceType === FoldPhoneTypeValue.SMALL_FOLD) && !launcherStatusUtil.getShowOutLauncherStatus()) ||
          (deviceType === FoldPhoneTypeValue.EXPANDING_NEX_FORMS);
    } catch (error) {
      log.showError('get deviceType error:', error);
    }
    return this.isNeedIgnoreFoldDevice;
  }

  /**
   * 是否为折叠屏
   * 注：桌面业务场景，针对小折叠设备，仍以非折叠逻辑处理
   *
   * @returns true是，false不是
   */
  public isFold(): boolean {
    if (this.isFoldDevice !== undefined) {
      return this.isFoldDevice;
    }
    this.isFoldDevice = false;
    try {
      this.isFoldDevice = !this.needIgnoreFoldDeviceForLauncher() && display.isFoldable();
    } catch (error) {
      log.showError('isFold -> isFoldable try error:', error);
    }
    return this.isFoldDevice;
  }

  /**
   * 是否支持简易模式
   *
   * @returns true：支持
   */
  public isSupportSimpleMode(): boolean {
    return false;
  }

  /**
   * 通过缓存识别屏幕开合状态，如过对开合时机要求高的场景，可能存在缓存更新不及时的情况
   * 识别折叠屏开合状态，做折叠屏特有逻辑处理
   * （注：针对小折叠设备，桌面仍以直板机逻辑处理，该方法识别逻辑与桌面业务相关）
   *
   * @returns true：折叠屏展开态
   */
  public isFoldExpandStatus(): boolean {
    return !this.needIgnoreFoldDeviceForLauncher() &&
    SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  }

  /**
   * 当前显示屏幕是否为直版机状态（直版机/大折叠折叠态/小折叠展开态）
   *
   * @returns boolean true是，false不是
   */
  public isBarPhoneStatus(): boolean {
    return DeviceHelper.isPhone() && (!this.isFold() || !this.isFoldExpandStatus());
  }

  /**
   * 判断是否是三屏设备的G态场景
   * @returns 是否是是三屏设备且为G态场景
   */
  public isThreeScreenGState(): boolean {
    return DeviceHelper.isUltraScreenProduct() && DeviceHelper.isGState();
  }

  /**
   * 当前显示屏幕是否为直版机竖屏状态（直版机/大折叠折叠态/小折叠展开态）
   *
   * @returns boolean true是，false不是
   */
  public isBarPhonePortraitStatus(): boolean {
    return this.isBarPhoneStatus() && !DeviceHelper.isLandscape();
  }

  /**
   * 通知APS模块场景启动和结束
   *
   * @param sceneName 场景名称
   * @param state 状态 1表示启动0表示结束
   */
  // public setApsSceneWindowCheck(sceneName: apsManager.SceneAnimation, state: number): void {
  //   let isMultiWindowScene: boolean = this.isInMultiWindowScene();
  //   log.showInfo('setApsScene %{public}s to state %{public}d isMulti %{public}s', sceneName, state, isMultiWindowScene);
  //   if (sceneName && !isMultiWindowScene) {
  //     ApsUtils.setApsScene(sceneName, state);
  //   }
  // }

  /**
   * 是否处于多窗场景
   *
   * @returns true处于多窗
   */
  private isInMultiWindowScene(): boolean {
    return !SCBScenePanelManager.getInstance().getFloatingSessionList()?.isEmpty() ||
      SCBScenePanelManager.getInstance().getSceneContainerSessionList()?.findIndex(session =>
      session.isMidScene || session.isSplit) > 0;
  }

  /**
   * 是否桌面在前台
   *
   * @returns true 桌面处于前台
   */
  public isDesktopForeground(): boolean {
    let scenePanelState = AppStorage.get<number>('scenePanelState');
    return scenePanelState === ScenePanelState.HOME || scenePanelState === ScenePanelState.FLOAT_SCENE;
  }
}

export const desktopUtil: DesktopUtil = SingletonHelper.getInstance(DesktopUtil, TAG);