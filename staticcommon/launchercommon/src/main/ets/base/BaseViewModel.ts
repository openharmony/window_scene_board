/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import Prompt from '@ohos.promptAction';
import {
  LogDomain,
  LogHelper,
  StartType,
  CheckEmptyUtils,
  CommonUtils,
  SingleBase,
  SingleContext
} from '@ohos/basicutils';
import { ResourceManager, IconResourceManager, GraphicUtils, } from '@ohos/frameworkwrapper';
import { NumberConstants, Constants } from '@ohos/commonconstants';
import { SCBSceneMode, StartAbilityUtil } from '@ohos/windowscene';
import { AppModel } from '../model/AppModel';
import { AppStatus, BusinessType, CommonConstants } from '../constants/CommonConstants';
import { launcherAbilityManager, APP_LOCKED_ERROR_CODE } from '../abilitymanager/LauncherAbilityManager';
import { AtomicServiceAppModel } from '../model/AtomicServiceAppModel';
import { CloseAppManager } from '../manager/CloseAppManager';
import {
  AppItemInfo,
  DeliverUtil,
  DisposedEventManager,
  AppGalleryDownloadManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  AppInstallUtils,
  CardItemInfo,
  AppLockManager,
  FormLayoutCacheManager
} from '../TsIndex';
import image from '@ohos.multimedia.image';
import { FormRelationManager } from '../transformdata/FormRelationManager';
import LauncherBackupUtil from '../utils/LauncherBackupUtil';
import AppUpdateUtils from '../utils/AppUpdateUtils';

const TAG = 'BaseViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const KEY_NAME = 'name';

/**
 * 最大图标文件大小
 */
const MAX_DELIVERY_SIZE = 50 * 1024;

/**
 * Base class for view models.
 */
export class BaseViewModel extends SingleBase {
  public static singleName: string = 'BaseViewModel';
  protected mAppModel: AppModel;
  protected mAtomicServiceAppModel: AtomicServiceAppModel;
  protected mResourceManager: ResourceManager;
  private readonly listener: (appList: AppItemInfo[], event: string, bundleName: string, appIndex?: number) => void;

  protected constructor(ctx?: SingleContext) {
    super(ctx);
    this.mAppModel = AppModel.getInstance();
    this.mAtomicServiceAppModel = AtomicServiceAppModel.getInstance();
    this.mResourceManager = ResourceManager.getInstance();
    this.listener = this.appListChangeListener.bind(this);
  }


  /**
   * Start target ability
   *
   * @param bundleName target bundle name
   * @param abilityName target ability name
   */
  jumpTo(abilityName: string, bundleName: string, moduleName: string, params?: Map<string, Object>,
    screenId?: number): void {
    this.jumpToWithMode(SCBSceneMode.FULLSCREEN, abilityName, bundleName, moduleName, params, screenId);
  }

  /**
   * Start target ability to SplitScreen
   *
   * @param windowMode to window mode
   * @param bundleName target bundle name
   * @param abilityName target ability name
   */
  jumpToWithMode(windowMode: SCBSceneMode, abilityName: string, bundleName: string, moduleName: string,
    params?: Map<string, Object>, screenId?: number): void {
    if (DeliverUtil.isStartContainerApp(bundleName)) {
      this.startContainerApp(windowMode, abilityName, bundleName, moduleName, params, screenId);
      return;
    }
    if (DisposedEventManager.getInstance().getRuledBundleNamesMap().has(bundleName)) {
      Prompt.showToast({
        message: $r('app.string.wait_data_recover_toast')
      });
      return;
    }
    StartAbilityUtil.startLauncherAbilityWithMode(windowMode, abilityName, bundleName, moduleName, params, screenId);
  }

