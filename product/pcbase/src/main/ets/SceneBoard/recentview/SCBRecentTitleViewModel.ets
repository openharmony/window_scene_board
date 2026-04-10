/**
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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
import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  commonBundleManager,
  IconResourceManager,
  ResourceManager,
} from '@ohos/frameworkwrapper';
import {
  NeedRenderShowRecentTitle,
  NeedRenderTitleViewAlpha,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneResourceManager
} from '@ohos/windowscene';
import { AppItemInfo, AppModel, RecentMissionsModel, launcherAbilityManager } from '@ohos/launchercommon';
import { bundleManager } from '@kit.AbilityKit';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import measure from '@ohos.measure';
import { image } from '@kit.ImageKit';

const TAG = 'SCBRecentTitleViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
const MIN_TEXT_HOVERED: string = 'AAAAA';
const MIN_TEXT: string = 'AAAAAA';

export class SCBRecentTitleViewModel {
  public static setRecentTitlePos(sceneContainerSession: SCBSceneContainerSession, left: number, top: number): void {
    if (!sceneContainerSession) {
      return;
    }
    let recentTitleTop = top - SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN -
    SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE;
    log.showDebug(`set recent title (${sceneContainerSession.getName()}) position from \
      (${sceneContainerSession.needRenderRecentTitleTranslate.translateX}:
      ${sceneContainerSession.needRenderRecentTitleTranslate.translateY}) to (${left}: ${recentTitleTop})`);
    sceneContainerSession.needRenderRecentTitleTranslate.translateX = left;
    sceneContainerSession.needRenderRecentTitleTranslate.translateY = recentTitleTop;
  }

  public static setRecentTitleWidth(sceneContainerSession: SCBSceneContainerSession, recentScale: number): void {
    if (sceneContainerSession.dividerParam.isSplitRecentPair) {
      SCBRecentTitleViewModel.setSplitRecentTitleWidth(sceneContainerSession, recentScale);
      return;
    }
    SCBRecentTitleViewModel.setNormalRecentTitleWidth(sceneContainerSession, recentScale);
  }

  public static setNormalRecentTitleWidth(sceneContainerSession: SCBSceneContainerSession, recentScale: number): void {
    let titleWidth = SCBRecentTitleViewModel.getNormalRecentTitleWidth(sceneContainerSession, recentScale);
    sceneContainerSession.needRenderRecentTitleWidth.width = titleWidth;
  }

  public static getNormalRecentTitleWidth(sceneContainerSession: SCBSceneContainerSession,
    recentScale: number): number {
    let sceneContainerWidth = sceneContainerSession.getSceneContainerWidth();
    let recentTitleWidth: number = sceneContainerWidth * recentScale;
    return Math.max(recentTitleWidth, SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH);
  }

  public static setSplitRecentTitleWidth(sceneContainerSession: SCBSceneContainerSession, recentScale: number): void {
    let priWidth = SCBRecentTitleViewModel.getSplitRecentTitleWidth(sceneContainerSession.primarySession, recentScale);
    let secWidth =
      SCBRecentTitleViewModel.getSplitRecentTitleWidth(sceneContainerSession.secondarySession, recentScale);
    if (sceneContainerSession.isSplitPrimaryMode()) {
      sceneContainerSession.needRenderRecentTitleWidth.primaryWidth = priWidth;
      sceneContainerSession.needRenderRecentTitleWidth.secondaryWidth = secWidth;
    } else if (sceneContainerSession.isSplitSecondaryMode()) {
      sceneContainerSession.needRenderRecentTitleWidth.primaryWidth = secWidth;
      sceneContainerSession.needRenderRecentTitleWidth.secondaryWidth = priWidth;
    }
    if (sceneContainerSession.dividerParam.isExpandUpDownSplit()) {
      sceneContainerSession.needRenderRecentTitleWidth.primaryWidth /= 2;
      sceneContainerSession.needRenderRecentTitleWidth.secondaryWidth /= 2;
    }
  }

  public static getSplitRecentTitleWidth(sceneSession: SCBSceneSession | null, recentScale: number): number {
    if (!sceneSession) {
      return 0;
    }
    let recentTitleWidth = sceneSession.currRect.width.getVp() * recentScale;
    return Math.max(recentTitleWidth, SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH);
  }

  public static getRecentTitleAppNameId(persistentId: number, bundleName: string): string {
    return `${persistentId}${SCBRecentStyleConstants.RECENT_VIEW_TITLE}_Text_${bundleName}`;
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
      SCBRecentTitleViewModel.getAppInfoFromCache(appInfoFromCache, appInfo);
      return appInfo;
    }
    let appInfoFromBms = await commonBundleManager.getAbilityInfoByAbilityName(sceneInfo.bundleName,
      sceneInfo.abilityName);
    if (!CheckEmptyUtils.isEmpty(appInfoFromBms)) {
      SCBRecentTitleViewModel.getAppInfoFromBms(appInfoFromBms as bundleManager.AbilityInfo, appInfo);
      return appInfo;
    }
    if (ResourceManager.getInstance().isSCBInnerModule(sceneInfo.bundleName, sceneInfo.moduleName)) {
      return appInfo;
    }
    let recentAbilityInfo: bundleManager.AbilityInfo | null = await RecentMissionsModel.getInstance()
      .getHapAbilityInfoAsync(sceneInfo.bundleName, sceneInfo.moduleName)
    if (recentAbilityInfo) {
      SCBRecentTitleViewModel.getAppInfoFromHapAbility(recentAbilityInfo, appInfo);
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
      return await SCBRecentTitleViewModel.getRecentAppInfo(session.sceneInfo);
    } catch (e) {
      log.showError(`getSession error: ${JSON.stringify(e)}`);
    }

    return null;
  }

  private static async getSceneIconByPersistentId(persistentId: number,
    sceneContainerSession: SCBSceneContainerSession): Promise<image.PixelMap> {
    let icon = SCBSceneResourceManager.getInstance().getSessionIconCache(persistentId);
    log.showInfo('getSceneInfoIconByPersistentId');
    return icon;
  }

  private static async updateIcon(appInfo: AppItemInfo, icon: string | PixelMap | Resource, persistentId: number,
    iconCallback: (image: string | PixelMap | Resource) => void,
    sceneContainerSession: SCBSceneContainerSession): Promise<void> {
    if (CheckEmptyUtils.checkStrIsEmpty(appInfo.bundleName)) {
      log.showError('bundle name is empty, return now');
      return;
    }

    let sessionIcon = await SCBRecentTitleViewModel.getSceneIconByPersistentId(persistentId, sceneContainerSession);
    if (sessionIcon) {
      log.showInfo(`start update icon of ${appInfo.bundleName}/${appInfo.moduleName} from scene`);
      iconCallback(sessionIcon);
      return;
    }
    let image = await IconResourceManager.getInstance().getCombIcon(appInfo.bundleName, appInfo.moduleName,
      appInfo.abilityName, appInfo.appIndex, 'CombIcon_RecentTitleViewModel');
    if (CheckEmptyUtils.isEmpty(image)) {
      log.showWarn(`start update icon of ${appInfo.bundleName}/${appInfo.moduleName} from cache is empty!`);
    } else {
      log.showInfo(`start update icon of ${appInfo.bundleName}/${appInfo.moduleName} from cache success`);
      iconCallback(image);
    }
  }

  private static getSceneInfoLabelByPersistentId(persistentId: number,
    sceneContainerSession: SCBSceneContainerSession): string | undefined {
    let session: SCBSceneSession | null = null;
    const primarySession = sceneContainerSession.primarySession;
    const secondarySession = sceneContainerSession.secondarySession;
    if (persistentId === secondarySession?.session.persistentId) {
      session = secondarySession;
    } else {
      session = primarySession;
    }
    return session?.sceneInfo.label;
  }

  /**
   * 应用分身在使用setMissionLabel需要追加appIndex后缀
   * @param appInfo
   * @param label
   * @returns
   */
  private static appendAppIndex(appInfo: AppItemInfo, label: string): string {
    let appendStr: string = '';
    if (appInfo?.appIndex && appInfo?.appIndex > 0) {
      appendStr = String(appInfo?.appIndex);
    }
    return label + appendStr;
  }

  private static updateName(appInfo: AppItemInfo, name: string, persistentId: number,
    nameCallback: (name: string) => void, sceneContainerSession: SCBSceneContainerSession): void {
    if (CheckEmptyUtils.checkStrIsEmpty(appInfo.bundleName)) {
      log.showError('bundle name is empty, return now');
      return;
    }
    // 优先取SCBSceneInfo里的label，该数据支持独立恢复
    const label = SCBRecentTitleViewModel.getSceneInfoLabelByPersistentId(persistentId, sceneContainerSession);
    if (label) {
      log.showInfo(`start update app title name of SCBSceneInfo, ${persistentId}`);
      nameCallback(SCBRecentTitleViewModel.appendAppIndex(appInfo, label));
      return;
    }
    const sessionLabel: string = SCBSceneResourceManager.getInstance().getSessionLabelCache(persistentId);
    if (sessionLabel) {
      log.showInfo(`start update app title name of persistendtId, ${persistentId}`);
      nameCallback(SCBRecentTitleViewModel.appendAppIndex(appInfo, sessionLabel));
      return;
    }
    let appLabelId: number | undefined = appInfo.appLabelId;
    ResourceManager.getInstance().getAppNameWithCache(appLabelId, appInfo.bundleName,
      appInfo.moduleName, appInfo.appName, nameCallback, appInfo.appIndex);
    log.showInfo(`start update name of ${appInfo.bundleName}/${appInfo.moduleName} name:${name} from cache`);
  }

  public static updateIconAndName(appInfo: AppItemInfo | null,
    icon: string | PixelMap | Resource,
    name: string,
    persistentId: number,
    iconCallback: (image: string | PixelMap | Resource) => void,
    nameCallback: (name: string) => void,
    sceneContainerSession: SCBSceneContainerSession): void {
    if (!appInfo) {
      return;
    }
    // appIndex 分身应用使用的0-5是有效值，大于1000的归于0
    if (appInfo.appIndex && appInfo.appIndex > 5) {
      appInfo.appIndex = 0;
    }
    SCBRecentTitleViewModel.updateIcon(appInfo, icon, persistentId, iconCallback, sceneContainerSession);
    SCBRecentTitleViewModel.updateName(appInfo, name, persistentId, nameCallback, sceneContainerSession);
  }

  public static getSecondaryMinNameWidth(containerSession: SCBSceneContainerSession,
    sceneSession: SCBSceneSession | null | undefined, isMouseCross: boolean, fontSize: string): number {
    if (!containerSession) {
      log.showError('[getSecondaryWidth]containerSession is null, just return');
      return 0;
    }
    const text = SCBRecentTitleViewModel.checkIsHovered(containerSession, sceneSession, isMouseCross) ?
      MIN_TEXT_HOVERED : MIN_TEXT;
    return SCBRecentTitleViewModel.getTextWidth(text, fontSize);
  }

  public static getCloseWidth(containerSession: SCBSceneContainerSession,
    sceneSession: SCBSceneSession | null | undefined, isMouseCross: boolean): number {
    if (!containerSession || !sceneSession) {
      log.showError('[getCloseWidth]containerSession or sceneSession is null, just return');
      return 0;
    }
    return SCBRecentTitleViewModel.checkIsHovered(containerSession, sceneSession, isMouseCross) ?
      (SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_WIDTH +
      SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_LEFT_MARGIN) : 0;
  }

  public static checkIsHovered(containerSession: SCBSceneContainerSession,
    sceneSession: SCBSceneSession | null | undefined, isMouseCross: boolean): boolean {
    if (!containerSession || !sceneSession) {
      log.showError('[checkIsHovered]containerSession or sceneSession is null, just return');
      return false;
    }
    return containerSession.needRenderRecentHoverState.hoverState && sceneSession.hoverState && !isMouseCross;
  }

  public static getTextWidth(text: string, fontSize: string): number {
    if (text === undefined || text === '') {
      return 0;
    }
    const width = Math.round(px2vp(measure.measureText({
      textContent: text,
      fontSize: fontSize,
      overflow: TextOverflow.Ellipsis,
      maxLines: SCBRecentStyleConstants.DEFAULT_NAME_LINE
    })));
    log.showInfo(`getTextWidth ${text}, ${width}`);
    return width;
  }

  public static getTitleVisibility(needRenderShowRecentTitle: NeedRenderShowRecentTitle): Visibility {
    return needRenderShowRecentTitle.showRecentTitle ? Visibility.Visible : Visibility.Hidden;
  }

  public static buildRecentTitle(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(true);
  }

  public static destroyRecentTitle(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
  }

  public static showRecentTitle(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(1);
  }

  public static hideRecentTitle(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
  }
}
