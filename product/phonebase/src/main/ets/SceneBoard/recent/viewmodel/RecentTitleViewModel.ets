/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
  NeedRenderPos,
  NeedRenderScale,
  RecentsStyleConstants,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SceneInfoAdapterUtil
} from '@ohos/windowscene';
import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { commonBundleManager, DeviceHelper, IconResourceManager, ResourceManager } from '@ohos/frameworkwrapper';
import { AppItemInfo, AppModel, RecentMissionsModel, launcherAbilityManager } from '@ohos/launchercommon';
import { bundleManager } from '@kit.AbilityKit';
import { RecentsStyleConfig } from '@ohos/recents';
import { RecentLayoutManager } from '../common/RecentLayoutManager';
import { RecentStyle } from '../RecentStyle';
import { curves } from '@kit.ArkUI';
import systemParameter from '@ohos.systemParameterEnhance';
import { recentRuntimeInstance } from '../scenepanel/recentpanel/RecentRuntimeModel';
import { ArrayList } from '@kit.ArkTS';
import { RecentIconConstants } from '../common/constants/RecentIconConstants';
import { AppCastUtil } from '../common/AppCastUtil';
import { fontScaleManager, FontScaleState } from '@ohos/systemuicommon';

const TAG = 'RecentTitleViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentTitleViewModel {
  public static readonly INIT_RECENT_DATA_DELAY = 30;
  private static isNewStyle = systemParameter.getSync('sceneboard.isNewStyle', 'true') === 'true';
  private screenProperty: SCBScreenProperty = new SCBScreenProperty();
  public static mAppItemMap: Map<number, ArrayList<AppItemInfo | null>> = new Map();
  public static mIconAndNameMap: Map<number, ArrayList<IconAndNameData>> = new Map();
  public fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  public maxWidth: number = 0;
  public subPrimaryIconImage?: Resource;
  public subSecondaryIconImage?: Resource;
  public primaryIconId: string = '';
  public secondaryIconId: string = '';
  public primaryRecentTitleInfo: RecentTitleInfo = new RecentTitleInfo();
  public secondaryRecentTitleInfo: RecentTitleInfo = new RecentTitleInfo();


  public constructor(screenProperty: SCBScreenProperty,
    primaryRecentTitleInfo: RecentTitleInfo, secondaryRecentTitleInfo: RecentTitleInfo) {
    this.screenProperty = screenProperty;
    this.primaryRecentTitleInfo = primaryRecentTitleInfo;
    this.secondaryRecentTitleInfo = secondaryRecentTitleInfo;
  }

  public init(): void {
    this.fontScaleState = fontScaleManager.getSysFontScaleState();
    this.maxWidth = 0;
    this.primaryIconId = '';
    this.secondaryIconId = '';
    this.secondaryIconId = '';
  }

  public static async initRecentDataList(screenProperty: SCBScreenProperty): Promise<void> {
    for (let i = recentRuntimeInstance.notRemovingSessionList.length - 1; i >= recentRuntimeInstance.leftBoundaryIndex;
      i--) {
      let sceneContainerSession = recentRuntimeInstance.notRemovingSessionList[i];
      if (!sceneContainerSession) {
        return;
      }
      // 初始化获取appInfo
      RecentTitleViewModel.initAppInfo(sceneContainerSession, screenProperty);
      // 初始化锁状态
      RecentTitleViewModel.initLockIconStatus(sceneContainerSession);
    }
  }

  private static async initAppInfo(sceneContainerSession: SCBSceneContainerSession,
    screenProperty: SCBScreenProperty): Promise<void> {
    let primarySession = sceneContainerSession.getFirstSceneSession();
    let secondarySession =  sceneContainerSession.getSecondSceneSession();
    // 初始化获取appInfo
    let primaryAppInfo = await RecentTitleViewModel.getSession(primarySession);
    let secondaryAppInfo = await RecentTitleViewModel.getSession(secondarySession);
    let appInfoList: ArrayList<AppItemInfo | null> = new ArrayList();
    appInfoList.add(primaryAppInfo);
    appInfoList.add(secondaryAppInfo);
    RecentTitleViewModel.mAppItemMap.set(sceneContainerSession.containerId, appInfoList);
    let iconAndNameDataList: ArrayList<IconAndNameData> = new ArrayList();
    // 初始化获取图标和名称
    let primaryIconAndNameData = new IconAndNameData();
    if (primaryAppInfo) {
      RecentTitleViewModel.updateIconAndName(primaryAppInfo, primarySession,
        (image: string | PixelMap | Resource): void => {
          primaryIconAndNameData.icon = image
        },
        (name: string): void => {
          primaryIconAndNameData.name = name
        }
      );
      let index: number = primaryAppInfo?.appIndex === undefined ? 0 : primaryAppInfo?.appIndex;
      primaryIconAndNameData.subIconImage = RecentIconConstants.APP_INDEX_RESOURCE_MAP.get(index);
      primaryIconAndNameData.iconId = RecentTitleViewModel.getIconId(primaryAppInfo?.bundleName);
      primaryIconAndNameData.maxWidth =
        RecentLayoutManager.getAppNameMaxWidth(screenProperty, sceneContainerSession.secondarySession !== null);
    }
    let secondaryIconAndNameData = new IconAndNameData();
    if (secondaryAppInfo) {
      RecentTitleViewModel.updateIconAndName(secondaryAppInfo, secondarySession,
        (image: string | PixelMap | Resource): void => {
          secondaryIconAndNameData.icon = image
        },
        (name: string): void => {
          secondaryIconAndNameData.name = name
        }
      );
      let index: number = secondaryAppInfo?.appIndex === undefined ? 0 : secondaryAppInfo?.appIndex;
      secondaryIconAndNameData.subIconImage = RecentIconConstants.APP_INDEX_RESOURCE_MAP.get(index);
      secondaryIconAndNameData.iconId = RecentTitleViewModel.getIconId(secondaryAppInfo?.bundleName);
    }
    iconAndNameDataList.add(primaryIconAndNameData);
    iconAndNameDataList.add(secondaryIconAndNameData);
    RecentTitleViewModel.mIconAndNameMap.set(sceneContainerSession.containerId, iconAndNameDataList);
  }

  /**
   * 初始化锁状态
   * @param sceneContainerSession
   */
  private static initLockIconStatus(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    if (sceneContainerSession.secondarySession) {
      sceneContainerSession.isAppLockedForbidDelete = false;
      sceneContainerSession.needRenderLockIconScale.setLockIconScale(0.5);
      sceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity(0);
      return;
    }
    if (sceneContainerSession.primarySession?.sceneInfo?.isLockedInRecent) {
      sceneContainerSession.isAppLockedForbidDelete = true;
      sceneContainerSession.needRenderLockIconScale.setLockIconScale(1);
      sceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity(1);
    }
    if (!sceneContainerSession.primarySession?.sceneInfo?.isLockedInRecent) {
      sceneContainerSession.isAppLockedForbidDelete = false;
      sceneContainerSession.needRenderLockIconScale.setLockIconScale(0.5);
      sceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity(0);
    }
  }

  private static getAppInfoFromCache(appInfoFromCache: AppItemInfo, appInfo: AppItemInfo): void {
    appInfo.appName = appInfoFromCache.appName as string;
    let cacheAppIconId = appInfoFromCache.appIconId as number;
    if (cacheAppIconId === 0) {
      cacheAppIconId = appInfoFromCache.applicationIconId as number;
    }
    appInfo.appIconId = cacheAppIconId;
    let cacheAppLabelId = appInfoFromCache.appLabelId as number;
    if (cacheAppLabelId === 0) {
      cacheAppLabelId = appInfoFromCache.applicationLabelId as number;
    }
    appInfo.appLabelId = cacheAppLabelId;
    log.showInfo(`(${appInfo.appName}) from cache, iconId = ${appInfo.appIconId}, LabelId = ${appInfo.appLabelId}`);
    return;
  }

  public static getIconId(bundleName: string): string {
    return TAG + '_Image_' + bundleName;
  }

  public static getFontScaleState(fontScaleState: FontScaleState): string {
    return (fontScaleState.getRecentScaleSize(RecentsStyleConfig.getInstance().mAppNameSize));
  }

  private static getAppInfoFromBms(appInfoFromBms: bundleManager.AbilityInfo, appInfo: AppItemInfo): void {
    appInfo.appName = appInfoFromBms.name as string;
    let bmsAppIconId = appInfoFromBms.iconId as number;
    if (bmsAppIconId === 0) {
      bmsAppIconId = appInfoFromBms.applicationInfo.iconId as number;
    }
    appInfo.appIconId = bmsAppIconId;
    let bmsAppLabelId = appInfoFromBms.labelId as number;
    if (bmsAppLabelId === 0) {
      bmsAppLabelId = appInfoFromBms.applicationInfo.labelId as number;
    }
    appInfo.appLabelId = bmsAppLabelId;
    log.showInfo(`(${appInfo.appName}) from bms, iconId = ${appInfo.appIconId}, LabelId = ${appInfo.appLabelId}`);
  }

  private static getAppInfoFromHapAbility(recentAbilityInfo: bundleManager.AbilityInfo, appInfo: AppItemInfo): void {
    appInfo.appName = recentAbilityInfo.name;
    let recentAppLabelId = recentAbilityInfo.labelId;
    if (recentAppLabelId === 0) {
      recentAppLabelId = recentAbilityInfo.applicationInfo.labelId;
    }
    appInfo.appLabelId = recentAppLabelId;
    let recentAppIconId = recentAbilityInfo.iconId;
    if (recentAppIconId === 0) {
      recentAppIconId = recentAbilityInfo.applicationInfo.iconId;
    }
    appInfo.appIconId = recentAppIconId;
    log.showInfo(`(${appInfo.appName}) from hap, iconId = ${appInfo.appIconId}, LabelId = ${appInfo.appLabelId}`);
  }

  public static async getRecentAppInfo(sceneInfo: SCBSceneInfo | undefined): Promise<AppItemInfo> {
    let appInfo = new AppItemInfo();
    if (CheckEmptyUtils.isEmpty(sceneInfo)) {
      log.showError('sceneInfo is empty.');
      return appInfo;
    }
    sceneInfo = sceneInfo as SCBSceneInfo;
    appInfo.bundleName = sceneInfo.bundleName;
    appInfo.abilityName = sceneInfo.abilityName;
    appInfo.moduleName = sceneInfo.moduleName;
    appInfo.appIndex = sceneInfo.appIndex;
    let appInfoFromCache = AppModel.getInstance()
      .getAppInfoByBundleNameAndAbility(sceneInfo.bundleName, sceneInfo.abilityName);
    if (appInfoFromCache) {
      RecentTitleViewModel.getAppInfoFromCache(appInfoFromCache, appInfo);
      return appInfo;
    }
    let appInfoFromBms = await commonBundleManager.getAbilityInfoByAbilityName(sceneInfo.bundleName,
      sceneInfo.abilityName);
    if (!CheckEmptyUtils.isEmpty(appInfoFromBms)) {
      RecentTitleViewModel.getAppInfoFromBms(appInfoFromBms as bundleManager.AbilityInfo, appInfo);
      return appInfo;
    }
    if (ResourceManager.getInstance().isSCBInnerModule(sceneInfo.bundleName, sceneInfo.moduleName)) {
      return appInfo;
    }
    let recentAbilityInfo: bundleManager.AbilityInfo | null = await RecentMissionsModel.getInstance()
      .getHapAbilityInfoAsync(sceneInfo.bundleName, sceneInfo.moduleName)
    if (recentAbilityInfo) {
      RecentTitleViewModel.getAppInfoFromHapAbility(recentAbilityInfo, appInfo);
      return appInfo;
    }
    appInfo.appLabelId = await launcherAbilityManager.getAppLabelId(appInfo.bundleName);
    if (!CheckEmptyUtils.isEmpty(appInfo.appLabelId)) {
      log.info(`get lable from launcherAbilityManager ${appInfo.bundleName} ${appInfo.appLabelId}`);
      return appInfo;
    }
    return appInfo;
  }

  public static async getSession(session: SCBSceneSession | null): Promise<AppItemInfo | null> {
    if (!session) {
      return null;
    }

    try {
      return await RecentTitleViewModel.getRecentAppInfo(session.sceneInfo);
    } catch (e) {
      log.showError(`getSession error: ${JSON.stringify(e)}`);
    }

    return null;
  }

  public static getTitlePosition(session: SCBSceneContainerSession, property: SCBScreenProperty,
                                 scale: NeedRenderScale, pos: NeedRenderPos): Position {
    if (!session) {
      return {
        x: pos.posX,
        y: pos.posY
      };
    }
    let isFloat = session.isFloat;
    let height = isFloat ? session.height.getVp() : px2vp(property.height);
    let width = isFloat ? session.width.getVp() : px2vp(property.width);
    let offsetX = width * (1 - scale.scaleX) / 2;
    let offsetY = height * (1 - scale.scaleY) / 2;
    offsetY -= RecentsStyleConfig.getInstance().mAppIconSize;
    offsetY -= RecentStyle.VERTICAL_RECENT_TILE_BOTTOM_MARGIN;

    return {
      x: pos.posX + offsetX,
      y: pos.posY + offsetY
    };
  }

  public static getTitleId(tag: string, primaryAppInfo: AppItemInfo | null,
                           secondaryAppInfo: AppItemInfo | null): string {
    let id = `${tag}_Row`;
    if (primaryAppInfo) {
      id += `_${primaryAppInfo.bundleName}`;
    }
    if (secondaryAppInfo) {
      id += `_${secondaryAppInfo.bundleName}`;
    }
    return id;
  }

  private static async updateIcon(appInfo: AppItemInfo | null,
    iconCallback: (image: string | PixelMap | Resource) => void): Promise<void> {
    if (!appInfo || CheckEmptyUtils.checkStrIsEmpty(appInfo.bundleName)) {
      log.showError('bundle name is empty, return now');
      return;
    }
    if (ResourceManager.getInstance().isSCBInnerModule(appInfo.bundleName, appInfo.moduleName)) {
      ResourceManager.getInstance().getSCBInnerIcon(appInfo.moduleName, iconCallback,
        RecentsStyleConstants.DEFAULT_APP_ICON_IMAGE);
      log.showInfo(`start update icon of ${appInfo.bundleName}/${appInfo.moduleName} from scb inner`);
      return;
    }
    RecentTitleViewModel.checkAppIndex(appInfo);
    let missionIcon: PixelMap | undefined = AppCastUtil.getMissionIcon(appInfo);
    if (missionIcon) {
      log.showInfo(`start update icon of ${appInfo.bundleName}/${appInfo.moduleName} from AppResourceCache success`);
      iconCallback(missionIcon);
      return;
    }
    let image = await IconResourceManager.getInstance().getCombIcon(appInfo.bundleName, appInfo.moduleName,
      appInfo.abilityName, 0);
    if (CheckEmptyUtils.isEmpty(image)) {
      log.showWarn(`start update icon of ${appInfo.bundleName}/${appInfo.moduleName} from cache is empty!`);
    } else {
      log.showInfo(`start update icon of ${appInfo.bundleName}/${appInfo.moduleName} from cache success`);
      iconCallback(image);
    }
  }

  public static updateName(appInfo: AppItemInfo | null, sceneInfo: SCBSceneInfo,
    nameCallback: (name: string) => void): void {
    if (!appInfo || CheckEmptyUtils.checkStrIsEmpty(appInfo.bundleName)) {
      log.showError('bundle name is empty, return now');
      return;
    }
    if (ResourceManager.getInstance().isSCBInnerModule(appInfo.bundleName, appInfo.moduleName)) {
      ResourceManager.getInstance().getSCBInnerString(appInfo.moduleName, nameCallback);
      log.showInfo(`update name of ${appInfo.bundleName} from scb inner`);
      return;
    }
    RecentTitleViewModel.checkAppIndex(appInfo);
    let appLabelId: number | undefined = appInfo.appLabelId;
    let sceneInfoLabel = sceneInfo?.label;
    if (RecentTitleViewModel.updateNameFromCacheDirectly(appInfo, sceneInfoLabel, nameCallback)) {
      return;
    }
    RecentTitleViewModel.updateNameFromResourceManager(appInfo, sceneInfoLabel, appLabelId, nameCallback);
  }

  public static async updateFirstSessionName(sceneContainerSession: SCBSceneContainerSession,
    nameCallback: (name: string) => void): Promise<void> {
    let primarySession = sceneContainerSession.getFirstSceneSession();
    let primaryAppInfo: AppItemInfo | null = await RecentTitleViewModel.getSession(primarySession);
    RecentTitleViewModel.updateName(primaryAppInfo, primarySession?.sceneInfo, nameCallback);
  }

  public static async updateSecondSessionName(sceneContainerSession: SCBSceneContainerSession,
    nameCallback: (name: string) => void): Promise<void> {
    let secondSession = sceneContainerSession.getSecondSceneSession();
    let secondAppInfo: AppItemInfo | null = await RecentTitleViewModel.getSession(secondSession);
    RecentTitleViewModel.updateName(secondAppInfo, secondSession?.sceneInfo, nameCallback);
  }

  private static checkAppIndex(appInfo: AppItemInfo | SCBSceneInfo): void {
    // appIndex 分身应用使用的0-5是有效值，大于1000的归于0
    if (appInfo.appIndex && appInfo.appIndex > RecentIconConstants.MAX_APP_INDEX) {
      appInfo.appIndex = 0;
    }
  }

  private static updateNameFromCacheDirectly(appInfo: AppItemInfo, sceneInfoLabel: string,
    nameCallback: (name: string) => void): boolean {
    // 如果sceneInfoLabel不为空，则为应用主动通过setMissionLabel设置了显示名称，需优先使用
    let appName: string = !CheckEmptyUtils.isEmpty(sceneInfoLabel) ? sceneInfoLabel :
    IconResourceManager.getInstance().getCachedIconNameSync(appInfo.bundleName,
      appInfo.moduleName, appInfo.abilityName);
    if (appName) {
      let appInfoIndex: undefined | number | string = '';
      if (appInfo.appIndex !== undefined) {
        appInfoIndex = appInfo.appIndex > 0 ? appInfo.appIndex : '';
      }
      nameCallback(`${appName}${appInfoIndex}`);
      log.showInfo(`update name of ${appInfo.bundleName} sceneInfoLabel:${sceneInfoLabel} appName:${appName} from cache`);
      return true;
    }
    return false;
  }

  private static updateNameFromResourceManager(appInfo: AppItemInfo, name: string, appLabelId: number | undefined,
    nameCallback: (name: string) => void) {
    ResourceManager.getInstance().getAppNameWithCache(appLabelId, appInfo.bundleName,
      appInfo.moduleName, appInfo.appName, nameCallback, appInfo.appIndex);
    log.showInfo(`start update name of ${appInfo.bundleName}/${appInfo.moduleName} name:${name} from ResourceManager`);
  }

  public static updateIconAndName(appInfo: AppItemInfo | null, sceneSession: SCBSceneSession,
    iconCallback: (image: string | PixelMap | Resource) => void,
    nameCallback: (name: string) => void): void {
    RecentTitleViewModel.updateIcon(appInfo, iconCallback);
    RecentTitleViewModel.updateName(appInfo, sceneSession?.sceneInfo, nameCallback);
  }

  public static async updateIconForSCBSceneInfo(sceneInfo: SCBSceneInfo | null,
    iconCallback: (image: string | PixelMap | Resource) => void): Promise<void>  {
    if (!sceneInfo) {
      return;
    }
    let appInfo = await RecentTitleViewModel.getRecentAppInfo(sceneInfo);
    await RecentTitleViewModel.updateIcon(appInfo, iconCallback);
  }

  public static async updateNameForSCBSceneInfo(sceneInfo: SCBSceneInfo | null,
    nameCallback: (name: string) => void): Promise<void>  {
    if (!sceneInfo) {
      return;
    }
    let appInfo = await RecentTitleViewModel.getRecentAppInfo(sceneInfo);
    await RecentTitleViewModel.updateName(appInfo, sceneInfo, nameCallback);
  }

  public static playTitleDisAppearAnimation(containerSession: SCBSceneContainerSession,
    isDelayUnClearableAnimate: boolean = false): void {
    if (!containerSession) {
      log.showError('[TitleDisAppear]sceneSession or sceneInfo is null, just retrun');
      return;
    }
    let animationNum = containerSession.getTransitionCount();
    let param: AnimateParam = {
      curve: curves.springMotion(0.2, 1, 0),
      onFinish: () => {
        if (animationNum === containerSession.getTransitionCount()) {
          containerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
        }
      }
    };
    if (isDelayUnClearableAnimate) {
      param.delay = 450;
    }
    if (!RecentTitleViewModel.isNewStyle) {
      param.curve = Curve.Linear;
      param.duration = 150;
    }
    animateTo(param, () => {
      containerSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
    })
  }

  public static exit(): void {
    RecentTitleViewModel.mAppItemMap.clear();
    RecentTitleViewModel.mIconAndNameMap.clear();
  }

  public async initRecentData(sceneContainerSession: SCBSceneContainerSession): Promise<void> {
    let appItemInfoList = RecentTitleViewModel.mAppItemMap.get(sceneContainerSession.containerId);
    let iconAndNameDataList = RecentTitleViewModel.mIconAndNameMap.get(sceneContainerSession.containerId);
    if (appItemInfoList && iconAndNameDataList && iconAndNameDataList[0].icon) {
      this.primaryRecentTitleInfo.setAppInfo(appItemInfoList[0]);
      this.secondaryRecentTitleInfo.setAppInfo(appItemInfoList[1]);
      if (appItemInfoList[0]) {
        this.primaryRecentTitleInfo.setIcon(iconAndNameDataList[0].icon);
        this.primaryRecentTitleInfo.setName(iconAndNameDataList[0].name);
        this.subPrimaryIconImage = iconAndNameDataList[0].subIconImage;
        this.primaryIconId = iconAndNameDataList[0].iconId;
        this.maxWidth = iconAndNameDataList[0].maxWidth;
        log.showInfo(`init name ${iconAndNameDataList[0].name} from mIconAndNameMap`);
      }
      if (appItemInfoList[1]) {
        this.secondaryRecentTitleInfo.setIcon(iconAndNameDataList[1].icon);
        this.secondaryRecentTitleInfo.setName(iconAndNameDataList[1].name);
        this.subSecondaryIconImage = iconAndNameDataList[1].subIconImage;
        this.secondaryIconId = iconAndNameDataList[1].iconId;
      }
      return;
    }
    let primaryAppInfo = await RecentTitleViewModel.getSession(sceneContainerSession.getFirstSceneSession());
    let secondaryAppInfo = await RecentTitleViewModel.getSession(sceneContainerSession.getSecondSceneSession());
    this.primaryRecentTitleInfo.setAppInfo(primaryAppInfo);
    this.secondaryRecentTitleInfo.setAppInfo(secondaryAppInfo);
    this.maxWidth =
      RecentLayoutManager.getAppNameMaxWidth(this.screenProperty, sceneContainerSession.secondarySession !== null)
    this.updateIconAndName(sceneContainerSession);
    this.initSubIconImageAndIconId(primaryAppInfo, secondaryAppInfo);
  }

  public async updateRecentData(sceneContainerSession: SCBSceneContainerSession): Promise<void> {
    let primaryAppInfo = await RecentTitleViewModel.getSession(sceneContainerSession.getFirstSceneSession());
    let secondaryAppInfo = await RecentTitleViewModel.getSession(sceneContainerSession.getSecondSceneSession());
    this.primaryRecentTitleInfo.setAppInfo(primaryAppInfo);
    this.secondaryRecentTitleInfo.setAppInfo(secondaryAppInfo);
    this.updateIconAndName(sceneContainerSession);
    this.initSubIconImageAndIconId(primaryAppInfo, secondaryAppInfo);
  }

  private initSubIconImageAndIconId(primaryAppInfo: AppItemInfo | null, secondaryAppInfo: AppItemInfo | null): void {
    if (primaryAppInfo) {
      const index: number = primaryAppInfo?.appIndex === undefined ? 0 : primaryAppInfo?.appIndex;
      this.subPrimaryIconImage = RecentIconConstants.APP_INDEX_RESOURCE_MAP.get(index);
      this.primaryIconId = RecentTitleViewModel.getIconId(primaryAppInfo?.bundleName);
    }
    if (secondaryAppInfo) {
      const index: number = secondaryAppInfo?.appIndex === undefined ? 0 : secondaryAppInfo?.appIndex;
      this.subSecondaryIconImage = RecentIconConstants.APP_INDEX_RESOURCE_MAP.get(index);
      this.secondaryIconId = RecentTitleViewModel.getIconId(secondaryAppInfo?.bundleName);
    }
  }

  private updateIconCallback(image: string | PixelMap | Resource, isPrimarySession: boolean): void {
    if (isPrimarySession) {
      this.primaryRecentTitleInfo.setIcon(image);
    } else {
      this.secondaryRecentTitleInfo.setIcon(image);
    }
  }

  private updateNameCallback(name: string, isPrimarySession: boolean): void {
    if (CheckEmptyUtils.isEmpty(name)) {
      return;
    }
    if (isPrimarySession) {
      this.primaryRecentTitleInfo.setName(name);
    } else {
      this.secondaryRecentTitleInfo.setName(name);
    }
  }

  private updatePrimaryIconAndName(sceneContainerSession: SCBSceneContainerSession): void {
    RecentTitleViewModel.updateIconAndName(this.primaryRecentTitleInfo.appInfo,
      sceneContainerSession.getFirstSceneSession(),
      (image: string | PixelMap | Resource): void => this.updateIconCallback(image, true),
      (name: string): void => this.updateNameCallback(name, true)
    );
  }

  private updateSecondaryIconAndName(sceneContainerSession: SCBSceneContainerSession): void {
    RecentTitleViewModel.updateIconAndName(this.secondaryRecentTitleInfo.appInfo,
      sceneContainerSession.getSecondSceneSession(),
      (image: string | PixelMap | Resource): void => this.updateIconCallback(image, false),
      (name: string): void => this.updateNameCallback(name, false)
    );
  }

  private updateIconAndName(sceneContainerSession: SCBSceneContainerSession): void {
    this.updatePrimaryIconAndName(sceneContainerSession);
    this.updateSecondaryIconAndName(sceneContainerSession);
  }
}