  public async startContainerApp(windowMode: SCBSceneMode, abilityName: string, bundleName: string, moduleName: string,
    params?: Map<string, Object>, screenId?: number): Promise<void> {
    let otherParams: Map<string, Object> = new Map();
    let icon = await this.getIconAndScale(abilityName, bundleName, moduleName);
    log.showInfo(`startContainerApp, icon.length = ${icon.length}, origin bundleName = ${bundleName}`);
    otherParams.set('realBundleName', bundleName);
    otherParams.set('realAbilityName', abilityName);
    otherParams.set('realModuleName', moduleName);
    otherParams.set('realAppIcon', icon);
    let newModuleName = DeliverUtil.DELIVER_APP_MODULE_NAME;
    let appItemInfo: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(bundleName);
    let itemInfo: AppItemInfo | GridLayoutItemInfo | undefined =
      appItemInfo ? appItemInfo : DeliverUtil.getAppItemByBundleName(bundleName);
    let installSource = DeliverUtil.getInstallSourceByIntent(itemInfo?.intent ?? '');
    let newBundleName = this.getTargetBundleName(installSource);
    let newAbilityName = (installSource === DeliverUtil.ABROAD_APP_PKG ?
      DeliverUtil.ABROAD_APP_APP_ABILITY_NAME : DeliverUtil.DELIVER_APP_ABILITY_NAME);
    log.showInfo(`newBundleName = ${newBundleName}, intent = ${itemInfo?.intent}, installSource = ${installSource}`);
    if (!DeliverUtil.verifyContainerAppIdentifier(newBundleName, 'startContainerApp')) {
      log.showWarn('verifyContainerAppIdentifier Failed');
      return;
    }
    StartAbilityUtil.startLauncherAbilityWithMode(windowMode, newAbilityName, newBundleName, newModuleName, params,
      screenId, otherParams);
  }

  private getTargetBundleName(installSource: string): string {
    let newBundleName: string = '';
    if (installSource === DeliverUtil.ABROAD_APP_PKG) {
      newBundleName = AppModel.getInstance().getAppInfoByBundleName(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL) ?
        DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL : DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME;
    } else {
      newBundleName = AppModel.getInstance().getAppInfoByBundleName(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL) ?
        DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL : DeliverUtil.DELIVER_APP_BUNDLE_NAME;
    }
    log.showInfo(`getTargetBundleName, newBundleName = ${newBundleName}`);
    return newBundleName;
  }

  private async getIconAndScale(abilityName: string, bundleName: string, moduleName: string): Promise<string> {
    try {
      let imagePixelMap: image.PixelMap =
        IconResourceManager.getInstance().getCachedCombIconSync(bundleName, moduleName, abilityName);
      if (!imagePixelMap) {
        return '';
      }
      const size = imagePixelMap?.getImageInfoSync().size;
      if (!size) {
        log.showError('imagePixelMap get imageInfo error');
        return '';
      }
      // 部分应用编码后超过50k，统一压缩为0.75，144*144大小
      let deliverScale = 0.75;
      if (size.width > deliverScale * Constants.APP_ICON_STANDARD_WIDTH &&
        size.height > deliverScale * Constants.APP_ICON_STANDARD_HEIGHT) {
        const scaleX: number = Constants.APP_ICON_STANDARD_WIDTH / size.width * deliverScale;
        const scaleY: number = Constants.APP_ICON_STANDARD_HEIGHT / size.height * deliverScale;
        await imagePixelMap.scale(scaleX, scaleY);
      }
      let iconStr: string = await GraphicUtils.changePixelToBase64(imagePixelMap);
      if (iconStr.length >= MAX_DELIVERY_SIZE) {
        log.showError('icon too large not send icon, length = %{public}d', iconStr.length);
        // 对于依然超出50k的图片，再次压缩0.9
        deliverScale = 0.9;
        await imagePixelMap.scale(deliverScale, deliverScale);
        iconStr = await GraphicUtils.changePixelToBase64(imagePixelMap);
      }
      const finalSize = imagePixelMap?.getImageInfoSync().size;
      log.showInfo('getIconAndScale size=[%{public}d, %{public}d], iconStr=%{public}d', finalSize.width,
        finalSize.height, iconStr.length);
      return iconStr;
    } catch (err) {
      log.showError('getIconAndScale message err  %{public}s', err?.message);
      return '';
    }
  }

  /**
   * start form config ability.
   *
   * @param bundleName
   * @param abilityName
   */
  jumpToForm(abilityName: string, bundleName: string, moduleName: string, cardId: string,
    isFromOuterMenu: boolean = false): void {
    CloseAppManager.getInstance().setStartAppType(StartType.CARD, cardId, undefined, undefined, bundleName);
    StartAbilityUtil.startAbilityFormEdit(abilityName, bundleName, moduleName, cardId, isFromOuterMenu);
  }

  /**
   * Start launcher settings page.
   */
  jumpToSetting(): void {
    this.jumpTo(CommonConstants.SETTING_ABILITY, CommonConstants.LAUNCHER_BUNDLE, CommonConstants.SETTING_MODULE);
  }

