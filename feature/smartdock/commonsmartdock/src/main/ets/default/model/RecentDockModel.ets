/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  ObjUtil,
  RectInfo,
  SingleBase,
  SingleContext,
  singleManager,
  StartType } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { DeviceHelper, HiSysEventUtil, IconResourceManager, localEventManager } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SceneInfoAdapterUtil, StartAbilityUtil } from '@ohos/windowscene';
import {
  BadgeItemInfo,
  DeleteDockItem,
  DockContinuableInfo,
  DockItemInfo,
  ReceiveEventInfo,
  RecentLayoutCacheMgr,
  ResidentLayoutCacheMgr
} from '@ohos/launchercommon';
import {
  AppModel,
  CloseAppManager,
  CommonConstants,
  EventConstants,
  layoutConfigManager,
  RdbStoreManager,
  SettingsModel,
  StyleConstants
} from '@ohos/launchercommon';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import FeatureConstants from '../common/constants/FeatureConstants';
import SmartDockModel from './SmartDockModel';
import StatusBarServiceEventMgr from '../manager/StatusBarServiceEventMgr';
import { image } from '@kit.ImageKit';

const TAG = 'RecentDockModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * RecentDock Model
 */
export default class RecentDockModel extends SingleBase {
  public static singleName: string = 'RecentDockModel';
  private readonly mSmartDockStyleConfig: SmartDockStyleConfig;
  protected mAppModel: AppModel;
  private isSupportRecentDock: boolean;
  private mRecentCacheMgr: RecentLayoutCacheMgr;
  private recentListRotateNum: number = 0;
  private readonly mUpdateAppInfoListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string): void => {
      log.showInfo(`receive event: ${event}, params: ${params}`);
      if (event === EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE) {
        this.updateRecentDockItem(params);
      }
    }
  };

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.mSmartDockStyleConfig = layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
    this.isSupportRecentDock = this.getSupportRecentDockState();
    this.mAppModel = AppModel.getInstance();
    this.mRecentCacheMgr = RecentLayoutCacheMgr.getInstance();
    this.registerDockListener();
  }

  static getInstance(ctx?: SingleContext): RecentDockModel {
    return singleManager.get<RecentDockModel>(RecentDockModel, ctx);
  }

  public updateBadgeNum(badgeInfo: BadgeItemInfo): void {
    if (!this.isSupportRecentDock) {
      return;
    }
    let recentDockList = this.mRecentCacheMgr.getAllDockItems();
    // 刷新角标时，同步刷新最近任务区
    if (!CheckEmptyUtils.isEmptyArr(recentDockList)) {
      for (let i = 0; i < recentDockList.length; i++) {
        if (SmartDockModel.getInstance(this.singleContext).checkSameDockItem(badgeInfo, recentDockList[i])) {
          recentDockList[i].editable = true;
          recentDockList[i].badgeNumber = badgeInfo.isShow ? badgeInfo.badgeNumber : 0;
          break;
        }
      }
      this.mRecentCacheMgr.updateAllDockItems(TAG.concat('_updateBadge'), recentDockList, false);
    }
  }

  /**
   * 获取recent区的索引index
   * @param bundleName
   * @param appIndex
   * @returns
   */
  public getAppIndexInRecentDockList(bundleName: string, appIndex: number = 0): number {
    let recentDockList = this.mRecentCacheMgr.getAllDockItems();
    if (!CheckEmptyUtils.isEmptyArr(recentDockList)) {
      return recentDockList.findIndex((item) => item.bundleName === bundleName && item.appIndex === appIndex);
    }
    return -1;
  }

  public addToRecentDockList(bundleName: string | undefined, appIndex: number = 0): void {
    try {
      if (!this.isSupportRecentDock) {
        return;
      }
      if (CheckEmptyUtils.isEmpty(bundleName)) {
        log.showWarn('addToRecentDockList fail, bundleName is null');
        return;
      }
      let recentDockList = this.mRecentCacheMgr.getAllDockItems();
      if (recentDockList.length > this.mSmartDockStyleConfig.mRecentDockMaxNumber) {
        // 删除超出的元素
        this.cleanContinueItem();
        recentDockList.splice(this.mSmartDockStyleConfig.mRecentDockMaxNumber);
      }
      this.mRecentCacheMgr.updateAllDockItems(TAG.concat('_add'), recentDockList, true);
    } catch (e) {
      log.error('addToRecentDockList error', e);
    }
  }

  private cleanContinueItem(): void {
    const deviceInfo: DockContinuableInfo | undefined = AppStorage.get<DockContinuableInfo>('continueDeviceInfo');
    if (!deviceInfo) {
      return;
    }
    const index: number = this.getAppIndexInRecentDockList(deviceInfo.bundleName, 0);
    if (this.continuableItemExists(deviceInfo) && index >= this.mSmartDockStyleConfig.mRecentDockMaxNumber) {
      AppStorage.setAndRef('continueDeviceInfo', new DockContinuableInfo()).set(new DockContinuableInfo());
    }
  }

  private isRecentElement(bundleName: string, appIndex: number): boolean {
    let residentList = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (residentList?.length > 0 &&
    residentList.find((item) => item.bundleName === bundleName && item.appIndex === appIndex && item.typeId === 0)) {
      log.showDebug(`app found in residentList: ${bundleName} ${appIndex}`);
      return false;
    }
    return true;
  }

  public deleteRecentDockItem(dockItem: DeleteDockItem): boolean {
    if (!this.isSupportRecentDock) {
      return false;
    }
    let recentDockList = this.mRecentCacheMgr.getAllDockItems();
    if (!CheckEmptyUtils.isEmptyArr(recentDockList)) {
      log.showDebug(`delete from recentDockList, bundleName is : ${dockItem?.bundleName} ,${dockItem?.typeId}`);
      let beforeLength: number = recentDockList.length;
      recentDockList = recentDockList.filter(item => {
        if (dockItem.bundleName) {
          return !(dockItem.bundleName === item.bundleName && dockItem.appIndex === item.appIndex &&
            dockItem.typeId !== CommonConstants.TYPE_SHORTCUT_ICON);
        } else if (dockItem.keyName) {
          return dockItem.keyName !== item.keyName;
        } else {
          return true;
        }
      });
      let afterLength: number = recentDockList.length;
      if (beforeLength === afterLength) {
        return false;
      }
      this.mRecentCacheMgr.updateAllDockItems(TAG.concat('_delete'), recentDockList, false);
      // 删除数据库数据
      RdbStoreManager.getInstance().deleteRecentDockByBundle(dockItem?.bundleName, dockItem?.appIndex);
      const visibleCount = this.mRecentCacheMgr.getVisibleCount();
      log.showInfo(`deleted from recentDockList: ${recentDockList.length} ,${visibleCount}`);
      return visibleCount <= 0 || recentDockList.length < visibleCount;
    }
    return false;
  }

  public recentDockOnClick(item: DockItemInfo): void {
    // 拖拽过程中不响应dock点击
    if (DeviceHelper.isPhone() && AppStorage.get<boolean>('isDrag')) {
      log.showInfo('residentOnClick isDrag true');
      return;
    }
    if (!item) {
      log.showInfo('item is empty！');
      return;
    }
    // set start app info
    log.showInfo(`start new application from recent dock ,bundle name is ${item.bundleName} ${item.appIndex}`);
    this.setRecentDockStartAppInfo(item);
    if (item.appIndex && item.appIndex > 0) {
      let params: Map<string, Number> = new Map();
      params.set(SCBConstants.START_APP_CLONE_INDEX, item.appIndex);
      StartAbilityUtil.startLauncherAbility(item.abilityName, item.bundleName, item.moduleName, params);
    } else {
      StartAbilityUtil.startLauncherAbility(item.abilityName, item.bundleName, item.moduleName);
    }
  }

  /**
   * set start app info
   */
  private setRecentDockStartAppInfo(item: DockItemInfo): void {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError('setStartAppInfo without item');
      return;
    }
    CloseAppManager.getInstance().setStartAppType(StartType.RECENT_DOCK_APP, null, String(item.appIconId));
  }

  private getSupportRecentDockState(): boolean {
    if (DeviceHelper.isPhone() && !DeviceHelper.isFoldButNotSmallFoldProduct()) {
      return false;
    }
    return true;
  }

  private registerDockListener(): void {
    if (!this.isSupportRecentDock) {
      return;
    }
    localEventManager.registerEventListener(this.mUpdateAppInfoListener, [
      EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE
    ]);
    log.showDebug('local listener on create');
  }

  private updateRecentDockItem(bundleName: string): void {
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('updateRecentDockItem fail, bundleName is null');
      return;
    }
    let recentDockList = this.mRecentCacheMgr.getAllDockItems();
    let index = recentDockList.findIndex((item) => item.bundleName === bundleName);
    if (index === -1) {
      log.showInfo('app not found in recent dock list');
      return;
    }
    let appList = this.mAppModel.getAppList();
    let appItem = appList.find(item => item.bundleName === bundleName);
    if (!appItem) {
      log.showInfo('app not found in appList');
      return;
    }
    let recentTaskInfo = SmartDockModel.getInstance().buildDockItemInfo(appItem);
    recentDockList.splice(index, 1, recentTaskInfo);
    this.mRecentCacheMgr.updateAllDockItems(TAG.concat('_update'), recentDockList, true);
  }

  public getListPadding(): RectInfo {
    let rectInfo: RectInfo = new RectInfo();
    rectInfo.left = this.mSmartDockStyleConfig.mDockPadding;
    rectInfo.right = 0;
    return rectInfo;
  }

  public getDockSpace(recentDockListRotate: Array<DockItemInfo>): number {
    if (recentDockListRotate.length === 0) {
      return 0;
    }
    return this.mSmartDockStyleConfig.mListItemGap;
  }

  public getDividerWidth(): number {
    if (DeviceHelper.isPad() ||
      (SCBSceneSessionManager.getInstance().isPcMode() && DeviceHelper.isUltraScreenProduct())) {
      return StyleConstants.DEFAULT_20;
    }
    let desktopIconChangeSize: number = AppStorage.get<number>('settingIconChange') ?? 0;

    let dividerWidth = this.mSmartDockStyleConfig.mResidentSplitLineWidth +
      this.mSmartDockStyleConfig.mResidentSplitLineGap * 2;

    if (desktopIconChangeSize !== undefined && desktopIconChangeSize <= 0) {
      dividerWidth -= desktopIconChangeSize;
    }
    return dividerWidth;
  }

  public continuableItemExists(deviceInfo: DockContinuableInfo): boolean {
    return ObjUtil.isValid(deviceInfo) && ObjUtil.isValid(deviceInfo.bundleName) &&
    ObjUtil.isValid(deviceInfo.sourceDeviceName);
  }

  public isContinueNotShow(deviceInfo: DockContinuableInfo): boolean {
    return ObjUtil.isInvalid(deviceInfo) || ObjUtil.isInvalid(deviceInfo.bundleName) ||
    ObjUtil.isInvalid(deviceInfo.sourceDeviceName);
  }

  public isPadPortraitHaveTask(mIsPortrait: boolean, recentDockList: Array<DockItemInfo>): boolean {
    return mIsPortrait && DeviceHelper.isPad() && recentDockList.length > 0;
  }

  public computeVisibleCount(recentDockListRotate: Array<DockItemInfo>, visibleCount: number,
    spaceValue: number, recentLayoutWidth: number): number {
    let realMaxLenth = recentDockListRotate.length;
    //松手后可以放的图标数量
    let lastRecentListCount: number = visibleCount === 0 ? realMaxLenth : visibleCount;
    let realRecentWith = recentLayoutWidth;
    let computCount:number = Math.round((realRecentWith - this.mSmartDockStyleConfig
      .mDockPadding * 2 + spaceValue) / (this.mSmartDockStyleConfig.mListItemWidth + spaceValue));
    if (computCount > realMaxLenth) {
      computCount = realMaxLenth;
    }
    if (computCount < 1) {
      computCount = 1;
    }
    if (lastRecentListCount !== computCount) {
      HiSysEventUtil.reportDockAdjustSplitLine(lastRecentListCount, computCount);
    }
    return computCount;
  }

  public getRecentLayoutWidthUp(visibleCount: number, spaceValue: number): number {
    let recentLayoutWidthUp: number = this.mSmartDockStyleConfig
      .mDockPadding * 2 + visibleCount * (this.mSmartDockStyleConfig.mListItemWidth) +
      (visibleCount - 1) * spaceValue;
    return recentLayoutWidthUp;
  }

  public isPcOrPadLauncher(appInfo: DockItemInfo): boolean {
    return SettingsModel.getInstance().getDevice() !== CommonConstants.DEFAULT_DEVICE_TYPE &&
      appInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE;
  }

  public getAppIcon(appInfo: DockItemInfo): string | image.PixelMap {
    if (this.isPcOrPadLauncher(appInfo) && appInfo.abilityName === CommonConstants.APPCENTER_ABILITY) {
      return StyleConstants.DEFAULT_ALL_APP_IMAGE;
    } else if (this.isPcOrPadLauncher(appInfo) && appInfo.abilityName === CommonConstants.RECENT_ABILITY) {
      return StyleConstants.DEFAULT_TASK_IMAGE;
    } else {
      let icon: string | image.PixelMap = IconResourceManager.getInstance().getCachedCombIconSync(appInfo.bundleName,
        appInfo.moduleName, appInfo.abilityName, appInfo.appIndex, 'CombIcon_RecentDockModel');
      if (CheckEmptyUtils.isEmpty(icon)) {
        log.showWarn('get icon from getCombIcon');
        IconResourceManager.getInstance().getCombIcon(appInfo.bundleName, appInfo.moduleName, appInfo.abilityName,
        undefined, 'CombIcon_RecentDockModel')
          .then((image: string | image.PixelMap) => {icon = image})
          .catch((err: Error) => {log.showError('getCombIcon error error %{public}s', err.message);});
      }
      return icon;
    }
  }

  /**
   * 设置实际显示图标数量
   * @param recentListRotateLength 实际显示图标数量
   */
  public setRecentListRotateNum(recentListRotateNum: number): void {
    this.recentListRotateNum = recentListRotateNum;
  }

  /**
   * 获取实际显示图标数量
   * @returns 实际显示图标数量
   */
  public getRecentListRotateNum(): number {
    return this.recentListRotateNum;
  }

  /**
   * 更新可见数量
   * @param mVisibleCount
   * @param isOperateDb 是否入库
   */
  public updateVisibleCount(mVisibleCount: number, isOperateDb: boolean): void {
    this.mRecentCacheMgr.updateVisibleCount(mVisibleCount, isOperateDb);
  }

  /**
   * 获取visible count
   * @returns
   */
  public getVisibleCount(): number {
    return this.mRecentCacheMgr.getVisibleCount();
  }
}
