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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { commonEventManager, systemParameter } from '@kit.BasicServicesKit';
import osAccount from '@ohos.account.osAccount';
import bundleManager from '@ohos.bundle.bundleManager';
import deviceInfo from '@ohos.deviceInfo';
import dataShare from '@ohos.data.dataShare';
import settings from '@ohos.settings';
import { EdmAdminManager } from '@ohos/systemuicommon/Index';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import {
  AccountEvent,
  AccountMgr,
  DeviceHelper,
  EvtBus,
  GlobalContext,
  HiDfxEventUtil,
  PluginCardChangeEvent,
  PluginConstants,
  PluginInfo,
  PluginSlot,
  PluginToggleEvent,
  PluginUpdateEvent,
  sSettingsUtil,
  WindowEvent
} from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { CommonConstants, FASlotName, SettingsKeyConstants } from '@ohos/commonconstants';
import {
  ArrayUtils,
  CheckEmptyUtils,
  CommonUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import lazy { PluginToggleController } from '@ohos/plugincomponent/src/main/ets/controller/PluginToggleController';
import lazy { WifiController } from '@ohos/wificomponent/src/main/ets/default/controller/WifiController';
import lazy { BluetoothController } from '@ohos/bluetoothcomponent/src/main/ets/com/ohos/controller/BluetoothController';
import lazy { AutoRotateController } from '@ohos/autorotatecomponent/src/main/ets/com/ohos/controller/AutoRotateController';
import lazy { LocationController } from '@ohos/locationcomponent/src/main/ets/com/ohos/controller/LocationController';
import lazy { DarkModeController } from '@ohos/darkmodecomponent/src/main/ets/com/ohos/controller/DarkModeController';
import lazy { AirplaneController } from '@ohos/airplanecomponent/src/main/ets/default/controller/AirplaneController';
import lazy { HotSpotController } from '@ohos/hotspotcomponent/src/main/ets/com/ohos/controller/HotSpotController';
import lazy { FlashlightController } from '@ohos/flashlightcomponent/src/main/ets/com/ohos/controller/FlashlightController';
import lazy { SuperPrivacyController } from '@ohos/superprivacycomponent/src/main/ets/com/ohos/controller/SuperPrivacyController';
import lazy { MobileDataController } from '@ohos/mobiledatacomponent/src/main/ets/com/ohos/controller/MobileDataController';
import lazy { RingModeController } from '@ohos/ringmodecomponent/src/main/ets/com/ohos/controller/RingModeController';
import lazy { NfcController } from '@ohos/nfccomponent/src/main/ets/com/ohos/controller/NfcController';
import lazy { EyeComfortToggleController }
  from '@ohos/eyecomfortcomponent/src/main/ets/com/ohos/controller/EyeComfortToggleController';
import lazy AntiPeepingToggleController
  from '@ohos/antipeepingcomponent/src/main/ets/com/ohos/controller/AntiPeepingToggleController';
import lazy { CastToggleController } from '@ohos/hcastcomponent/src/main/ets/com/ohos/controller/CastToggleController';
import lazy { KmShareToggleController } from '@ohos/keymousesharecomponent/src/main/ets/com/ohos/controller/KmShareToggleController';
import lazy { DpinToggleController } from '@ohos/dpintogglecomponent/src/main/ets/com/ohos/controller/DpinToggleController';
import lazy { MeetingToggleController } from '@ohos/meetingtogglecomponent/src/main/ets/com/ohos/controller/MeetingToggleController';
import lazy { SuperHubToggleController }
  from '@ohos/superhubtogglecomponent/src/main/ets/com/ohos/controller/SuperHubToggleController';
import lazy NearLinkToggleController
  from '@ohos/nearlinktogglecomponent/src/main/ets/com/ohos/controller/NearLinkToggleController';
import lazy { PowerSavingToggleController }
  from '@ohos/powersavingtogglecomponent/src/main/ets/com/ohos/controller/PowerSavingToggleController';
import lazy { FocusModeToggleController }
  from '@ohos/focusmodecomponent/src/main/ets/com/ohos/controller/FocusModeToggleController';
import lazy { ApplicationToggleController } from './ApplicationToggleController';
import lazy { ScreenToggleController } from './ScreenToggleController';
import lazy BrightnessController from '../viewModel/BrightnessController';
import lazy { VolumeController } from '@ohos/soundcomponent/src/main/ets/controller/VolumnController';
import lazy { MultiWindowToggleController } from './MultiWindowToggleController';
import lazy sControlCenterToggleDataRestore from './ControlCenterToggleDataMigration';
import lazy { JuvenileModeToggleController } from '@ohos/juvenilemodecomponent/src/main/ets/com/ohos/controller/JuvenileModeToggleController';
import lazy { MusicServiceController } from '@ohos/musicservicetogglecomponent/src/main/ets/com/ohos/controller/MusicServiceToggleController';
import lazy { ScenarioModeToggleController }
  from '@ohos/scenariomodecomponent/src/main/ets/com/ohos/controller/ScenarioModeToggleController';
import { EventConstants } from '@ohos/launchercommon/src/main/ets/constants/EventConstants';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { BluetoothNearLinkFusionController } from '@ohos/bluetoothcomponent/Index';
import Constants, { ToggleData } from '../common/Constants';
import { LauncherAbilityManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/LauncherAbilityManagerAdapter';

const TAG: string = 'Ctrl.QuickToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const MAX_RETRY_TIMES: number = 5; // dataShare最多重试次数
const RETRY_INTERVAL_MS: number = 1500; // 重试间隔
const REFRESH_TOGGLE_DATA_DELAY_MS: number = 60000; // 延迟间隔
const PROJECTION_TOGGLE_KEY: string = 'HuaweiCastToggle';
const PROJECTION_PRIVACY_AGREE: string = 'need_reshow_projection_privacy';
const MAIN_USER_ID: number = 100;
const QUICK_TOGGLE_DATA_DEFAULT: string = 'false';
const TOGGLE_DATA_EDITED: string = 'true';
const PERSIST_EDM_CONFIG: string = 'persist.edm.edm_enable';
const EDM_ENABLE_EVENT_NAME: string = 'com.ohos.edm.edmadminenabled';
const EDM_DISABLE_EVENT_NAME: string = 'com.ohos.edm.edmadmindisabled';
const EDM_PUBLISHER_PERMISSION: string = 'ohos.permission.PUBLISH_ENTERPRISE_POLICY_EVENT';
const DISPLAY_VERSION_PARAM: string = 'const.build.ver.physical';
const DEFAULT_TOGGLE_COLUMN: number = 4;
// 1*2开关中非标准类型开关列表
const NON_STANDARD_TOGGLE: string[] =
  [FASlotName.MEDIA_ITEM_NAME,
    FASlotName.BRIGHTNESS,
    FASlotName.SOUND,
    FASlotName.SUPER_DEVICE,
    FASlotName.COMBINED_SLIDER];

export class QuickToggleController {

  public userId: number = MAIN_USER_ID;

  /**
   * 上下文
   */
  public context: Context;

  /**
   * 开关数据Uri
   */
  public toggleDataUri: string;

  /**
   * 头部开关数据Uri
   */
  public topToggleDataUri: string = '';

  /**
   * 面板开关数据
   */
  public toggleData: ToggleData = new ToggleData();

  /**
   * 保存UI状态存活的开关服务
   */
  public allTogglesControllerMap: Map<string, ToggleBaseViewModel> = new Map<string, ToggleBaseViewModel>();

  /**
   * 保存图标前处理
   */
  public preSaveQuickToggleDataCb?: (data: string[]) => void;
  private static instance?: QuickToggleController;

  /**
   * plugin数据集
   * PluginInfo => plugin数据集
   */
  private pluginInfos: Map<string, PluginInfo> = new Map<string, PluginInfo>();

  /**
   * lottie Down资源
   */
  private lottieDataDownResource? : object;

  /**
   * lottie Up资源
   */
  private lottieDataUpResource? : object;
  /**
   * lottie Down Dark资源
   */
  private lottieDataDownResourceDark? : object;

  private isEnableEdm: boolean = false;

  /**
   * 开关是否被编辑过
   */
  private toggleDataEdited: boolean = false;

  /**
   * lottie Up Dark资源
   */
  private lottieDataUpResourceDark? : object;

  // 所有快捷开关
  private allQuickToggle: string[];

  // 所有头部开关
  private allTopToggle: string[];
  private setTopTogglesTimeOut: number | null = null;

  private singleFoldQuickToggles: string[];

  private isPC: boolean = DeviceHelper.isPC();

  // 类似java中的锁机制, 等待lockResolve被执行之后，lock被释放
  private lockResolve: () => void = () => {};
  private lock: Promise<void> = new Promise(resolve => {
    this.lockResolve = resolve
  });

  /**
   * 应用接入开关：包名和对应开关名称映射关系
   */
  private bundleConfigMap: Map<string, string[]> = new Map<string, string[]>();

  private isOtaRegister: boolean = false;

  /**
   * 当前已移除的开关（不更新数据库字段，仅过滤显示）
   */
  private removedToggle: string[] = [];
  /**
   * 当前数据库字段
   */
  private quickToggleStr: string = '';

  private readonly abilityInfoChangedListener: (event: string, bundleName: string, userId: number) => void =
    (event: string, bundleName: string, userId: number) => this.onAbilityInfoChanged(event, bundleName, userId);

  /**
   * 构造方法
   */
  constructor() {
    this.context = GlobalContext.getContext() as Context;
    // 初始化EDM设备管控
    EdmAdminManager.instance.init();

    // 获取所有toggle数据
    this.allQuickToggle = ResUtils.getInnerString($r('app.string.toggle_data_all'))?.split(',');
    this.allTopToggle = ResUtils.getInnerString($r('app.string.top_toggle_data_all'))?.split(',');
    let singleFoldQuickToggleStr = ResUtils.getInnerString($r('app.string.small_screen_toggle_data_default'));
    this.singleFoldQuickToggles = singleFoldQuickToggleStr?.split(',');
    // 创建开关数据的AppStorage
    log.showInfo(`this.toggleData: ${this.toggleData.toString()}`);
    this.toggleData = AppStorage.setAndRef('QuickToggleData', this.toggleData)?.get();
    this.toggleDataUri = CommonConstants.getUriSync(CommonConstants.KEY_TOGGLE_DATA);
    this.initToggleSettingsData();
    this.registerToggleDataChange();
    // 刷新接入开关数据
    this.initBundleToggleMap();
    this.refreshRemovedToggleState()
    // 开机主动刷新开关数据
    this.onToggleDataChange();
    // 监听用户变化
    EvtBus.on(AccountEvent, (event: AccountEvent) => this.onUserChanged(event?.accountInfo?.localId));
    // 监听开关连接变化
    EvtBus.on(PluginToggleEvent, this.handlePluginEvent);
    sControlCenterToggleDataRestore.initRestore();

    // 监听控制中心显示刷新EDM管控
    this.edmDeviceListener();
    // 监听包状态回调
    LauncherAbilityManagerAdapter.registerLauncherAbilityChangeListener({
      callback: this.abilityInfoChangedListener,
    }, `${TAG}_registerLauncherAbilityChangeListener`);
  }

  /**
   * Get the instance of the QuickToggleController class
   */
  static getInstance(): QuickToggleController {
    if (!QuickToggleController.instance) {
      QuickToggleController.instance = new QuickToggleController();
    };
    return QuickToggleController.instance;
  };

  edmDeviceListener() {
    // 监听手机控制中心显示
    EvtBus.on(PluginCardChangeEvent, (event: PluginCardChangeEvent) => {
      if ((this.isEnableEdm || EdmAdminManager.instance.isEdmAdminEnabled()) &&
        event.status === PluginCardChangeEvent.PLUGIN_CARD_SHOW) {
        log.showInfo('phone show control center event callback');
        this.updateToggleAvailable();
        this.isEnableEdm = EdmAdminManager.instance.isEdmAdminEnabled();
      }
    });

    // 监听PC控制中心显示/隐藏
    EvtBus.on(WindowEvent, (event: WindowEvent) => {
      if ((this.isEnableEdm || EdmAdminManager.instance.isEdmAdminEnabled()) &&
      event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) &&
      event.isWindowStartShow()) {
        log.showInfo('pc show control center event callback');
        this.updateToggleAvailable();
        this.isEnableEdm = EdmAdminManager.instance.isEdmAdminEnabled();
      }
    });
  }

  /**
   * 刷新已建开关的可操作性
   */
  private updateToggleAvailable(): void {
    // 获取edm可以管控的开关列表
    let edmAdminToggles: string[] = ResUtils.getInnerString($r('app.string.edm_admin_toggles'))?.split(',');
    edmAdminToggles.forEach((toggle: string) => {
      if (this.allTogglesControllerMap.has(toggle)) {
        this.allTogglesControllerMap.get(toggle)?.updateDisableState();
      }
    })
  }

  /**
   * 初始化数据库开关数据
   */
  private initToggleSettingsData(): void {
    // 处理头部开关数据
    this.checkTopToggleSettingsData();
    let existInDB: boolean = this.existToggleDataInDB();
    if (existInDB) {
      // 替换融合按钮字段
      let filterToggleStr = this.filterEnableToggleData(this.quickToggleStr?.split(','));
      if (filterToggleStr !== this.quickToggleStr) {
        this.saveQuickToggleData(filterToggleStr?.split(','));
        this.quickToggleStr = filterToggleStr;
      }
    }
    if (!DeviceHelper.isPhone() || existInDB) {
      if (DeviceHelper.isPad() && !existInDB) {
        this.saveQuickToggleData(this.getOldDefaultQuickToggleData());
      }
      return;
    }
    let otaOldVersion: string = sSettingsUtil.getValue(SettingsKeyConstants.OTA_OLD_VERSION, '');
    log.showInfo(`initToggleSettingsData otaOldVersion=${otaOldVersion}`);
    if (!CheckEmptyUtils.checkStrIsEmpty(otaOldVersion)) {
      this.updateDefaultToggle(false, otaOldVersion);
    }
    // 延时1min + 旧版本监听
    try {
      this.isOtaRegister = settings.registerKeyObserver(GlobalContext.getContext(), SettingsKeyConstants.OTA_OLD_VERSION,
        settings.domainName.DEVICE_SHARED, () => {
          this.updateDefaultToggle(false, sSettingsUtil.getValue(SettingsKeyConstants.OTA_OLD_VERSION, ''));
        });
    } catch (err) {
      log.showError(`OTA_OLD_VERSION registerKeyObserver error:${err}`);
    }
    setTimeout(() => {
      this.updateDefaultToggle(true, '');
      if (this.isOtaRegister) {
        try {
          settings.unregisterKeyObserver(GlobalContext.getContext(), SettingsKeyConstants.OTA_OLD_VERSION,
            settings.domainName.DEVICE_SHARED);
        } catch (err) {
          log.showError(`OTA_OLD_VERSION unregisterKeyObserver error:${err}`);
        }
      }
    }, REFRESH_TOGGLE_DATA_DELAY_MS);
  }

  /**
   * 过滤当前版本可用开关
   *
   * @param toggleList
   * @returns 过滤后开关
   */
  public filterEnableToggleData(toggleList: string[]): string {
    if (CheckEmptyUtils.isEmptyArr(toggleList)) {
      return ResUtils.getInnerString($r('app.string.toggle_data_default'));
    }
    let filterToggleArr: string[] = [];
    if (canIUse('SystemCapability.Communication.FusionConnectivityExt')) {
      filterToggleArr.push(FASlotName.NEAR_LINK);
    }
    let newArr: string[] = toggleList.filter(toggle => filterToggleArr.indexOf(toggle) === -1);
    // 需要从备选库取N个开关添加到首页
    if (toggleList.length - newArr.length > 0) {
      let toggleLibrary: string[] = ResUtils.getInnerString($r('app.string.toggle_data_all'))
        .split(',').filter(item => {
          if (newArr.indexOf(item) !== -1) {
            return false;
          }
          return this.toggleData.isEmpty() ?
            this.initToggleModel(item, this.createToggleModel(item)) : this.toggleData.contain(item);
        });
      newArr = newArr.concat(toggleLibrary.slice(0, toggleList.length - newArr.length));
    }
    log.showInfo(`filterEnableToggleData end filterToggleArr=${filterToggleArr} newArr=${newArr}`);
    return newArr.join(',');
  }

  /**
   * 判断数据库是否存在头部开关数据，如果是空表示升级产品需要设置默认值，延迟一分钟执行，防止隐私空间数据异常
   */
  private checkTopToggleSettingsData(): void {
    let topToggleStr: string = sSettingsUtil.getSecureValue(CommonConstants.KEY_TOP_TOGGLE_DATA, '', this.context);
    if (CheckEmptyUtils.checkStrIsEmpty(topToggleStr)) {
      if (this.setTopTogglesTimeOut !== null) {
        clearTimeout(this.setTopTogglesTimeOut);
      }
      this.setTopTogglesTimeOut = setTimeout(() => {
        topToggleStr = sSettingsUtil.getSecureValue(CommonConstants.KEY_TOP_TOGGLE_DATA, '', this.context);
        if (CheckEmptyUtils.checkStrIsEmpty(topToggleStr)) {
          this.saveTopToggleData(this.getDefaultTopToggleData());
        }
        this.setTopTogglesTimeOut = null;
      }, 60 * 1000)
    }
  }

  private existToggleDataInDB(): boolean {
    // 当前数据库是否有值
    this.quickToggleStr = this.userId === MAIN_USER_ID ? sSettingsUtil.getValue(CommonConstants.KEY_TOGGLE_DATA, '') :
    sSettingsUtil.getSecureValue(CommonConstants.KEY_TOGGLE_DATA, '', this.context);
    log.showInfo(`initToggleSettingsData return this.userId=${this.userId}; quickToggleStr=${this.quickToggleStr} `);
    return !CheckEmptyUtils.checkStrIsEmpty(this.quickToggleStr);
  }

  private updateDefaultToggle(isTimeout: boolean, oldOtaVersion: string): void {
    if (this.existToggleDataInDB()) {
      return;
    }
    let defaultToggleArr: string[];
    if ((isTimeout || CheckEmptyUtils.checkStrIsEmpty(oldOtaVersion) ||
      oldOtaVersion.localeCompare(this.getDisplayVersion()) !== -1) && Constants.LOAD_NEW_DEFAULT_TOGGLE) {
      defaultToggleArr = this.getDefaultQuickToggleData();
    } else {
      defaultToggleArr = this.getOldDefaultQuickToggleData();
    }
    this.saveQuickToggleData(defaultToggleArr);
  }

  /**
   * 获取系统版本号
   */
  private getDisplayVersion(): string {
    let displayVersion: string = '';
    displayVersion = systemParameter.getSync(DISPLAY_VERSION_PARAM, '');
    if (displayVersion) {
      log.showInfo('get displayVersion by const.build.ver.physical is %{public}s', displayVersion);
      return displayVersion;
    }
    log.showInfo('get displayVersion by deviceInfo.displayVersion is %{public}s', deviceInfo.displayVersion);
    return deviceInfo.displayVersion;
  }

  getLottieDataDownResource(isDark: boolean) {
    return isDark ? this.lottieDataDownResourceDark : this.lottieDataDownResource;
  }

  getLottieDataUpResource(isDark: boolean) {
    return isDark ? this.lottieDataUpResourceDark : this.lottieDataUpResource;
  }

  /**
   * 释放Lottie资源
   */
  releaseLottieData() {
    log.showDebug('releaseLottieData');
    this.lottieDataDownResource = undefined;
    this.lottieDataUpResource = undefined;
    this.lottieDataDownResourceDark = undefined;
    this.lottieDataUpResourceDark = undefined;
  }

  /**
   * 监听开关数据变化
   */
  async registerToggleDataChange() {
    this.retryRegisterToggleDataChange(MAX_RETRY_TIMES);
  }

  async retryRegisterToggleDataChange(retryTimes: number) {
    if (retryTimes <= 0) {
      log.error('no retry times');
      return;
    }
    try {
      log.showInfo(`retryRegisterToggleDataChange retryTimes: ${retryTimes}`);
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      let userId: number = await accountManager.getForegroundOsAccountLocalId();
      if (AccountMgr.isInvalidAccount(userId)) {
        log.showWarn('current user id invalid');
        return;
      }
      this.userId = userId;
      log.showInfo('current userId: ' + userId);
      if (this.userId !== MAIN_USER_ID) {
        this.toggleDataUri = CommonConstants.getSettingsSecureUriSync(CommonConstants.KEY_TOGGLE_DATA, this.userId);
      }
      this.topToggleDataUri =
        CommonConstants.getSettingsSecureUriSync(CommonConstants.KEY_TOP_TOGGLE_DATA, this.userId);
    } catch (e) {
      log.showError('get OsAccount localId failed!');
    }
    try {
      // 头部开关监听
      let topToggleDataHelper: dataShare.DataShareHelper =
        await dataShare.createDataShareHelper(this.context as Context, this.topToggleDataUri);
      log.showInfo('registerTopToggleDataChange, helper : ' + topToggleDataHelper);
      topToggleDataHelper?.on('dataChange', this.topToggleDataUri, () => this.onToggleDataChange());
      // 快捷开关监听
      let quickToggleDataHelper: dataShare.DataShareHelper =
        await dataShare.createDataShareHelper(this.context as Context, this.toggleDataUri);
      log.showInfo('registerToggleDataChange, helper : ' + quickToggleDataHelper);
      quickToggleDataHelper?.on('dataChange', this.toggleDataUri, () => this.onToggleDataChange());
    } catch (error) {
      log.error('createDataShareHelper error', error);
      log.error('context mode:' + this.context?.stageMode);
      setTimeout(() => {
        this.retryRegisterToggleDataChange(retryTimes - 1)
      }, RETRY_INTERVAL_MS);
    }
  }

  /**
   * 开关数据变化的回调
   */
  async onToggleDataChange() {
    log.showInfo('onToggleDataChange');
    // 刷新开关数据
    let toggleDataTemp: ToggleData = await this.refreshToggleData(false);
    log.showInfo(`onToggleDataChange toggleDataTemp: ${toggleDataTemp.toString()}, toggleData: ${this.toggleData.toString()}`);
    if (this.toggleData.equals(toggleDataTemp)) {
      log.showInfo(`onToggleDataChange no change!`);
    } else {
      this.toggleData.copy(toggleDataTemp);
    }
    this.lockResolve();
  }

  /**
   * 获取上部开关数据字串
   */
  getTopToggleData(): string[] {
    let topToggleStr: string = '';
    try {
      topToggleStr = sSettingsUtil.getSecureValue(CommonConstants.KEY_TOP_TOGGLE_DATA, '', this.context);
      this.toggleDataEdited = sSettingsUtil.getSecureValue(CommonConstants.KEY_QUICK_TOGGLE_DATA_EDITED,
        QUICK_TOGGLE_DATA_DEFAULT, this.context) === TOGGLE_DATA_EDITED;
      log.showInfo(`getTopToggleData userId:${this.userId} toggleDataEdited:${this.toggleDataEdited} topToggleStr:${topToggleStr}`);
    } catch (e) {
      log.showError(`getTopToggleData getValue name: ${CommonConstants.KEY_TOP_TOGGLE_DATA} error:${e?.code} - ${e?.message}`);
    }
    if (this.needUseDefaultToggle(topToggleStr, true)) {
      log.showInfo(`getTopToggleData settings value is null, get default toggle data!`);
      return this.getDefaultTopToggleData();
    }
    return topToggleStr.split(',');
  }

  /**
   * 获取快捷开关数据
   */
  getQuickToggleData(): string[] {
    let quickToggleStr: string = '';
    try {
      quickToggleStr = this.userId === MAIN_USER_ID ? settings.getValueSync(this.context, CommonConstants.KEY_TOGGLE_DATA, '') :
      sSettingsUtil.getSecureValue(CommonConstants.KEY_TOGGLE_DATA, '', this.context);
      this.quickToggleStr = quickToggleStr;
      this.toggleDataEdited = sSettingsUtil.getSecureValue(CommonConstants.KEY_QUICK_TOGGLE_DATA_EDITED,
        QUICK_TOGGLE_DATA_DEFAULT, this.context) === TOGGLE_DATA_EDITED;
      log.showInfo(`getQuickToggleData userId:${this.userId} toggleDataEdited:${this.toggleDataEdited} quickToggleStr:${quickToggleStr}`);
    } catch (e) {
      log.showError(`getQuickToggleData getValue name: ${CommonConstants.KEY_TOGGLE_DATA} error:${e?.code} - ${e?.message}`);
    }
    if (this.needUseDefaultToggle(quickToggleStr, false)) {
      log.showInfo(`getQuickToggleData settings value is null, get default toggle data!`);
      quickToggleStr = Constants.LOAD_NEW_DEFAULT_TOGGLE ? ResUtils.getInnerString($r('app.string.toggle_data_default')) :
      ResUtils.getInnerString($r('app.string.toggle_data_default_old'));
    }
    return quickToggleStr.split(',');
  }

  /**
   * 检查是否需要使用默认开关字段显示
   *
   * @param toggleStr
   * @param isTopToggle
   * @returns
   */
  private needUseDefaultToggle(toggleStr: string, isTopToggle: boolean): boolean {
    log.showInfo(`needUseDefaultToggle toggleStr: ${toggleStr}, isTopToggle: ${isTopToggle}`);
    if (CommonUtils.isEmpty(toggleStr)) {
      return true;
    }
    let targetAllToggle: string[] = isTopToggle ? this.allTopToggle : this.allQuickToggle;
    if (toggleStr.split(',').some(item => targetAllToggle.includes(item))) {
      return false;
    }
    //非法数据，使用默认开关数据替代
    log.showInfo(`checkIllegalToggleStr fail! toggleStr= ${toggleStr}`);
    return true;
  }

  /**
   * 刷新开关数据
   */
  async refreshToggleData(isDefault?: boolean): Promise<ToggleData> {
    log.showInfo(`refreshToggleData allQuickToggles: ${this.allQuickToggle.toString()}  ` +
      `allTopToggles: ${this.allTopToggle.toString()}`);

    const toggleData: ToggleData = new ToggleData();
    let topToggles: string[] = isDefault ? this.getDefaultTopToggleData() : this.getTopToggleData();
    let quickToggles: string[] = isDefault ? this.getDefaultQuickToggleData() : this.getQuickToggleData();

    this.filterOutAvailableToggles(topToggles, quickToggles, toggleData);
    this.updateAlternativeToggle(topToggles, quickToggles, toggleData);

    log.showInfo(`refreshToggleData toggleData: ${toggleData.toString()}`);
    return toggleData;
  }

  /**
   * 过滤出可用开关
   *
   * @param topToggles 头部开关
   * @param quickToggles 快捷开关
   * @param toggleData 过滤后的开关
   */
  private filterOutAvailableToggles(topToggles: string[], quickToggles: string[], toggleData: ToggleData): void {
    // 过滤出可用，并且初始化服务成功的头部开关，加入到toggleData.topToggle中，用户可见可点击
    topToggles = topToggles.filter(toggle => {
      // 非标准样式开关不通过ToggleBaseViewModel判断是否要显示，默认可以显示
      if (NON_STANDARD_TOGGLE.includes(toggle) && this.allTopToggle.indexOf(toggle) > -1) {
        return true;
      }
      let controller: ToggleBaseViewModel | undefined = this.createToggleModel(toggle);
      if (controller !== undefined && this.allTopToggle.indexOf(toggle) > -1) {
        this.initToggleModel(toggle, controller);
        return true;
      } else {
        return false;
      }
    })
    topToggles.forEach(toggle => {
      toggleData.topToggle.push(toggle);
    });

    // 过滤出可用，并且初始化服务成功的快捷开关，加入到toggleData.quickToggle，用户可见可点击，限制显示的快捷1*1开关上限为20个
    let toggleCount: number = 0;
    quickToggles = quickToggles.filter(toggle => {
      if (toggleCount >= Constants.QUICK_TOGGLE_MAX) {
        return false;
      }
      let controller: ToggleBaseViewModel | undefined = this.createToggleModel(toggle);
      if (controller != null && this.allQuickToggle.indexOf(toggle) > -1) {
        this.initToggleModel(toggle, controller);
        toggleCount++;
        return true;
      } else {
        return false;
      }
    })
    quickToggles.forEach(toggle => {
      toggleData.quickToggle.push(toggle);
    });
  }

  /**
   * 更新备选库开关
   *
   * @param topToggles 头部开关
   * @param quickToggles 快捷开关
   * @param toggleData 过滤后的开关
   */
  private updateAlternativeToggle(topToggles: string[], quickToggles: string[], toggleData: ToggleData) {
    // 过滤出可用的开关，加入到备选库中，用户展开备选库之后可见
    this.allTopToggle.forEach(toggle => {
      if (!topToggles.includes(toggle)) {
        if (NON_STANDARD_TOGGLE.includes(toggle) || this.createToggleModel(toggle) !== undefined) {
          toggleData.otherTopToggle.push(toggle);
          this.stopToggleModel(toggle);
        }
      }
    });

    this.allQuickToggle.forEach(toggle => {
      if (!quickToggles.includes(toggle)) {
        if (this.createToggleModel(toggle) !== undefined) {
          toggleData.otherToggle.push(toggle);
          this.stopToggleModel(toggle);
        }
      }
    });
  }

  clearBackupToggleControllers(): void {
    try {
      this.toggleData.otherToggle.forEach((toggle) => {
        this.stopToggleModel(toggle);
      })
    } catch (error) {
      log.showError('clearBackupToggleControllers: failed' + '' + error);
    }
  }

  initSliderButtonLottie(): void {
    BrightnessController?.initAllLottieData();
    VolumeController.getInstance()?.initAllLottieData();
  }

  removeSliderButtonLottieData(): void {
    BrightnessController?.removeLottieData();
    VolumeController.getInstance()?.removeLottieData();
  }

  /**
   * 移除全量控制中心Lottie
   */
  public removeAllLottieData(): void {
    this.removeSliderButtonLottieData();
    QuickToggleController.instance?.allTogglesControllerMap.forEach((viewModel) => {
      viewModel.removeAllLottieData();
    });
  }

  /**
   * 加载全量控制中心Lottie
   */
  public loadAllLottieData(): void {
    this.initSliderButtonLottie();
    QuickToggleController.instance?.allTogglesControllerMap.forEach((viewModel) => {
      viewModel.initLottieData();
    });
  }

  /**
   * 返回开关数据
   */
  getToggleData(): ToggleData {
    return this.toggleData;
  }

  /**
   * 返回默认上部开关数据
   */
  private getDefaultTopToggleData(): string[] {
    let defaultTopToggleStr: string = this.userId === MAIN_USER_ID ?
    ResUtils.getInnerString($r('app.string.top_toggle_data_default')) :
    ResUtils.getInnerString($r('app.string.top_toggle_data_default_multiuser'));
    return defaultTopToggleStr.split(',');
  }

  /**
   * 返回默认快捷开关数据
   */
  getDefaultQuickToggleData(): string[] {
    return ResUtils.getInnerString($r('app.string.toggle_data_default')).split(',');
  }

  /**
   * 返回默认开关数据(16个-手机端)
   */
  getOldDefaultQuickToggleData(): string[] {
    return ResUtils.getInnerString($r('app.string.toggle_data_default_old')).split(',');
  }

  /**
   * 返回所有开关数据
   */
  getAllToggleData(): Map<string, ToggleBaseViewModel> {
    return this.allTogglesControllerMap;
  }

  /**
   * 保存头部开关数据
   *
   * @param data 头部开关数据
   */
  saveTopToggleData(data: string[]): void {
    // 上报开关数据变化
    let value: string = data.join(',');
    HiDfxEventUtil.reportToggleDataChange(value);
    log.showInfo(`saveTopToggleData value: ${value}`);
    try {
      sSettingsUtil.setSecureValue(CommonConstants.KEY_TOP_TOGGLE_DATA, value, this.context);
      sControlCenterToggleDataRestore.setBackupToggleDataSort(value, true);
    } catch (err) {
      log.showError(`saveTopToggleData setValueSync name: ${CommonConstants.KEY_TOP_TOGGLE_DATA} error`, err);
    }
  }

  /**
   * 保存开关数据
   */
  saveQuickToggleData(data: string[]) {
    if (this.preSaveQuickToggleDataCb) {
      this.preSaveQuickToggleDataCb(data);
    }
    // 上报开关数据变化
    let value: string = data.join(',');
    HiDfxEventUtil.reportToggleDataChange(value);
    log.showInfo('saveQuickToggleData value: ' + value);
    try {
      if (this.userId === MAIN_USER_ID) {
        settings.setValueSync(this.context, CommonConstants.KEY_TOGGLE_DATA, value);
      }
      sSettingsUtil.setSecureValue(CommonConstants.KEY_TOGGLE_DATA, value, this.context);
      sSettingsUtil.setSecureValue(CommonConstants.KEY_QUICK_TOGGLE_DATA_EDITED, TOGGLE_DATA_EDITED, this.context);
      this.resetProjectionToggleState(data);
      sControlCenterToggleDataRestore.setBackupToggleDataSort(value);
    } catch (err) {
      log.showError(`saveQuickToggleData setValueSync name: ${CommonConstants.KEY_TOGGLE_DATA} error`, err);
    }
  }

  /**
   * 根据情况确定是否需要重置无线投屏开关状态，无线投屏开关移出时，需要重置状态为未同意过隐私声明
   *
   * @param data 开关数据
   */
  resetProjectionToggleState(data: string[]) {
    // 本次保存的开关中没有无线投屏
    if (data.indexOf(PROJECTION_TOGGLE_KEY) === -1) {
      // 重置无线投屏隐私声明状态为未同意
      try {
        sSettingsUtil.setSecureValue(PROJECTION_PRIVACY_AGREE, '0', this.context);
      } catch (err) {
        log.error(`resetProjectionToggleState setValueSync name: ${PROJECTION_PRIVACY_AGREE} error`, err);
      }
    }
  }

  /**
   * 用户变化回调
   *
   * @param userId 用户ID
   */
  onUserChanged(userId: number | undefined): void {
    if (userId === undefined) {
      log.showInfo('user id is undefined');
      return;
    }
    log.showInfo(`current user id: ${userId}`);
    if (AccountMgr.isInvalidAccount(userId)) {
      log.showInfo('current user id invalid');
      return;
    }
    if (userId !== MAIN_USER_ID) {
      log.showInfo('changed to privacy space');
      // 需要等待开机默认加载的refreshToggleData执行完毕再执行删除操作，否则会因为时序导致无效删除。
      this.lock.then(() => {
        this.removeBlockedToggles();
      })
    }
    if (this.userId !== userId) {
      this.userId = userId;
      // 刷新开关数据库字段
      this.initToggleSettingsData();
      // 刷新接入开关数据
      this.refreshRemovedToggleState()
      // 开机主动刷新开关数据
      this.onToggleDataChange();
    }
  }

  removeBlockedToggles() {
    let toggleBlockedList: string[] = ResUtils.getInnerString($r('app.string.toggle_data_black_multiuser')).split(',');
    for (let slot of toggleBlockedList) {
      this.stopToggleModel(slot);
    }
    this.toggleData.quickToggle = this.toggleData.quickToggle.filter(slot => !toggleBlockedList.includes(slot));
    this.toggleData.topToggle = this.toggleData.topToggle.filter(slot => !toggleBlockedList.includes(slot));
    this.toggleData.otherToggle = this.toggleData.otherToggle.filter(slot => !toggleBlockedList.includes(slot));
    this.toggleData.otherTopToggle = this.toggleData.otherTopToggle.filter(slot => !toggleBlockedList.includes(slot));
    this.allQuickToggle = this.allQuickToggle.filter(slot => !toggleBlockedList.includes(slot));
    this.allTopToggle = this.allTopToggle.filter(slot => !toggleBlockedList.includes(slot));
  }

  /**
   * 开关面板展开状态列数
   *
   */
  getToggleColumn(): number {
    let toggleColumn: number = ResUtils.getNumber($r('app.float.quick_toggle_column'));
    if (isNaN(toggleColumn) || toggleColumn <= 0) {
      toggleColumn = DEFAULT_TOGGLE_COLUMN;
    }
    return toggleColumn;
  }

  /**
   * 开关面板收起状态列数
   *
   */
  getQuickToggleColumn(): number {
    return 5;
  }

  /**
   * 开关面板列数排布
   *
   * @param column 列数
   */
  getToggleGridTemplate(column: number): string {
    let template: string = '1fr';
    for (let i = 1; i < column; i++) {
      template += ' 1fr';
    }
    return template;
  }

  /**
   * 处理控制中心plugin解析事件
   *
   * @param event 事件
   */
  private handlePluginEvent = (event: PluginToggleEvent) => {
    log.showInfo('handlePluginEvent type: ' + event.eventType);
    if (event.eventType === PluginConstants.EVENT_TYPE_QUERY_ALL) {
      // 清空数据，重新添加
      this.resetPlugins();
      this.addUpdatePlugin(event.pluginInfos);
    } else if (event.eventType === PluginConstants.EVENT_TYPE_UPDATE_PLUGIN ||
      event.eventType === PluginConstants.EVENT_TYPE_ADD_PLUGIN) {
      // 直接更新数据
      this.addUpdatePlugin(event.pluginInfos);
    } else if (event.eventType === PluginConstants.EVENT_TYPE_DELETE_PLUGIN) {
      this.removePlugin(event.pluginInfos);
    }
  }

  /**
   * 重置所有plugin数据
   */
  private resetPlugins(): void {
    this.pluginInfos?.clear();
  }

  /**
   * 添加/更新plugin数据
   *
   * @param pluginInfos plugin数据集
   */
  private addUpdatePlugin(pluginInfos: Array<PluginInfo>): void {
    if (ArrayUtils.isEmpty(pluginInfos)) {
      return;
    }
    pluginInfos.forEach((info: PluginInfo) => {
      if (this.pluginInfos.has(info.pluginParseInfo.pluginSlot)) {
        EvtBus.post(PluginUpdateEvent, PluginUpdateEvent.create(info));
      }
      log.showInfo(`addUpdatePlugin pluginSlot: ${info.pluginParseInfo.pluginSlot}`);
      this.pluginInfos.set(info.pluginParseInfo.pluginSlot, info);
      log.showInfo(`addUpdatePlugin infos: ${this.pluginInfos.size}`);
      if (info.hasSubPage()) {
        sToggleSubWindowController.registerSubWindowInfo(info.pluginParseInfo.pluginSlot, info);
      }
    });
    // plugin数据有变化，刷新开关数据
    this.onToggleDataChange();
  }

  /**
   * 删除plugin数据
   *
   * @param pluginInfos plugin数据集
   */
  private removePlugin(pluginInfos: Array<PluginInfo>): void {
    if (ArrayUtils.isEmpty(pluginInfos)) {
      return;
    }
    pluginInfos.forEach((info: PluginInfo) => {
      // 移除出allToggles
      let controller: PluginToggleController = this.allTogglesControllerMap.get(info.pluginParseInfo.pluginSlot) as PluginToggleController;
      if (!CommonUtils.isInvalid(controller)) {
        controller.isConnect = false;
      }
      this.pluginInfos.delete(info.pluginParseInfo.pluginSlot);
    });
    // plugin数据有变化，刷新开关数据
    this.onToggleDataChange();
  }

  /**
   * 获取plugin数据
   */
  getPluginToggleData(): Map<string, PluginInfo> {
    return this.pluginInfos;
  }

  /**
   * 释放某个开关的controller
   */
  public releaseToggleController(slot: string): void {
    this.stopToggleModel(slot);
  }

  // 停止开关服务
  private stopToggleModel(toggle: string) {
    let viewModel: ToggleBaseViewModel | undefined = this.allTogglesControllerMap.get(toggle);
    if (viewModel != null) {
      if (!viewModel.isPersist()) {
        try {
          viewModel.onStop();
        } catch (error) {
          log.showError('stopToggleModel failed, toggle: ' + toggle);
        }
      }
      this.allTogglesControllerMap.delete(toggle);
    }
  }

  // 初始化开关服务，返回初始化成功或者失败
  private initToggleModel(toggle: string, viewModel: ToggleBaseViewModel | undefined): boolean {
    if (this.allTogglesControllerMap.has(toggle)) {
      return true;
    }
    if (viewModel != null) {
      this.allTogglesControllerMap.set(toggle, viewModel);
      if (!viewModel.isPersist()) {
        try {
          viewModel.onStart();
          return true;
        } catch (error) {
          log.showError('initToggleModel failed: ' + toggle);
          this.stopToggleModel(toggle);
          return false;
        }
      } else {
        // 单例开关刷新一次开关置灰态
        viewModel.updateDisableState();
        return true;
      }
    } else {
      return false;
    }
  }

  /**
   * 获取开关对应的viewModel并调用onStart启动开关服务
   *
   * @param slot 开关唯一标识
   */
  public createToggleModelAndInit(slot: string): ToggleBaseViewModel | undefined {
    log.showInfo('createToggleModelAndInit: ' + slot);
    return this.createToggleModel(slot, true);
  }

  /**
   * 创建开关服务，在此方法中会判断开关是否可用，否则将不会创建
   *
   * 如果开关服务没有其他模块例如状态栏依赖，当移动到备选库的时候就销毁，进入备选库时会重新创建，建议使用new方式创建
   * 如果开关服务同时提供给其他模块使用，例如wifi，蓝牙等，则建议使用单例模式，跟大桌面进程共存亡
   * @param slot
   * @param shouldInit 是否在创建开关服务之后启动服务。例如仅需要获取开关是否可用的判断，不需要启动服务
   * @returns 开关的videModel
   */
  public createToggleModel(slot: string, shouldInit: boolean = false): ToggleBaseViewModel | undefined {
    if (this.removedToggle.includes(slot)) {
      log.showInfo(`createToggleController removedToggle: ${slot}`);
      this.stopToggleModel(slot);
      return undefined;
    }
    if (this.allTogglesControllerMap.has(slot)) {
      let controller: ToggleBaseViewModel | undefined = this.allTogglesControllerMap.get(slot);
      try {
        if (controller?.isAvailable(this.userId)) {
          return this.allTogglesControllerMap.get(slot);
        } else {
          return undefined;
        }
      } catch (e) {
        log.showError('createToggleController isAvailable meet crash' + slot);
        return undefined;
      }
    }
    let viewModel: ToggleBaseViewModel | undefined = undefined;
    try {
      switch (slot) {
        case FASlotName.WIFI:
        case FASlotName.WIFI_UI_EXTENSION:
          viewModel = WifiController.getInstance();
          break;
        case FASlotName.BLUETOOTH:
        case FASlotName.BLUETOOTH_UI_EXTENSION:
          viewModel = this.isPC || !canIUse('SystemCapability.Communication.FusionConnectivityExt') ?
            BluetoothController.getInstance() : BluetoothNearLinkFusionController.getInstance();
          break;
        case FASlotName.AIR_PLANE:
          viewModel = AirplaneController.getInstance();
          break;
        case FASlotName.FOCUS_MODE:
          viewModel = FocusModeToggleController.getInstance();
          break;
        case FASlotName.AUTO_ROTATE:
          viewModel = AutoRotateController.getInstance();
          break;
        case FASlotName.DARK_MODE:
          viewModel = new DarkModeController();
          break;
        case FASlotName.FLASHLIGHT:
          viewModel = FlashlightController.getInstance();
          break;
        case FASlotName.MOBILE_DATA:
          viewModel = MobileDataController.getInstance();
          break;
        case FASlotName.MOBILE_DATA_TAGGED:
          viewModel = MobileDataController.getInstance();
          break;
        case FASlotName.RING_MODE:
          viewModel = RingModeController.getInstance();
          break;
        case FASlotName.NFC:
          viewModel = NfcController.getInstance();
          break;
        case FASlotName.HOTSPOT:
          viewModel = HotSpotController.getInstance();
          break;
        case FASlotName.HOTSPOT_TAGGED:
          viewModel = HotSpotController.getInstance();
          break;
        case FASlotName.CAST:
          viewModel = CastToggleController.getInstance();
          break;
        case FASlotName.LOCATION:
          viewModel = LocationController.getInstance();
          break;
        case FASlotName.YOUTH_MODE:
          viewModel = new JuvenileModeToggleController();
          break;
        case FASlotName.POWER_SAVE:
          viewModel = new PowerSavingToggleController();
          break;
        case FASlotName.NEAR_LINK:
          viewModel = this.isPC ? new NearLinkToggleController() : undefined;
          break;
        case FASlotName.SUPER_PRIVACY:
          viewModel = new SuperPrivacyController();
          break;
        case FASlotName.SUPER_HUB:
          viewModel = new SuperHubToggleController();
          break;
        case FASlotName.SCREEN_RECORDER:
          viewModel = new ScreenToggleController();
          break;
        case FASlotName.MUSIC_SERVICE:
          viewModel = new MusicServiceController();
          break;
        case FASlotName.EYE_COMFORT:
          viewModel = EyeComfortToggleController.getInstance();
          break;
        case FASlotName.KEY_MOUSE_SHARE:
          viewModel = KmShareToggleController.getInstance();
          break;
        case FASlotName.SCREENSHOT:
          viewModel = new ApplicationToggleController(slot);
          break;
        case PluginSlot.SLOT_CONTROL_SCANNER:
          viewModel = new ApplicationToggleController(slot);
          break;
        case FASlotName.DPIN:
          viewModel = new DpinToggleController();
          break;
        case FASlotName.MEETING:
          viewModel = new MeetingToggleController();
          break;
        case FASlotName.MULTI_WINDOW:
          viewModel = MultiWindowToggleController.getInstance();
          break;
        case FASlotName.ANTI_PEEPING:
          viewModel = new AntiPeepingToggleController();
          break;
        case FASlotName.SCENARIO_MODE:
          viewModel = ScenarioModeToggleController.getInstance();
          break;
        case FASlotName.QUICK_NOTE:
          viewModel = new ApplicationToggleController(slot);
          break;
        default:
          if (this.pluginInfos.has(slot) && this.isPC) {
            log.showInfo('create toggle slot in pc:' + slot);
          }
          break;
      }
    } catch (error) {
      log.showError('create toggle: failed' + slot + '' + error);
      return undefined;
    }
    try {
      if (!viewModel?.isAvailable(this.userId)) {
        log.showInfo('toggle is not available: ' + slot);
        return undefined;
      }
    } catch (error) {
      log.showError('toggle meet crash when detect available or not ' + slot);
      return undefined;
    }
    if (shouldInit) {
      this.initToggleModel(slot, viewModel);
    }
    return viewModel;
  }

  private refreshRemovedToggleState(): void {
    this.removedToggle = [];
    let allBundles: string[] = Array.from(this.bundleConfigMap.keys());
    if (CheckEmptyUtils.isEmptyArr(allBundles)) {
      log.showInfo('refreshRemovedToggleState no bundle record');
      return;
    }
    try {
      allBundles.forEach(bundleName => {
        if (!this.isSystemAppExist(bundleName, this.userId)) {
          this.removedToggle = this.removedToggle.concat(this.bundleConfigMap.get(bundleName) ?? []);
          log.showInfo(`refreshRemovedToggleState this.removedToggle=${this.removedToggle}`);
        }
      })
    } catch (error) {
      log.showError(`refreshRemovedToggleState error=${error}`);
    }
  }

  private initBundleToggleMap(): void {
    try {
      const valueArr: string[] =
        this.context.resourceManager.getStringArrayByNameSync('bundle_toggle_map_default');
      if (valueArr) {
        for (const strValue of valueArr) {
          if (CheckEmptyUtils.isEmpty(strValue)) {
            continue;
          }
          let bundleName: string = strValue.split(':')[0];
          let toggleNameStr: string = strValue.split(':')[1];
          if (CheckEmptyUtils.isEmpty(toggleNameStr) || CheckEmptyUtils.isEmpty(bundleName)) {
            continue;
          }
          // 包名一对多开关支持，逗号分割
          let configToggleNameArr: string[] = toggleNameStr.split(',');
          let toggleArr: string[] | undefined = this.bundleConfigMap.get(bundleName);
          if (!toggleArr) {
            toggleArr = [];
          }
          toggleArr = toggleArr.concat(configToggleNameArr);
          this.bundleConfigMap.set(bundleName, toggleArr);
          log.showInfo(`initBundleToggleMap bundleName=${bundleName} toggleList=${toggleArr}`);
        }
      }
    } catch (error) {
      log.showError(`initBundleToggleMap exception: ${error}`);
    }
    log.showInfo('initBundleToggleMap end');
  }

  private onAbilityInfoChanged(event: EventConstants, bundleName: string, userId: number): void {
    log.showInfo(`onAbilityInfoChanged event=${event} bundleName=${bundleName} userId=${userId}`);
    let mapToggles: string[] | undefined = this.bundleConfigMap.get(bundleName);
    if (mapToggles === undefined || CheckEmptyUtils.isEmptyArr(mapToggles)) {
      log.showInfo(`onAbilityInfoChanged mapToggles is empty return`);
      return;
    }
    if (event === EventConstants.EVENT_PACKAGE_ADDED) {
      this.removedToggle = this.removedToggle.filter((item) => {
        return mapToggles?.indexOf(item) ?? -1 < 0;
      })
    } else if (event === EventConstants.EVENT_PACKAGE_REMOVED) {
      this.removedToggle = this.removedToggle.concat(mapToggles);
    } else {
      return;
    }
    this.onToggleDataChange();
    log.showInfo(`onAbilityInfoChanged refreshToggleData=${this.removedToggle}`);
  }

  private isSystemAppExist(bundleName: string, userId: number): boolean {
    try {
      let applicationInfo: bundleManager.ApplicationInfo = bundleManager.getApplicationInfoSync(bundleName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT, userId);
      return applicationInfo !== undefined && applicationInfo !== null;
    } catch (error) {
      log.showError(`isSystemAppExist getApplicationInfoSync error, error=${error}`);
      return false;
    }
  }
}