class IconAndNameData {
  public icon: string | PixelMap | Resource = '';
  public name: string = '';
  public subIconImage?: Resource;
  public iconId: string = '';
  public maxWidth: number = 0;
}

@Observed
export class RecentTitleInfo {
  private _appInfo: AppItemInfo | null = null;
  private _icon: string | PixelMap | Resource = '';
  private _name: string = '';

  /**
   * Obtains the appInfo of the recent title .
   *
   * @returns Returns appInfo of the recent title
   */
  public get appInfo(): AppItemInfo | null {
    return this._appInfo;
  }

  /**
   * set recent title appInfo
   *
   * @param appInfo
   */
  public setAppInfo(appInfo: AppItemInfo | null): void {
    if (CommonUtils.equals(this._appInfo, appInfo)) {
      return;
    }
    this._appInfo = appInfo;
  }

  /**
   * Obtains the icon of the recent title .
   *
   * @returns Returns icon of the recent title
   */
  public get icon(): string | PixelMap | Resource {
    return this._icon;
  }

  /**
   * set recent title icon
   *
   * @param icon
   */
  public setIcon(icon: string | PixelMap | Resource = ''): void {
    if (CommonUtils.equals(this._icon, icon)) {
      return;
    }
    this._icon = icon;
  }

  /**
   * Obtains the name of the recent title .
   *
   * @returns Returns name of the recent title
   */
  public get name(): string {
    return this._name;
  }

  /**
   * set recent title name
   *
   * @param name
   */
  public setName(name: string = ''): void {
    if (CommonUtils.equals(this._name, name)) {
      return;
    }
    this._name = name;
  }
}