  /**
   * Uninstall target app by bundle name.
   *
   * @param uninstallBundleName bundle name to uninstall
   * @param isUninstallable true if target app is uninstallable.
   * @param appIndex appIndex to uninstall
   */
  uninstallApp(uninstallBundleName: string, isUninstallable: boolean, appIndex?: number, forceUninstall?: boolean,
    showToast?: boolean): void {
    if (!isUninstallable) {
      this.informUninstallResult(CommonConstants.UNINSTALL_FORBID);
    } else {
      if (!appIndex) {
        appIndex = 0;
      }
      launcherAbilityManager.uninstallLauncherAbility(uninstallBundleName,
        (bundleName: string, resultData: ResponseCode, appIndex: number) => {
          log.showInfo(`errorCode: ${resultData?.errorCode}`);
          // 加锁应用不需要toast提示
          if (resultData.code === -1 && resultData.errorCode === APP_LOCKED_ERROR_CODE) {
            AppLockManager.getInstance().setUninstallLockedAppBundleName(uninstallBundleName);
          } else if (showToast == null || showToast) {
            this.informUninstallResult(resultData.code, bundleName);
          }
          this.uninstallAppResult(bundleName, resultData, appIndex, '');
          log.showWarn(`baseviewmodel uninstallAppCallback ${bundleName} ${resultData?.code}`);
        }, appIndex, forceUninstall);
    }
  }

  registerAppListChangeCallback(): void {
    this.mAppModel.registerStateChangeListener(this.listener);
  }

  unregisterAppListChangeCallback(): void {
    log.showInfo('unregisterAppListChangeCallback');
    this.mAppModel.unregisterAppStateChangeListener(this.listener);
  }

  appListChangeListener(appList: [], event: string, bundleName: string, appIndex?: number): void {
    this.regroupDataAppListChange(appList, event, bundleName, appIndex);
  }

  uninstallAppResult(bundleName: string, resultData: ResponseCode, appIndex?: number, shortcutId?: string): void {
  }

  regroupDataAppListChange(callbackList: [], event: string, bundleName: string, appIndex?: number): void {
  }

  informUninstallResult(resultCode: number, bundleName?: string): void {
    log.showWarn(`Launcher AppListView getUninstallApp uninstallationResult: ${resultCode}`);
    if (resultCode === CommonConstants.UNINSTALL_FORBID) {
      Prompt.showToast({
        message: $r('app.string.disable_uninstall')
      });
    } else if (resultCode === CommonConstants.UNINSTALL_SUCCESS) {
      Prompt.showToast({
        message: $r('app.string.uninstall_success')
      });
    } else {
      if (resultCode === -1 && DeliverUtil.isContainerPkg(bundleName ?? '')) {
        log.info('UNINSTALL app not show toast in base view model');
        return;
      }
      Prompt.showToast({
        message: $r('app.string.uninstall_failed')
      });
    }
  }

  getAppName(itemInfo: BaseAppInfo): string {
    log.showInfo(`getAppName ${itemInfo?.appLabelId} ${itemInfo?.bundleName} ${itemInfo?.moduleName} ${itemInfo?.abilityName}`);
    let resName: string = IconResourceManager.getInstance().getAppNameByCache(itemInfo.appLabelId, itemInfo.bundleName,
      itemInfo.moduleName, '', itemInfo.appIndex);
    return resName;
  }

