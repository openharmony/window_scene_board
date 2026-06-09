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

import util from '@ohos.util';
import { BusinessError } from '@kit.BasicServicesKit';
import type abilityCommon from '@ohos.app.ability.common';
import type { EventManager } from '@ohos/frameworkwrapper';
import { CommonUtils, DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import {
  DropDownPanelManagerWrapper,
  EvtBus,
  PluginRequestEvent,
  viewMgrPolicy,
  ViewType,
  GlobalContext,
  sEventManager,
  obtainLocalEvent
} from '@ohos/frameworkwrapper';
import { FocusChangeReason } from '@ohos/windowscene/src/main/ets/common/FocusChangeReason';
import { SatelliteModeSwitchEvent } from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import { DefaultPanelZIndex } from '@ohos/systemuicommon/src/main/ets/base/common/info/DefaultPanelZIndex';
import { ToggleViewData } from './ToggleViewData';
import { ScreenStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/ScreenStatusVm';
import { ToggleScene, ToggleStyle } from '../interface/ToggleStyle'
import { ViewManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ViewManagerAdapter';
import { ScreenLockAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenLockAdapter';
import { DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { SceneSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/SceneSessionAdapter';
import { ScreenLockApiAdapter } from '../../adapter/ScreenLockApiAdapter';

const TAG = 'Model.ToggleBaseViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const UNLOCK_DELAY_TIME: number = 300;
const HANDLE_DELAY_TIME: number = 100;
const REDUCE_CONTROL_CENTER_HIERARCHY: number = 1990;

// copy from ./unlock/ScreenLockMediator.ets::ScreenLockStatus
enum ScreenLockStatus {
  LOCKING = 1,
  UNLOCK = 2
}

/**
 * Controller基类
 */
export abstract class ToggleBaseViewModel {
  // 打开二级界面
  public openDetailPageFunc: ((toggleId?: string) => void) | undefined = undefined;
  // 长按跳转
  public startServiceFunc: (() => void) | undefined = undefined;
  // 定制数据
  public customCommonData: CustomCommonData = new CustomCommonData();
  protected records: Record<string, object | null> = {};
  protected isAlreadyLoadLottie: boolean = false;
  private _isInit: boolean = false;

  /**
   * 状态栏图标可见性事件
   */
  protected sbPluginRequest: PluginRequestEvent = PluginRequestEvent.create(this.getSbPluginSlot(),
    PluginRequestEvent.REQUEST_TYPE_VISIBILITY, PluginRequestEvent.VALUE_VISIBILITY_GONE);

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  private handle: Function = () => {
  };

  protected viewData: ToggleViewData = new ToggleViewData();
  protected toggleId: string = '';
  protected isSatelliteMode: boolean = false;

  /**
   * plugin请求事件生产者
   *
   * @param slot plugin唯一标示
   * @return 事件
   */
  protected onProducePluginRequestEvent(slot?: string): PluginRequestEvent | null {
    if (slot != this.getSbPluginSlot()) {
      return null;
    }
    return this.sbPluginRequest;
  }

  /**
   * 移除lottie缓存
   */
  removeAllLottieData(): void {
    log.showInfo('removeAllLottieData');
    this.records.lottieDataOpenDark = null;
    this.records.lottieDataCloseDark = null;
    this.records.lottieDataOpen = null;
    this.records.lottieDataClose = null;
    this.records = {};
    this.isAlreadyLoadLottie = false;
  }

  /**
   * 初始化lottie缓存
   */
  initLottieData(): void {
    log.showInfo(`initAllLottieData isAlreadyLoadLottie=${this.isAlreadyLoadLottie},isLoadLottie=${this.isLoadLottie()},toggleId=${this.toggleId}`);
    if (this.isLoadLottie() && !this.isAlreadyLoadLottie) {
      this.isAlreadyLoadLottie = true;
      log.showDebug('initLottieData');
      if (!CommonUtils.isEmpty(this.getLottieOpenDarkName())) {
        this.loadLottieData(this.getLottieOpenDarkName(), (value) => {
          this.records.lottieDataOpenDark = value;
        });
      }
      if (!CommonUtils.isEmpty(this.getLottieCloseDarkName())) {
        this.loadLottieData(this.getLottieCloseDarkName(), (value) => {
          this.records.lottieDataCloseDark = value;
        });
      }
    }
  }

  /**
   * 是否使用深色模式关闭lottie
   */
  isDarkReverse(): boolean {
    return false;
  }

  /**
   * 获取开启lottie对象
   */
  getOpenLottieData(): object | null {
    return this.records.lottieDataOpen;
  }

  /**
   * 获取关闭lottie
   */
  getCloseLottieData(): object | null {
    return this.records.lottieDataClose;
  }

  /**
   * 根据状态获取动画
   *
   * @param isDarkMode 是否深色模式开启
   */
  matchLottieData(isDarkMode: boolean): object | null {
    if (isDarkMode) {
      if (this.getViewData().isOn) {
        return this.records.lottieDataOpenDark;
      } else {
        return this.records.lottieDataCloseDark;
      }
    } else {
      if (this.getViewData().isOn) {
        return this.records.lottieDataOpen;
      } else {
        return this.records.lottieDataClose;
      }
    }
  }

  /**
   * 获取开启动画lottie名称
   */
  getLottieOpenName(): string {
    return '';
  }

  /**
   * 获取开启动画新lottie名称
   */
  getNewLottieOpenName(): string {
    return '';
  }

  /**
   * 获取开启关闭lottie名称
   */
  getLottieCloseName(): string {
    return '';
  }

  /**
   * 获取开启新关闭lottie名称
   */
  getNewLottieCloseName(): string {
    return '';
  }

  /**
   * 获取深色模式开启动画lottie名称
   */
  getLottieDarkName(): string {
    return '';
  }

  getLottieOpenDarkName(): string {
    return '';
  }

  getLottieCloseDarkName(): string {
    return '';
  }

  /**
   * 是否需要加载lottie
   */
  isLoadLottie(): boolean {
    return false;
  }

  /* 加载对应的动画 */
  public loadLottieData(jsonName: string, callback: (value: object) => void): void {
    log.showDebug('loadLottieData, jsonName = ' + jsonName);
    let resStr: util.TextDecoder = new util.TextDecoder('utf-8', {
      ignoreBOM: true
    });
    try {
      let context: abilityCommon.ServiceExtensionContext = GlobalContext.getContext();
      context.resourceManager.getRawFile(jsonName, (err: Error, data: Uint8Array) => {
        try {
          if (data === null || data === undefined || data.buffer === undefined) {
            log.showError(`loadLottieData getRawFile error:${err?.message}`);
            return;
          }
          let lottieStr: string = resStr.decode(new Uint8Array(data.buffer));
          let lottieData: object = JSON.parse(lottieStr);
          log.showInfo(`loadLottieData, lottieData: ${jsonName}`);
          if (callback) {
            callback(lottieData);
          }
        } catch (err) {
          log.showError(`loadLottieData ${jsonName} err: ${err?.code} - ${err?.name}`);
        }
      });
    } catch (err) {
      log.showError('context is undefined');
    }
  }

  /* 异步加载对应的动画 */
  public async loadLottieDataAsync(jsonName: string, callback: (value: object) => void): Promise<void> {
    log.showDebug('loadLottieDataAsync, jsonName = ' + jsonName);
    let resStr: util.TextDecoder = new util.TextDecoder('utf-8', {
      ignoreBOM: true
    });
    let context: abilityCommon.ServiceExtensionContext = GlobalContext.getContext();
    try {
      let data = await context.resourceManager.getRawFile(jsonName).catch((err: BusinessError) => {
        log.showError(`loadLottieDataAsync getRawFile failed, err: ${err.message}`);
      });
      if (data) {
        let lottieStr: string = resStr.decode(new Uint8Array(data.buffer));
        let lottieData: object = JSON.parse(lottieStr);
        if (callback) {
          callback(lottieData);
        }
        log.showInfo(`loadLottieDataAsync, lottieData: ${jsonName}`);
      }
    } catch (err) {
      log.showError(`loadLottieDataAsync failed, err: ${err.message}`);
    }
  }

  /**
   * 是否需要监听卫星通信状态
   */
  needListenSatelliteMode(): boolean {
    return false;
  }

  /**
   * 更新快捷开关的置灰状态
   */
  updateDisableState(): void {
  }

  /**
   * 初始化Controller
   */
  onStart(): void {
    TraceUtil.startTrace(DomainName.CC, 'CreateBaseToggle');
    log.showInfo('ToggleBaseViewModel onStart' + this.toggleId);
    // 存在slot，注册可见性事件生产者
    if (!CommonUtils.isEmpty(this.getSbPluginSlot())) {
      this.eventMgr.produceOn(PluginRequestEvent,
        (slot?: string): PluginRequestEvent | null => this.onProducePluginRequestEvent(slot));
    }
    if (this.needListenSatelliteMode()) {
      this.eventMgr.on(SatelliteModeSwitchEvent, (event: SatelliteModeSwitchEvent): void => {
        if (event === undefined) {
          return;
        }
        this.isSatelliteMode = event.satelliteModeSwitch();
        log.showInfo('onSatelliteModeSwitchEvent switch: ' + this.isSatelliteMode);
        this.updateDisableState();
      });
    }
    TraceUtil.endTrace(DomainName.CC, 'CreateBaseToggle');
  }

  isInit(): boolean {
    return this._isInit;
  }

  initData(toggleId: string) {
    this.toggleId = toggleId;
  }

  decorateStyle(style: ToggleStyle, scene?: ToggleScene): ToggleStyle | undefined {
    return style;
  }

  /**
   * 销毁Controller
   */
  onStop(): void {
    this.eventMgr.offAll();
  }

  // 是否是单例
  isPersist(): boolean {
    return false;
  }

  /**
   * 处理状态刷新
   */
  handleUpdateState(): void {
  };

  /**
   * 是否可用
   */
  abstract isAvailable(userId?: number): boolean;

  /**
   * 状态栏plugin图标唯一标示
   *
   * @return 默认无
   */
  getSbPluginSlot(): string {
    return '';
  }

  /**
   * 添加状态监听
   */
  addStateChangedListener(): void {
  };

  /**
   * 移除状态监听
   */
  removeStateChangedListener(): void {
  };

  handleOneClick(): void {

  }

  /**
   * 刷新开关图标
   */
  updateIcon(): void {
  }

  getViewData(): ToggleViewData {
    if (this.viewData == null) {
      this.viewData = new ToggleViewData();
      return this.viewData;
    } else {
      return this.viewData;
    }
  }

  // 代表开关现在的状态
  getState(): number {
    return this.getViewData().isOn ? 1 : 0;
  }

  handleClickWithScreenLock(handle: Function): void {
    if (ScreenLockApiAdapter.isUseNewScreenLock()) {
      if (!ScreenLockApiAdapter.isScreenLockShow()) {
        log.showInfo('page not show, do handle direct.');
        handle?.();
      } else {
        log.showInfo('page show, request lock.');
        AppStorage.setOrCreate('isAnimToHide', true);
        ScreenLockAdapter.requestUnlockScreenLockUnlockService({success: handle}, `${TAG}_requestUnlockScreenLockUnlockService`);
      }
      return;
    }
    this.handle = handle;
    if (ScreenLockAdapter.getLock()) {
      let status = AppStorage.get('lockStatus') as number;
      if (status !== ScreenLockStatus.UNLOCK) {
        ScreenLockAdapter.requestUnlock({
          success: this.handleClickIfUnlock,
          withDelay: true
        }, `${TAG}_requestUnlock`);
        AppStorage.setOrCreate('isAnimToHide', true);
        return;
      }
      ScreenLockAdapter.unlockWhenNoPsw();
    }
    handle();
  }

  protected handleClickIfUnlock(): void {
    log.showInfo('handleClickIfUnlock');
    let status: number = AppStorage.get('lockStatus') as number;
    if (status === ScreenLockStatus.UNLOCK) {
      this.handle();
    }
  }

  /**
   * 处理点击事件-在锁屏和锁屏编辑页面场景下均解锁后操作
   *
   * @param handle handle
   */
  handleClickWithScreenLockAndEdit(handle: Function): void {
    if (ScreenLockApiAdapter.isUseNewScreenLock()) {
      if (!ScreenLockApiAdapter.isScreenLockShow()) {
        log.showInfo('page not show, do handle direct.');
        handle?.();
      } else {
        log.showInfo('page show, request lock.');
        AppStorage.setOrCreate('isAnimToHide', true);
        ScreenLockAdapter.requestUnlockScreenLockUnlockService({success: handle}, `${TAG}_requestUnlockScreenLockUnlockService`);
      }
      return;
    }
    this.handle = handle;
    if (ScreenLockAdapter.getLock() || AppStorage.get('isHomeVisible') === true) {
      let status = AppStorage.get('lockStatus') as number;
      if (status !== ScreenLockStatus.UNLOCK) {
        ScreenLockAdapter.requestUnlock({
          success: this.handleClickIfUnlock,
          withDelay: true
        }, `${TAG}_requestUnlock`);
        AppStorage.setOrCreate('isAnimToHide', true);
        return;
      }
      ScreenLockAdapter.unlockWhenNoPsw();
    }
    handle();
  }

  protected handleGoSettingIfUnlock(): void {
    log.showInfo('handleGoSettingIfUnlock');
    let status: number = AppStorage.get('lockStatus') as number;
    if (status === ScreenLockStatus.UNLOCK) {
      // 解锁后拉起桌面应用
      ScreenLockAdapter.notifyUnlockTransitionForPc();
      this.goSettingWithDelay(UNLOCK_DELAY_TIME);
    }
  }

  handleGoSettingWithScreenLock(handle: Function): void {
    if (ScreenLockApiAdapter.isUseNewScreenLock()) {
      if (!ScreenLockApiAdapter.isScreenLockShow()) {
        log.showInfo('page not show, do handle direct.');
        handle?.();
      } else {
        log.showInfo('page show, request lock.');
        AppStorage.setOrCreate('isAnimToHide', true);
        ScreenLockAdapter.requestUnlockScreenLockUnlockService({
          success: () => {
            this.handle = handle;
            this.goSettingWithDelay(UNLOCK_DELAY_TIME);
          }
        }, `${TAG}_requestUnlockScreenLockUnlockService`);
      }
      return;
    }
    this.handle = handle;
    if (ScreenLockAdapter.getLock()) {
      let status = AppStorage.get('lockStatus') as number;
      if (status !== ScreenLockStatus.UNLOCK) {
        ScreenLockAdapter.requestUnlock({
          authResultSuccess: this.handleGoSettingIfUnlock,
          withDelay: true
        }, `${TAG}_requestUnlock`);
        AppStorage.setOrCreate('isAnimToHide', true);
        return;
      }
      ScreenLockAdapter.unlockWhenNoPsw();
      AppStorage.setOrCreate('isAnimToHide', true);
      this.goSettingWithDelay(UNLOCK_DELAY_TIME);
      return;
    }
    handle();
  }

  /**
   * 延时启动锁屏界面跳转设置界面
   */
  goSettingWithDelay(delay: number): void {
    setTimeout(() => {
      this.handle();
    }, delay);
  }

  /**
   * 延时调用handle
   */
  handleDelay(delay: number, handle: Function): void {
    setTimeout(() => {
      handle();
    }, delay);
  }

  async requestUnlock(handle: Function, beforeUnlock: boolean): Promise<void> {
    log.showInfo('requestUnlock');
    // 请求解锁
    if (ScreenLockApiAdapter.isUseNewScreenLock()) {
      let notSuccess: Function = () => {
        // 解锁失败，收起控制中心
        DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
        // 恢复层级
        ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
      };
      ScreenLockAdapter.requestUnlockScreenLockUnlockService({
        authResultSuccess: async () => {
          if (!beforeUnlock) {
            handle();
          }
          // 解锁成功，恢复层级
          ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
          SceneSessionAdapter.requestFocus(await ViewManagerAdapter.getDropDownId(),
            undefined, FocusChangeReason.MOVE_UP);
        },
        cancel: notSuccess,
        fail: notSuccess
      }, `${TAG}_requestUnlockScreenLockUnlockService`);
    } else {
      ScreenLockAdapter.requestUnlock({
        authResultSuccess: async () => {
          if (!beforeUnlock) {
            handle();
          }
          // 解锁成功，恢复层级
          ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
          SceneSessionAdapter.requestFocus(await ViewManagerAdapter.getDropDownId(), undefined,
            FocusChangeReason.MOVE_UP);
        },
        withDelay: true,
        cancelCallback: () => {
          // 解锁失败，收起控制中心
          DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
          // 恢复层级
          ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
        }
      }, `${TAG}_requestUnlock`);
    }
    let persistentId = await ViewManagerAdapter.getDropDownId();
    log.showInfo(`requestUnlock persistentId: ${persistentId} release focus`);
    SceneSessionAdapter.requestUnfocus(persistentId, FocusChangeReason.BACKGROUND);
    // 降低控制中心层级
    ViewManagerAdapter.setDropDownZIndex(REDUCE_CONTROL_CENTER_HIERARCHY);
    // 跳转；播控中心无法动态改变层级，解锁后再跳转
    if (beforeUnlock) {
      handle();
    }
  }

  handleOnControlCenterWithScreenLock(handle: Function, beforeUnlock: boolean = true): void {
    if (ScreenLockApiAdapter.isUseNewScreenLock()) {
      if (!ScreenLockApiAdapter.isScreenLockShow()) {
        log.showInfo('page not show, do handle direct.');
        handle?.();
      } else {
        log.showInfo('page show, request lock.');
        if (!ScreenLockAdapter.isLocked()) {
          // 无密码：先跳转，后解锁
          handle?.();
          ScreenLockAdapter.requestUnlockScreenLockUnlockService({}, `${TAG}_requestUnlockScreenLockUnlockService`);
        } else {
          this.requestUnlock(handle, beforeUnlock);
        }
      }
      return;
    }
    if (ScreenLockAdapter.getLock()) {
      let status = AppStorage.get('lockStatus') as number;
      if (status !== ScreenLockStatus.UNLOCK) {
        this.requestUnlock(handle, beforeUnlock);
        return;
      }
      // 无密码：先跳转，后解锁
      handle();
      ScreenLockAdapter.unlockWhenNoPsw();
      return;
    }
    handle();
  }

  /**
   * 由于UIExtension安全策略发生变化，锁屏下控制中心下拉适配，需要直接显示二级界面
   *
   * @param handle 回调函数
   */
  handleOnControlCenterWithScreenLockForUIE(handle: Function,
    hasSubPage: boolean = false, beforeUnlock: boolean = true): void {
    log.showInfo(`handleOnControlCenterWithScreenLockForUIE: hasSubPage=${hasSubPage} beforeUnlock=${beforeUnlock}`);
    if (ScreenLockApiAdapter.isScreenLockShow()) {
      let status = AppStorage.get('lockStatus') as number;
      if (status !== ScreenLockStatus.UNLOCK) {
        if (hasSubPage) {
          // 锁屏有密码场景延迟拉起二级页
          this.handleDelay(HANDLE_DELAY_TIME, handle);
        }
        this.requestUnlockForUIE(handle, hasSubPage);
        return;
      }
      if (beforeUnlock) {
        // 无密码：先处理，后解锁
        handle();
        ScreenLockAdapter.unlockWhenNoPsw();
        if (hasSubPage) {
          sEventManager.publish(obtainLocalEvent('ControlCenterLockStatus', ScreenLockStatus.UNLOCK));
        }
      } else {
        // 无密码：先解锁，后处理
        ScreenLockAdapter.unlockWhenNoPsw();
        handle();
      }
      return;
    }
    handle();
  }

  async requestUnlockForUIE(handle: Function, hasSubPage: boolean): Promise<void> {
    let unlockSuccessCallback = async (): Promise<void> => {
      if (!hasSubPage) {
        handle();
      }
      sEventManager.publish(obtainLocalEvent('ControlCenterLockStatus', ScreenLockStatus.UNLOCK));
      // 解锁成功，恢复层级
      ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
      SceneSessionAdapter.requestFocus(await ViewManagerAdapter.getDropDownId(),
        undefined, FocusChangeReason.MOVE_UP);
    };
    let unlockCancelCallback = (): void => {
      // 解锁失败，收起控制中心
      DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
      // 恢复层级
      ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
    };
    // 请求解锁
    ScreenLockAdapter.requestUnlock({
      authResultSuccess: unlockSuccessCallback,
      cancel: unlockCancelCallback,
      withDelay: true
    }, `${TAG}_requestUnlock`);
    let persistentId = await ViewManagerAdapter.getDropDownId();
    log.showInfo(`requestUnlock persistentId: ${persistentId} release focus`);
    SceneSessionAdapter.requestUnfocus(persistentId, FocusChangeReason.BACKGROUND);
    // 降低控制中心层级
    ViewManagerAdapter.setDropDownZIndex(REDUCE_CONTROL_CENTER_HIERARCHY);
  }

  /**
   * 开关处理差异化设置数据
   */
  public setCustomCommonData(scene?: ToggleScene | undefined): void {
  }
}


export class DefaultToggleViewModel extends ToggleBaseViewModel {
  isAvailable(): boolean {
    return true;
  }
}

/**
 * 绑定数据基类
 */
export class CommonData {
  public status: boolean = false;
  public isUnavailable: boolean = false;
  public isSatelliteMode: boolean = false;
  public isAirplaneMode: boolean = false;
}

/**
 * 绑定差异化定制数据
 */
export class CustomCommonData {
  // 多产品适配：长按处理差异化时，是否支持长按跳转和拉起二级界面
  public isSupportLongClickAction: boolean = true;
  // 场景
  public scene?: ToggleScene | undefined;
}

/**
 * Plugin绑定数据基类
 */
export class PluginToggleData extends CommonData {
}

export class DefaultViewModel extends ToggleBaseViewModel {
  isAvailable(): boolean {
    return true;
  }
}