  /**
   *
   * @param isRemove 是否为移除，鸿蒙化应用显示移除，未鸿蒙化应用显示卸载
   * @param bundleName
   * @param appIndex
   * @param isDeleteMainApp 是否同步移除主应用和分身应用，true则一起移除，false则只移除分身应用
   * @returns
   */
  public deleteNotInstallApp(isRemove: boolean, bundleName: string, appIndex: number,
    isDeleteMainAppAndTwinApp: boolean = true): void {
    // 0:未鸿蒙化应用  1：已鸿蒙化应用
    let appSourceType: number = isRemove ? 1 : 0;
    // 未鸿蒙化主应用移除时，需要传递_WAIT_FOR_HRAMONY_BUNDLENAME_时间戳
    let waitForHarmonyBundleName = bundleName;
    let isAlreadyCancelToAG: boolean = false;
    bundleName = bundleName.startsWith('__WAIT_FOR_') ? bundleName.split('__')[2] : bundleName;
    if (appIndex !== 0) {
      AppGalleryDownloadManager.getInstance().removeDownloadInfo(bundleName, appIndex);
      LauncherBackupUtil.reportRemoveAppTwin(bundleName, appIndex, appSourceType);
      log.showInfo(`remove app bundleName: ${bundleName}, appIndex: ${appIndex}`);
      return;
    }
    // 文件夹展开态移除会先清理缓存，导致下载任务移除失败，所以需要先移除一遍主应用，再根据缓存去删除分身应用
    if (isDeleteMainAppAndTwinApp) {
      if (isRemove) {
        if (!AppUpdateUtils.checkIsEnterPriseTypeAppUpdate(bundleName)) {
          AppInstallUtils.getInstance().cancelTask(bundleName);
          isAlreadyCancelToAG = true;
        }
      } else {
        AppInstallUtils.getInstance().cancelTask(waitForHarmonyBundleName);
        isAlreadyCancelToAG = true;
      }
      // 只有移除主应用才会更新数据库卡片信息
      log.showInfo(`remove app card, bundleName: ${bundleName}, appIndex: ${appIndex}`);
      let relationCards: CardItemInfo[] =
        FormRelationManager.getInstance().updateFormAndStackInfoByBundleName(bundleName);
      if (!CheckEmptyUtils.isEmptyArr(relationCards)) {
        FormLayoutCacheManager.getInstance()
          .updateFormAndStackInfos(relationCards, BusinessType.BUSINESS_BASIC_DESKTOP, true);
      }
    }
    // 依赖缓存数据，业务侧尽量保证不要提前清理缓存
    let appList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
    appList = appList.filter(item => item.appStatus !== AppStatus.INSTALLED);
    log.showInfo(`need to remove app length: ${appList.length}`);
    appList = appList.filter((item, index) => appList.findIndex(i => i.appIndex === item.appIndex) === index);
    appList.forEach(item => {
      // 针对主应用已安装，分身应用未安装的场景
      if (item.appIndex === undefined) {
        // 历史规范，appIndex为空时，默认为主应用
        item.appIndex = 0;
      }
      // 主应用卸载时需同步调该方法移除分身应用，则这里isDeleteMainApp需为false，只移除分身应用
      if (item.appIndex === 0 && isDeleteMainAppAndTwinApp) {
        if (!isRemove) {
          // 未鸿蒙化主应用卸载时，需要传递_WAIT_FOR_HRAMONY_BUNDLENAME_时间戳
          bundleName = CommonUtils.jsonStrToMap(item.intent).get('requestBundleName') as string ?? bundleName;
        }
        if (!isAlreadyCancelToAG) {
          AppInstallUtils.getInstance().cancelTask(bundleName);
        }
        log.showInfo(`remove app bundleName: ${item.bundleName}, appIndex: ${item.appIndex}`);
      } else if (item.appIndex > 0) {
        AppGalleryDownloadManager.getInstance().removeDownloadInfo(bundleName, item.appIndex);
        LauncherBackupUtil.reportRemoveAppTwin(bundleName, item.appIndex, appSourceType);
        log.showInfo(`remove app bundleName: ${item.bundleName}, appIndex: ${item.appIndex}`);
      }
    });
  }

  public onSelectItemChange(items: string[], selectStatus: boolean, isSingle = false): void {
  }

  public getCurrentSelectItemsInfo(): GridLayoutItemInfo[] {
    return [];
  }

  public getCurrentSelectItems(): string[] {
    return [];
  }

  public getCurrentTouchItem(item: GridLayoutItemInfo): image.PixelMap | undefined {
    return undefined;
  }

  public getMultiSelectMap(): Map<string, image.PixelMap> | undefined {
    return undefined;
  }

  public filterSelectFileItem(): string[] {
    return [];
  }

  public getLastSelectItems(): string[] {
    return [];
  }

  public selectItemClear(): void {
  }

  public isPastedFile(uri: string): boolean {
    return false;
  }

  public selectItemContainApp(): boolean {
    return false;
  }

  public isCurrentItemInMultiMap(key: string): boolean {
    return false;
  }

  public getItemKeyByType(item: GridLayoutItemInfo, isOuterDesktop?: boolean): string {
    return '';
  }

  public initSelectStatus(): void {
  }

  public getIconSize(): number {
    return 0;
  }

  public isItemSelected(item: GridLayoutItemInfo): boolean {
    return false;
  }

  /**
   * 获取元素所在GridItem的id
   * @returns
   */
  public getContainerGridItemId(itemInfo: GridLayoutItemInfo): string {
    return '';
  }

  /**
   * 滚动以显示对应的元素
   * @returns
   */
  public scrollDownToShowGridItemFully(containerBelong: GridLayoutItemInfo | undefined): void {

  }
}

export class ResponseCode {
  public code: number = -1;
  public errorCode: number = -1
}

export interface BaseAppInfo {
  appLabelId?: number,
  bundleName?: string,
  moduleName?: string,
  appIndex?: number,
  abilityName?: string
}
